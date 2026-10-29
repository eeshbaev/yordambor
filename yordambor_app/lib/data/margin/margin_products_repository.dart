import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/domain/entities/margin_product.dart';

class MarginProductsRepository {
  static const boxName = 'margin_products';

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }
    return Hive.openBox<Map>(boxName);
  }

  Future<List<MarginProduct>> fetchAll() async {
    final box = await _box();
    return box.values
        .map((raw) => MarginProduct.fromMap(Map<dynamic, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<MarginProduct?> fetchById(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return null;
    return MarginProduct.fromMap(Map<dynamic, dynamic>.from(raw));
  }

  Future<MarginProduct> create({
    required String name,
    required double salePriceUzs,
  }) async {
    final product = MarginProduct(
      id: const Uuid().v4(),
      name: name.trim(),
      salePriceUzs: salePriceUzs,
      lines: const [],
      updatedAt: DateTime.now(),
    );
    final box = await _box();
    await box.put(product.id, product.toMap());
    return product;
  }

  Future<void> save(MarginProduct product) async {
    final box = await _box();
    await box.put(
      product.id,
      product.copyWith(updatedAt: DateTime.now()).toMap(),
    );
  }

  Future<void> delete(String id) async {
    final box = await _box();
    await box.delete(id);
  }
}
