class PublicUserProfile {
  const PublicUserProfile({
    required this.id,
    required this.fullName,
    this.phone,
    this.showPhone = false,
    this.bio,
    this.isDemo = false,
    this.avatarUrl,
  });

  final String id;
  final String fullName;
  final String? phone;
  final bool showPhone;
  final String? bio;
  final bool isDemo;
  final String? avatarUrl;

  bool get hasVisiblePhone =>
      phone != null && phone!.trim().isNotEmpty && showPhone;
}
