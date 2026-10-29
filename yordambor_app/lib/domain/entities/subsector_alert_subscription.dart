import 'package:yordambor/core/constants/service_cities.dart';

class SubsectorAlertSubscription {
  const SubsectorAlertSubscription({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.subcategoryId,
    required this.providerType,
    required this.alertNewService,
    required this.alertDiscount,
    required this.alertHelpPost,
    required this.createdAt,
    required this.updatedAt,
    this.fromService = false,
    this.serviceCity,
  });

  final String id;
  final String userId;
  final String categoryId;
  final String subcategoryId;
  final String providerType;
  final bool alertNewService;
  final bool alertDiscount;
  final bool alertHelpPost;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Made for the person's own service (migration 024), not by hand. It
  /// is kept with its switches off rather than deleted, or editing the
  /// service would make it again.
  final bool fromService;

  /// Only help requests in this city ([ServiceCityIds]); null: any city.
  final String? serviceCity;

  /// One row of `subsector_alert_subscriptions`.
  factory SubsectorAlertSubscription.fromRow(Map<String, dynamic> map) {
    return SubsectorAlertSubscription(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      categoryId: map['category_id'] as String,
      subcategoryId: map['subcategory_id'] as String,
      providerType: map['provider_type'] as String,
      alertNewService: map['alert_new_service'] as bool? ?? false,
      alertDiscount: map['alert_discount'] as bool? ?? false,
      alertHelpPost: map['alert_help_post'] as bool? ?? false,
      createdAt: _parseTime(map['created_at']),
      updatedAt: _parseTime(map['updated_at'] ?? map['created_at']),
      // Both arrive with migration 024; older rows read as made by hand,
      // for any city.
      fromService: map['from_service'] as bool? ?? false,
      serviceCity: ServiceCities.normalizeStored(
        map['service_city'] as String?,
      ),
    );
  }

  static DateTime _parseTime(Object? raw) =>
      (raw is String ? DateTime.tryParse(raw) : null) ??
      DateTime.fromMillisecondsSinceEpoch(0);

  bool get hasAnyAlert =>
      alertNewService || alertDiscount || alertHelpPost;

  SubsectorAlertSubscription copyWith({
    bool? alertNewService,
    bool? alertDiscount,
    bool? alertHelpPost,
  }) {
    return SubsectorAlertSubscription(
      id: id,
      userId: userId,
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      providerType: providerType,
      alertNewService: alertNewService ?? this.alertNewService,
      alertDiscount: alertDiscount ?? this.alertDiscount,
      alertHelpPost: alertHelpPost ?? this.alertHelpPost,
      createdAt: createdAt,
      updatedAt: updatedAt,
      fromService: fromService,
      serviceCity: serviceCity,
    );
  }
}

class UpsertSubsectorAlertInput {
  const UpsertSubsectorAlertInput({
    required this.categoryId,
    required this.subcategoryId,
    required this.providerType,
    required this.alertNewService,
    required this.alertDiscount,
    required this.alertHelpPost,
  });

  final String categoryId;
  final String subcategoryId;
  final String providerType;
  final bool alertNewService;
  final bool alertDiscount;
  final bool alertHelpPost;
}
