class YordamKerakFeedItem {
  const YordamKerakFeedItem({
    required this.id,
    required this.title,
    required this.categoryLabel,
    required this.subcategoryLabel,
    required this.categoryId,
    required this.subcategoryId,
    required this.authorName,
    this.message,
    this.price,
    this.currency,
    this.startDate,
    this.durationMinutes,
    this.seekingProviderType,
    this.isDemo = false,
    this.authorId,
    this.contactPhone,
    this.showContactPhone = false,
    this.showProfile = true,
  });

  final String id;
  final String title;
  final String categoryLabel;
  final String subcategoryLabel;
  final String categoryId;
  final String subcategoryId;
  final String authorName;
  final String? message;
  final double? price;
  final String? currency;
  final DateTime? startDate;
  final int? durationMinutes;
  final String? seekingProviderType;
  final bool isDemo;
  final String? authorId;
  final String? contactPhone;
  final bool showContactPhone;
  final bool showProfile;

  bool get hasVisibleContactPhone =>
      showContactPhone &&
      contactPhone != null &&
      contactPhone!.trim().isNotEmpty;

  String? get priceLabel {
    if (price == null) return null;
    final unit = currency ?? 'UZS';
    final formatted = price! % 1 == 0 ? price!.toInt().toString() : price.toString();
    return '$formatted $unit';
  }
}
