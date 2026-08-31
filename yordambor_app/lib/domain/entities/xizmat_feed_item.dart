import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';

class XizmatFeedItem {
  const XizmatFeedItem({
    required this.id,
    required this.name,
    required this.categoryLabel,
    required this.subcategoryLabel,
    required this.categoryId,
    required this.subcategoryId,
    required this.heroImageUrl,
    required this.rating,
    required this.completedCount,
    this.isDemo = false,
    this.description,
    this.portfolioImageUrls = const [],
    this.providerType = 'individual',
    this.ownerId,
    this.ownerName,
    this.ownerAvatarUrl,
    this.contactPhone,
    this.showContactPhone = false,
    this.showProfile = true,
    this.pricingModel = XizmatPricingModel.negotiable,
    this.basePrice,
    this.currency = 'UZS',
    this.minDurationMinutes,
    this.availabilityVisible = false,
    this.availabilityMode,
    this.availabilityFrom,
    this.availabilityUntil,
    this.showServicePromise = false,
    this.servicePromise,
    this.serviceCity,
  });

  final String id;
  final String name;
  final String categoryLabel;
  final String subcategoryLabel;
  final String categoryId;
  final String subcategoryId;
  final String heroImageUrl;
  final double rating;
  final int completedCount;
  final bool isDemo;
  final String? description;
  final List<String> portfolioImageUrls;
  final String providerType;
  final String? ownerId;
  final String? ownerName;
  final String? ownerAvatarUrl;
  final String? contactPhone;
  final bool showContactPhone;
  final bool showProfile;
  final XizmatPricingModel pricingModel;
  final double? basePrice;
  final String currency;
  final int? minDurationMinutes;
  final bool availabilityVisible;
  final XizmatAvailabilityMode? availabilityMode;
  final DateTime? availabilityFrom;
  final DateTime? availabilityUntil;
  final bool showServicePromise;
  final String? servicePromise;
  final String? serviceCity;

  bool get hasServiceCity {
    final city = serviceCity?.trim();
    return city != null && city.isNotEmpty;
  }

  bool get hasVisibleContactPhone =>
      showContactPhone &&
      contactPhone != null &&
      contactPhone!.trim().isNotEmpty;

  String get displayOwnerName {
    final name = ownerName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'Foydalanuvchi';
  }

  /// Drops a leading owner prefix like "Dilnoza — …" when the profile is shown nearby.
  String get serviceDisplayName {
    final owner = ownerName?.trim();
    if (owner == null || owner.isEmpty) return name;

    const separator = ' — ';
    final prefix = '$owner$separator';
    if (name.startsWith(prefix)) {
      return name.substring(prefix.length);
    }
    return name;
  }

  /// Home feed card title: service for individuals, subcategory for institutions.
  String get feedCardTitle =>
      providerType == 'institution' ? subcategoryLabel : serviceDisplayName;

  bool get showsOwnerProfile =>
      ownerId != null || (ownerName?.trim().isNotEmpty ?? false);

  /// Provider line under the feed card title (person or company name).
  bool get showsOwnerNameLine {
    if (!showsOwnerProfile) return false;
    if (providerType == 'institution') return true;
    return displayOwnerName.toLowerCase() !=
        serviceDisplayName.toLowerCase();
  }

  String? get visibleServicePromise {
    if (!showServicePromise) return null;
    final text = servicePromise?.trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  List<String> get galleryUrls {
    if (portfolioImageUrls.isNotEmpty) return portfolioImageUrls;
    if (heroImageUrl.isNotEmpty) return [heroImageUrl];
    return const [];
  }
}
