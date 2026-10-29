import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/domain/entities/margin_unit.dart';

class MarginUnitsRepository {
  static const boxName = 'margin_units';

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }
    return Hive.openBox<Map>(boxName);
  }

  Future<List<MarginUnit>> fetchAll() async {
    final box = await _box();
    return box.values
        .map((raw) => MarginUnit.fromMap(Map<dynamic, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<MarginUnit?> fetchById(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return null;
    return MarginUnit.fromMap(Map<dynamic, dynamic>.from(raw));
  }

  Future<MarginUnit> create({
    required String name,
    required double unitCostUzs,
    String? basisLabel,
  }) async {
    final unit = MarginUnit(
      id: const Uuid().v4(),
      name: name.trim(),
      unitCostUzs: unitCostUzs,
      basisLabel: basisLabel?.trim().isEmpty == true ? null : basisLabel?.trim(),
      updatedAt: DateTime.now(),
    );
    final box = await _box();
    await box.put(unit.id, unit.toMap());
    return unit;
  }

  Future<void> update(MarginUnit unit) async {
    final box = await _box();
    await box.put(
      unit.id,
      unit.copyWith(updatedAt: DateTime.now()).toMap(),
    );
  }

  Future<void> delete(String id) async {
    final box = await _box();
    await box.delete(id);
  }
}
