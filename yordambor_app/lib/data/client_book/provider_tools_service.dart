import 'package:uuid/uuid.dart';
import 'package:yordambor/data/client_book/booking_repository.dart';
import 'package:yordambor/data/client_book/client_book_migration.dart';
import 'package:yordambor/data/client_book/client_registry_repository.dart';
import 'package:yordambor/data/client_book/local_booking_photo_store.dart';
import 'package:yordambor/data/earnings/earnings_repository.dart';
import 'package:yordambor/data/reminders/reminders_repository.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/booking.dart';
import 'package:yordambor/domain/entities/client_booking_stats.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_sync_result.dart';

class BookingWithClient {
  const BookingWithClient({required this.booking, required this.client});

  final Booking booking;
  final ClientRegistryEntry client;

  String get clientName => client.clientName;
  DateTime get slotStart => booking.slotStart;
}

class ProviderToolsService {
  ProviderToolsService(
    this._registry,
    this._bookings,
    this._reminders,
    this._earnings,
    this._migration,
  );

  final ClientRegistryRepository _registry;
  final BookingRepository _bookings;
  final RemindersRepository _reminders;
  final EarningsRepository _earnings;
  final ClientBookMigration _migration;

  Future<void> ensureReady() => _migration.runIfNeeded();

  Future<ClientRegistryEntry> createClient({
    required String clientName,
    String? phone,
    String? note,
    String? yordamBorUserId,
  }) {
    return _registry.create(
      clientName: clientName,
      phone: phone,
      note: note,
      yordamBorUserId: yordamBorUserId,
    );
  }

  Future<void> updateClient(ClientRegistryEntry client) =>
      _registry.save(client);

  Future<void> deleteClientFromRegistry(String clientId) =>
      _registry.softDelete(clientId);

  Future<List<BookingWithClient>> fetchBookingsWithClients() async {
    await ensureReady();
    final clients = await _registry.fetchAll(includeDeleted: true);
    final clientMap = {for (final client in clients) client.id: client};
    final bookings = await _bookings.fetchAll();
    return bookings
        .where((booking) => clientMap.containsKey(booking.clientId))
        .map(
          (booking) => BookingWithClient(
            booking: booking,
            client: clientMap[booking.clientId]!,
          ),
        )
        .toList();
  }

  Future<List<Booking>> fetchBookingsForClient(String clientId) =>
      _bookings.fetchForClient(clientId);

  Future<BookingWithClient> createBooking({
    required String clientId,
    required DateTime slotStart,
    String? xizmatName,
    String? kelishuvId,
    String? note,
    bool isReceiverSide = false,
  }) async {
    await ensureReady();
    final client = await _registry.fetchById(clientId);
    if (client == null || client.isDeleted) {
      throw StateError('Client not found');
    }

    final booking = await _bookings.create(
      clientId: clientId,
      slotStart: slotStart,
      xizmatName: xizmatName,
      kelishuvId: kelishuvId,
      note: note,
      isReceiverSide: isReceiverSide,
    );

    await _reminders.syncForBooking(
      booking: booking,
      client: client,
    );

    return BookingWithClient(booking: booking, client: client);
  }

  Future<BookingWithClient> createBookingWithNewClient({
    required String clientName,
    String? phone,
    String? note,
    required DateTime slotStart,
    String? xizmatName,
  }) async {
    final client = await createClient(
      clientName: clientName,
      phone: phone,
      note: note,
    );
    return createBooking(
      clientId: client.id,
      slotStart: slotStart,
      xizmatName: xizmatName,
      note: note,
    );
  }

  Future<void> deleteAppointment(String bookingId) async {
    final booking = await _bookings.fetchById(bookingId);
    if (booking != null) {
      for (final path in booking.photoPaths) {
        await LocalBookingPhotoStore.deletePhoto(path);
      }
      await LocalBookingPhotoStore.deleteAllForBooking(bookingId);
    }
    await _bookings.delete(bookingId);
    await _reminders.deleteByBookingId(bookingId);
  }

  Future<ClientBookingStats> fetchClientStats(String clientId) async {
    final bookings = await _bookings.fetchForClient(clientId);
    final reminders = await _reminders.fetchAll();
    final statusByBooking = {
      for (final reminder in reminders)
        if (reminder.bookingId != null) reminder.bookingId!: reminder.status,
    };

    var completed = 0;
    var cancelled = 0;
    var upcoming = 0;
    var postponed = 0;
    var incomplete = 0;

    for (final booking in bookings) {
      switch (statusByBooking[booking.id] ?? AppointmentStatus.upcoming) {
        case AppointmentStatus.completed:
          completed++;
        case AppointmentStatus.cancelled:
          cancelled++;
        case AppointmentStatus.postponed:
          postponed++;
        case AppointmentStatus.incomplete:
          incomplete++;
        case AppointmentStatus.upcoming:
          upcoming++;
      }
    }

    return ClientBookingStats(
      completed: completed,
      cancelled: cancelled,
      upcoming: upcoming,
      postponed: postponed,
      incomplete: incomplete,
    );
  }

  Future<Booking?> updateBookingAppointmentNotes({
    required String bookingId,
    required String? appointmentNotes,
  }) async {
    final booking = await _bookings.fetchById(bookingId);
    if (booking == null) return null;
    final updated = booking.copyWith(appointmentNotes: appointmentNotes);
    await _bookings.save(updated);
    return updated;
  }

  Future<Booking?> addBookingPhoto({
    required String bookingId,
    required String sourcePath,
  }) async {
    final booking = await _bookings.fetchById(bookingId);
    if (booking == null) return null;
    final savedPath = await LocalBookingPhotoStore.saveFromPath(
      bookingId: bookingId,
      sourcePath: sourcePath,
    );
    final updated = booking.copyWith(
      photoPaths: [...booking.photoPaths, savedPath],
    );
    await _bookings.save(updated);
    return updated;
  }

  Future<Booking?> removeBookingPhoto({
    required String bookingId,
    required String photoPath,
  }) async {
    final booking = await _bookings.fetchById(bookingId);
    if (booking == null) return null;
    await LocalBookingPhotoStore.deletePhoto(photoPath);
    final updated = booking.copyWith(
      photoPaths:
          booking.photoPaths.where((path) => path != photoPath).toList(),
    );
    await _bookings.save(updated);
    return updated;
  }

  Future<void> setAppointmentStatus({
    required String bookingId,
    required AppointmentStatus status,
    DateTime? newSlotStart,
    double? amount,
    String currency = 'UZS',
  }) async {
    final booking = await _bookings.fetchById(bookingId);
    if (booking == null) return;

    if (status == AppointmentStatus.postponed && newSlotStart != null) {
      final updated = booking.copyWith(slotStart: newSlotStart);
      await _bookings.save(updated);
      final client = await _registry.fetchById(booking.clientId);
      if (client != null) {
        await _reminders.syncForBooking(
          booking: updated,
          client: client,
          status: AppointmentStatus.upcoming,
        );
      }
      return;
    }

    if (status == AppointmentStatus.incomplete && newSlotStart != null) {
      await _reminders.updateStatus(
        bookingId: bookingId,
        status: AppointmentStatus.incomplete,
      );
      await createBooking(
        clientId: booking.clientId,
        slotStart: newSlotStart,
        xizmatName: booking.xizmatName,
        note: booking.note,
        isReceiverSide: booking.isReceiverSide,
      );
      return;
    }

    await _reminders.updateStatus(
      bookingId: bookingId,
      status: status,
      newSlotStart: newSlotStart,
    );

    if (status == AppointmentStatus.completed &&
        amount != null &&
        !booking.isReceiverSide) {
      final client = await _registry.fetchById(booking.clientId);
      await _earnings.upsertFromBooking(
        bookingId: bookingId,
        amount: amount,
        currency: currency,
        clientName: client?.clientName ?? '',
        xizmatName: booking.xizmatName,
        kelishuvId: booking.kelishuvId,
        note: booking.note,
        recordedAt: booking.slotStart,
      );
    }
  }

  Future<KelishuvSyncResult> syncFromKelishuv(Kelishuv kelishuv, String userId) async {
    await ensureReady();
    if (kelishuv.status != KelishuvStatus.jarayonda) {
      return const KelishuvSyncResult();
    }

    final isProvider = kelishuv.isProvider(userId);
    final isReceiver = kelishuv.isClient(userId);
    if (!isProvider && !isReceiver) return const KelishuvSyncResult();

    if (isReceiver && !isProvider) {
      if (kelishuv.startDate == null) {
        return const KelishuvSyncResult(needsAppointmentDate: true);
      }
      await _syncReceiverReminderOnly(kelishuv: kelishuv, userId: userId);
      return const KelishuvSyncResult(synced: true);
    }

    final clientName = kelishuv.otherPartyNameFor(userId);
    final otherPartyId =
        kelishuv.partyAId == userId ? kelishuv.partyBId : kelishuv.partyAId;
    ClientRegistryEntry? client;
    final clients = await _registry.fetchAll(includeDeleted: true);
    for (final entry in clients) {
      if (entry.yordamBorUserId == otherPartyId ||
          entry.clientName == clientName) {
        client = entry;
        break;
      }
    }
    client ??= await _registry.create(
      clientName: clientName,
      yordamBorUserId: otherPartyId,
      note: kelishuv.message,
    );

    if (kelishuv.startDate == null) {
      return const KelishuvSyncResult(needsAppointmentDate: true);
    }

    final booking = await _upsertKelishuvBooking(
      kelishuvId: kelishuv.id,
      client: client,
      slotStart: kelishuv.startDate!,
      xizmatId: kelishuv.xizmatId,
      xizmatName: kelishuv.xizmatName,
      note: kelishuv.message,
    );

    await _reminders.syncForBooking(
      booking: booking,
      client: client,
      status: AppointmentStatus.upcoming,
    );
    return const KelishuvSyncResult(synced: true);
  }

  Future<void> setKelishuvAppointment({
    required Kelishuv kelishuv,
    required String userId,
    required DateTime slotStart,
  }) async {
    await ensureReady();
    final isProvider = kelishuv.isProvider(userId);
    final isReceiver = kelishuv.isClient(userId);

    if (isReceiver && !isProvider) {
      await _syncReceiverReminderOnly(
        kelishuv: kelishuv,
        userId: userId,
        slotStart: slotStart,
      );
      return;
    }

    if (!isProvider) return;

    final clientName = kelishuv.otherPartyNameFor(userId);
    final otherPartyId =
        kelishuv.partyAId == userId ? kelishuv.partyBId : kelishuv.partyAId;
    var client = (await _registry.fetchAll(includeDeleted: true))
        .where(
          (entry) =>
              entry.yordamBorUserId == otherPartyId ||
              entry.clientName == clientName,
        )
        .firstOrNull;
    client ??= await _registry.create(
      clientName: clientName,
      yordamBorUserId: otherPartyId,
      note: kelishuv.message,
    );

    final booking = await _upsertKelishuvBooking(
      kelishuvId: kelishuv.id,
      client: client,
      slotStart: slotStart,
      xizmatId: kelishuv.xizmatId,
      xizmatName: kelishuv.xizmatName,
      note: kelishuv.message,
    );
    await _reminders.syncForBooking(
      booking: booking,
      client: client,
      status: AppointmentStatus.upcoming,
    );
  }

  Future<Booking?> findBookingByKelishuvId(String kelishuvId) async {
    for (final booking in await _bookings.fetchAll()) {
      if (booking.kelishuvId == kelishuvId) return booking;
    }
    return null;
  }

  Future<void> completeKelishuvAppointment({
    required String kelishuvId,
    required String userId,
    double? amount,
    String currency = 'UZS',
  }) async {
    final booking = await findBookingByKelishuvId(kelishuvId);
    if (booking == null) return;

    await setAppointmentStatus(
      bookingId: booking.id,
      status: AppointmentStatus.completed,
      amount: booking.isReceiverSide ? null : amount,
      currency: currency,
    );
  }

  Future<void> cancelKelishuvAppointment(String kelishuvId) async {
    final booking = await findBookingByKelishuvId(kelishuvId);
    if (booking == null) return;
    await setAppointmentStatus(
      bookingId: booking.id,
      status: AppointmentStatus.cancelled,
    );
  }

  Future<Booking> _upsertKelishuvBooking({
    required String kelishuvId,
    required ClientRegistryEntry client,
    required DateTime slotStart,
    String? xizmatId,
    String? xizmatName,
    String? note,
  }) async {
    Booking? existing;
    for (final booking in await _bookings.fetchAll()) {
      if (booking.kelishuvId == kelishuvId) {
        existing = booking;
        break;
      }
    }

    if (existing != null) {
      final updated = existing.copyWith(
        slotStart: slotStart,
        xizmatName: xizmatName,
      );
      await _bookings.save(updated);
      return updated;
    }

    return _bookings.create(
      clientId: client.id,
      slotStart: slotStart,
      xizmatId: xizmatId,
      xizmatName: xizmatName,
      kelishuvId: kelishuvId,
      note: note,
    );
  }

  Future<void> _syncReceiverReminderOnly({
    required Kelishuv kelishuv,
    required String userId,
    DateTime? slotStart,
  }) async {
    final appointmentTime = slotStart ?? kelishuv.startDate;
    if (appointmentTime == null) return;

    final providerName = kelishuv.otherPartyNameFor(userId);
    final placeholderClient = ClientRegistryEntry(
      id: 'receiver_${kelishuv.id}',
      clientName: providerName,
      createdAt: DateTime.now(),
    );

    Booking? existing;
    for (final booking in await _bookings.fetchAll()) {
      if (booking.kelishuvId == kelishuv.id && booking.isReceiverSide) {
        existing = booking;
        break;
      }
    }

    final booking = existing ??
        Booking(
          id: const Uuid().v4(),
          clientId: placeholderClient.id,
          slotStart: appointmentTime,
          xizmatName: kelishuv.xizmatName,
          kelishuvId: kelishuv.id,
          isReceiverSide: true,
          createdAt: DateTime.now(),
        );

    if (existing != null) {
      await _bookings.save(booking.copyWith(slotStart: appointmentTime));
    } else {
      await _bookings.save(booking);
    }

    await _reminders.syncForBooking(
      booking: booking,
      client: placeholderClient,
      status: AppointmentStatus.upcoming,
    );
  }

  Future<List<BookingWithClient>> findSlotConflicts({
    required DateTime slotStart,
    String? excludeBookingId,
  }) async {
    final conflicts = await _bookings.findSlotConflicts(
      slotStart: slotStart,
      excludeBookingId: excludeBookingId,
    );
    final clients = await _registry.fetchAll(includeDeleted: true);
    final clientMap = {for (final client in clients) client.id: client};
    return conflicts
        .where((booking) => clientMap.containsKey(booking.clientId))
        .map(
          (booking) => BookingWithClient(
            booking: booking,
            client: clientMap[booking.clientId]!,
          ),
        )
        .toList();
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
