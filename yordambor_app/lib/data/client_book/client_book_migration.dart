import 'package:hive_flutter/hive_flutter.dart';
import 'package:yordambor/data/client_book/booking_repository.dart';
import 'package:yordambor/data/client_book/client_registry_repository.dart';
import 'package:yordambor/domain/entities/booking.dart';
import 'package:yordambor/domain/entities/client_book_entry.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';

/// One-time migration from legacy combined client_book_entries box.
class ClientBookMigration {
  ClientBookMigration(
    this._registry,
    this._bookings,
  );

  static const legacyBoxName = 'client_book_entries';
  static const migrationKey = 'client_book_v2_migrated';

  final ClientRegistryRepository _registry;
  final BookingRepository _bookings;

  Future<void> runIfNeeded() async {
    final flagBox = await Hive.openBox('app_flags');
    if (flagBox.get(migrationKey) == true) return;

    if (!Hive.isBoxOpen(legacyBoxName)) {
      try {
        await Hive.openBox<Map>(legacyBoxName);
      } catch (_) {
        await flagBox.put(migrationKey, true);
        return;
      }
    }

    final legacy = Hive.box<Map>(legacyBoxName);
    for (final raw in legacy.values) {
      final legacyEntry =
          ClientBookEntry.fromMap(Map<dynamic, dynamic>.from(raw));

      if (legacyEntry.slotStart == null) {
        await _registry.save(
          ClientRegistryEntry(
            id: legacyEntry.id,
            clientName: legacyEntry.clientName,
            phone: legacyEntry.phone,
            note: legacyEntry.note,
            createdAt: legacyEntry.createdAt,
          ),
        );
        continue;
      }

      var client = await _registry.fetchById(legacyEntry.id);
      client ??= await _registry.create(
        clientName: legacyEntry.clientName,
        phone: legacyEntry.phone,
        note: legacyEntry.note,
      );

      await _bookings.save(
        Booking(
          id: '${legacyEntry.id}_booking',
          clientId: client.id,
          slotStart: legacyEntry.slotStart!,
          xizmatId: legacyEntry.xizmatId,
          xizmatName: legacyEntry.xizmatName,
          kelishuvId: legacyEntry.kelishuvId,
          note: legacyEntry.note,
          createdAt: legacyEntry.createdAt,
        ),
      );
    }

    await flagBox.put(migrationKey, true);
  }
}
