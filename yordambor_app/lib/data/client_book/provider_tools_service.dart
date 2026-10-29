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

    final client = await _clientForDeal(kelishuv, userId);

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

  /// Brings the bookings and reminders made from [deals] up to date: an
  /// agreed deal gets (or moves) its booking, a done one is marked done
  /// with its price as earnings, a cancelled one is cancelled.
  Future<void> syncAppointments(List<Kelishuv> deals, String userId) async {
    await ensureReady();
    for (final deal in deals) {
      if (deal.startDate == null || !deal.isParty(userId)) continue;
      switch (deal.status) {
        case KelishuvStatus.jarayonda:
          final booking = await findBookingByKelishuvId(deal.id);
          if (booking == null || booking.slotStart != deal.startDate) {
            await syncFromKelishuv(deal, userId);
          }
        case KelishuvStatus.bajarildi:
          await _closeKelishuvBooking(
            deal,
            AppointmentStatus.completed,
            amount: deal.isProvider(userId) ? deal.price : null,
          );
        case KelishuvStatus.bekor:
        case KelishuvStatus.rad:
          await _closeKelishuvBooking(deal, AppointmentStatus.cancelled);
        case KelishuvStatus.muzokarada:
        case KelishuvStatus.archived:
          break;
      }
    }
  }

  /// Marks the deal's booking [status] once; a booking already in it (or
  /// none at all) is left alone.
  Future<void> _closeKelishuvBooking(
    Kelishuv deal,
    AppointmentStatus status, {
    double? amount,
  }) async {
    final booking = await findBookingByKelishuvId(deal.id);
    if (booking == null) return;
    final reminder = await _reminders.fetchByBookingId(booking.id);
    if (reminder?.status == status) return;
    await setAppointmentStatus(
      bookingId: booking.id,
      status: status,
      amount: booking.isReceiverSide ? null : amount,
      currency: deal.currency ?? 'UZS',
    );
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

    final client = await _clientForDeal(kelishuv, userId);

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

  /// The client-book entry a deal's bookings hang on. A client not saved
  /// yet is kept hidden: the booking and its reminders work, and they show
  /// in the client book only once the provider says to save them.
  Future<ClientRegistryEntry> _clientForDeal(
    Kelishuv kelishuv,
    String userId,
  ) async {
    final otherPartyId = kelishuv.otherPartyIdFor(userId);
    final clientName = kelishuv.otherPartyNameFor(userId);
    final clients = await _registry.fetchAll(includeDeleted: true);
    for (final entry in clients) {
      if (entry.yordamBorUserId == otherPartyId) return entry;
    }
    // Someone the provider added by hand under the same name.
    for (final entry in clients) {
      if (!entry.isDeleted &&
          entry.yordamBorUserId == null &&
          entry.clientName == clientName) {
        return entry;
      }
    }
    return _registry.save(
      ClientRegistryEntry(
        id: const Uuid().v4(),
        clientName: clientName,
        note: kelishuv.message,
        yordamBorUserId: otherPartyId,
        isDeleted: true,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Puts the other side of a deal in the client book: the hidden entry
  /// their bookings use comes into view, or a new one is made.
  Future<ClientRegistryEntry> saveClientFromDeal({
    required String otherPartyId,
    required String name,
  }) async {
    await ensureReady();
    for (final entry in await _registry.fetchAll(includeDeleted: true)) {
      if (entry.yordamBorUserId != otherPartyId) continue;
      if (!entry.isDeleted) return entry;
      return _registry.save(entry.copyWith(isDeleted: false));
    }
    return _registry.create(clientName: name, yordamBorUserId: otherPartyId);
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

    // A known booking moves to the agreed time; its reminder follows.
    final saved = existing != null
        ? booking.copyWith(slotStart: appointmentTime)
        : booking;
    await _bookings.save(saved);

    await _reminders.syncForBooking(
      booking: saved,
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
