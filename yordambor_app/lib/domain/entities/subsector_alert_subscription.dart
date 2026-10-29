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
