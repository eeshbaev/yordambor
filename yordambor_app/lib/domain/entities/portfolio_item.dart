import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';

class PortfolioItem {
  const PortfolioItem({
    required this.id,
    required this.xizmatId,
    required this.imageUrl,
    required this.isHero,
    required this.sortOrder,
    this.caption,
  });

  final String id;
  final String xizmatId;
  final String imageUrl;
  final bool isHero;
  final int sortOrder;
  final String? caption;
}

class UpdateXizmatInput {
  const UpdateXizmatInput({
    required this.name,
    required this.providerType,
    required this.categoryId,
    required this.subcategoryId,
    required this.description,
    this.contactPhone,
    this.showContactPhone = false,
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

  final String name;
  final String providerType;
  final String categoryId;
  final String subcategoryId;
  final String description;
  final String? contactPhone;
  final bool showContactPhone;
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
}
