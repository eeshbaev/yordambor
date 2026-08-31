class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.isEmailVerified,
    required this.language,
    this.avatarUrl,
    this.showPhone = false,
  });

  final String id;
  final String email;
  final String fullName;
  final String phone;
  final bool isEmailVerified;
  final String language;
  final String? avatarUrl;
  final bool showPhone;
}
