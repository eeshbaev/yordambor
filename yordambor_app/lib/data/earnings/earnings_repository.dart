import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/domain/entities/earnings_row.dart';

class EarningsRepository {
  static const boxName = 'earnings_rows';

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }
    return Hive.openBox<Map>(boxName);
  }

  Future<List<EarningsRow>> fetchAll() async {
    final box = await _box();
    return box.values
        .map((raw) => EarningsRow.fromMap(Map<dynamic, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  Future<void> upsertFromBooking({
    required String bookingId,
    required double amount,
    required String currency,
    required String clientName,
    String? xizmatName,
    String? kelishuvId,
    String? note,
    required DateTime recordedAt,
  }) async {
    final box = await _box();
    for (final raw in box.values) {
      final map = Map<dynamic, dynamic>.from(raw);
      if (map['bookingId'] == bookingId) {
        final existing = EarningsRow.fromMap(map);
        await box.put(
          existing.id,
          existing
              .copyWith(amount: amount, currency: currency, note: note)
              .toMap(),
        );
        return;
      }
    }

    final row = EarningsRow(
      id: const Uuid().v4(),
      amount: amount,
      currency: currency,
      status: 'bajarildi',
      recordedAt: recordedAt,
      xizmatName: xizmatName,
      kelishuvId: kelishuvId,
      bookingId: bookingId,
      note: note ?? clientName,
    );
    await box.put(row.id, row.toMap());
  }

  Future<void> deleteByBookingId(String bookingId) async {
    final box = await _box();
    final keysToDelete = <dynamic>[];
    for (final key in box.keys) {
      final map = Map<dynamic, dynamic>.from(box.get(key)!);
      if (map['bookingId'] == bookingId) {
        keysToDelete.add(key);
      }
    }
    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }

  Future<void> deleteRow(String id) async {
    final box = await _box();
    await box.delete(id);
  }

  Future<void> updateRow(EarningsRow row) async {
    final box = await _box();
    await box.put(row.id, row.toMap());
  }

  Future<EarningsRow> createManualRow({
    required double amount,
    String currency = 'UZS',
    String? note,
  }) async {
    final row = EarningsRow(
      id: const Uuid().v4(),
      amount: amount,
      currency: currency,
      status: 'e_lon_qilingan',
      recordedAt: DateTime.now(),
      note: note,
    );
    final box = await _box();
    await box.put(row.id, row.toMap());
    return row;
  }
}
