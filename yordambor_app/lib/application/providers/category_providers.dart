import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/data/categories/category_repository.dart';
import 'package:yordambor/core/utils/category_label_resolver.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoryLabelResolverProvider = Provider<CategoryLabelResolver>((ref) {
  return CategoryLabelResolver(ref.watch(categoryRepositoryProvider));
});

final categoriesProvider = FutureProvider((ref) async {
  return ref.watch(categoryRepositoryProvider).loadCategories();
});
