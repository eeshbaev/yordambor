import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';

class ClientRegistryRepository {
  static const boxName = 'client_registry';

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }
    return Hive.openBox<Map>(boxName);
  }

  Future<List<ClientRegistryEntry>> fetchAll({bool includeDeleted = false}) async {
    final box = await _box();
    return box.values
        .map((raw) =>
            ClientRegistryEntry.fromMap(Map<dynamic, dynamic>.from(raw)))
        .where((entry) => includeDeleted || !entry.isDeleted)
        .toList()
      ..sort((a, b) => a.clientName.compareTo(b.clientName));
  }

  Future<List<ClientRegistryEntry>> fetchActive() => fetchAll();

  Future<ClientRegistryEntry?> fetchById(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return null;
    return ClientRegistryEntry.fromMap(Map<dynamic, dynamic>.from(raw));
  }

  Future<ClientRegistryEntry> save(ClientRegistryEntry entry) async {
    final box = await _box();
    await box.put(entry.id, entry.toMap());
    return entry;
  }

  Future<ClientRegistryEntry> create({
    required String clientName,
    String? phone,
    String? note,
    String? yordamBorUserId,
  }) async {
    final entry = ClientRegistryEntry(
      id: const Uuid().v4(),
      clientName: clientName,
      phone: phone,
      note: note,
      yordamBorUserId: yordamBorUserId,
      createdAt: DateTime.now(),
    );
    return save(entry);
  }

  Future<void> softDelete(String id) async {
    final entry = await fetchById(id);
    if (entry == null) return;
    await save(entry.copyWith(isDeleted: true));
  }
}
