import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/domain/entities/booking.dart';

class BookingRepository {
  static const boxName = 'bookings';

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }
    return Hive.openBox<Map>(boxName);
  }

  Future<List<Booking>> fetchAll() async {
    final box = await _box();
    return box.values
        .map((raw) => Booking.fromMap(Map<dynamic, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => a.slotStart.compareTo(b.slotStart));
  }

  Future<Booking?> fetchById(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return null;
    return Booking.fromMap(Map<dynamic, dynamic>.from(raw));
  }

  Future<List<Booking>> fetchForClient(String clientId) async {
    final all = await fetchAll();
    return all.where((booking) => booking.clientId == clientId).toList();
  }

  Future<void> save(Booking booking) async {
    final box = await _box();
    await box.put(booking.id, booking.toMap());
  }

  Future<Booking> create({
    required String clientId,
    required DateTime slotStart,
    String? xizmatId,
    String? xizmatName,
    String? kelishuvId,
    String? note,
    bool isReceiverSide = false,
  }) async {
    final booking = Booking(
      id: const Uuid().v4(),
      clientId: clientId,
      slotStart: slotStart,
      xizmatId: xizmatId,
      xizmatName: xizmatName,
      kelishuvId: kelishuvId,
      note: note,
      isReceiverSide: isReceiverSide,
      createdAt: DateTime.now(),
    );
    await save(booking);
    return booking;
  }

  Future<void> delete(String id) async {
    final box = await _box();
    await box.delete(id);
  }

  Future<List<Booking>> findSlotConflicts({
    required DateTime slotStart,
    String? excludeBookingId,
  }) async {
    final all = await fetchAll();
    return all.where((booking) {
      if (excludeBookingId != null && booking.id == excludeBookingId) {
        return false;
      }
      final slot = booking.slotStart;
      return slotStart.year == slot.year &&
          slotStart.month == slot.month &&
          slotStart.day == slot.day &&
          slotStart.hour == slot.hour &&
          slotStart.minute == slot.minute;
    }).toList();
  }
}
