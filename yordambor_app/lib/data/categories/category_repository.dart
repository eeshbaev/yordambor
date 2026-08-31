import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yordambor/domain/entities/category_item.dart';

class CategoryRepository {
  List<CategoryItem>? _cache;

  Future<List<CategoryItem>> loadCategories() async {
    if (_cache != null) return _cache!;

    final jsonString =
        await rootBundle.loadString('assets/data/categories.json');
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final categories = decoded['categories'] as List<dynamic>;

    _cache = categories.map((raw) {
      final map = raw as Map<String, dynamic>;
      final names = Map<String, String>.from(map['names'] as Map);
      final individual = (map['individual_subcategories'] as List? ?? [])
          .map(
            (item) => _parseSubcategory(
              item as Map<String, dynamic>,
              'individual',
            ),
          )
          .toList();
      final institution = (map['institution_subcategories'] as List? ?? [])
          .map(
            (item) => _parseSubcategory(
              item as Map<String, dynamic>,
              'institution',
            ),
          )
          .toList();

      return CategoryItem(
        id: map['id'] as String,
        icon: map['icon'] as String? ?? '',
        names: names,
        subcategories: [...individual, ...institution],
      );
    }).toList();

    return _cache!;
  }

  SubcategoryItem _parseSubcategory(
    Map<String, dynamic> map,
    String providerType,
  ) {
    return SubcategoryItem(
      id: map['id'] as String,
      names: Map<String, String>.from(map['names'] as Map),
      providerType: providerType,
    );
  }

  Future<CategoryItem?> findCategory(String id) async {
    final categories = await loadCategories();
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  String categoryLabelFor(String categoryId, String language) {
    final categories = _cache;
    if (categories == null) return categoryId;
    for (final category in categories) {
      if (category.id == categoryId) return category.label(language);
    }
    return categoryId;
  }

  String subcategoryLabelFor(
    String categoryId,
    String subcategoryId,
    String language,
  ) {
    final categories = _cache;
    if (categories == null) return subcategoryId;
    for (final category in categories) {
      if (category.id != categoryId) continue;
      for (final subcategory in category.subcategories) {
        if (subcategory.id == subcategoryId) {
          return subcategory.label(language);
        }
      }
    }
    return subcategoryId;
  }
}
