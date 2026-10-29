import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/data/margin/margin_products_repository.dart';
import 'package:yordambor/data/margin/margin_units_repository.dart';
import 'package:yordambor/domain/entities/margin_product.dart';
import 'package:yordambor/domain/entities/margin_unit.dart';

final marginUnitsRepositoryProvider = Provider<MarginUnitsRepository>((ref) {
  return MarginUnitsRepository();
});

final marginProductsRepositoryProvider = Provider<MarginProductsRepository>((ref) {
  return MarginProductsRepository();
});

final marginUnitsProvider = FutureProvider<List<MarginUnit>>((ref) async {
  return ref.watch(marginUnitsRepositoryProvider).fetchAll();
});

final marginProductsProvider = FutureProvider<List<MarginProduct>>((ref) async {
  return ref.watch(marginProductsRepositoryProvider).fetchAll();
});

final marginProductProvider =
    FutureProvider.family<MarginProduct?, String>((ref, id) async {
  return ref.watch(marginProductsRepositoryProvider).fetchById(id);
});
