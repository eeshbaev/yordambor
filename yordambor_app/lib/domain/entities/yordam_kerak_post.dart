import 'package:yordambor/core/utils/money_format.dart';

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
    this.serviceCity,
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

  /// Where the help is needed: a city id from [ServiceCityIds].
  final String? serviceCity;

  /// The same request, placed in [city].
  YordamKerakFeedItem withServiceCity(String? city) => YordamKerakFeedItem(
        id: id,
        title: title,
        categoryLabel: categoryLabel,
        subcategoryLabel: subcategoryLabel,
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        authorName: authorName,
        message: message,
        price: price,
        currency: currency,
        startDate: startDate,
        durationMinutes: durationMinutes,
        seekingProviderType: seekingProviderType,
        isDemo: isDemo,
        authorId: authorId,
        contactPhone: contactPhone,
        showContactPhone: showContactPhone,
        showProfile: showProfile,
        serviceCity: city,
      );

  bool get hasVisibleContactPhone =>
      showContactPhone &&
      contactPhone != null &&
      contactPhone!.trim().isNotEmpty;

  /// "350 000 soʻm".
  String? get priceLabel {
    if (price == null) return null;
    return formatMoney(price!, currency);
  }
}
