class PublicUserProfile {
  const PublicUserProfile({
    required this.id,
    required this.fullName,
    this.phone,
    this.showPhone = false,
    this.bio,
    this.isDemo = false,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String fullName;
  final String? phone;
  final bool showPhone;
  final String? bio;
  final bool isDemo;
  final String? avatarUrl;

  /// When they joined; unknown for samples.
  final DateTime? createdAt;

  bool get hasVisiblePhone =>
      phone != null && phone!.trim().isNotEmpty && showPhone;
}
