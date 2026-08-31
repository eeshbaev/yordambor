class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.icon,
    required this.names,
    required this.subcategories,
  });

  final String id;
  final String icon;
  final Map<String, String> names;
  final List<SubcategoryItem> subcategories;

  String label(String language) =>
      names[language] ?? names['uz'] ?? names['en'] ?? id;
}

class SubcategoryItem {
  const SubcategoryItem({
    required this.id,
    required this.names,
    required this.providerType,
  });

  final String id;
  final Map<String, String> names;
  final String providerType;

  String label(String language) =>
      names[language] ?? names['uz'] ?? names['en'] ?? id;
}
