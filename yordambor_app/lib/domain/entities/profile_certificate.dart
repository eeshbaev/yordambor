class ProfileCertificate {
  const ProfileCertificate({
    required this.id,
    required this.profileId,
    required this.title,
    required this.imageUrl,
    this.issuer,
    this.sortOrder = 0,
    this.isDemo = false,
  });

  final String id;
  final String profileId;
  final String title;
  final String? issuer;
  final String imageUrl;
  final int sortOrder;
  final bool isDemo;
}

class AddProfileCertificateInput {
  const AddProfileCertificateInput({
    required this.title,
    required this.imageUrl,
    this.issuer,
  });

  final String title;
  final String? issuer;
  final String imageUrl;
}
