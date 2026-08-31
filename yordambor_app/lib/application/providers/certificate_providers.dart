import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/profile/certificate_repository.dart';
import 'package:yordambor/domain/entities/profile_certificate.dart';

final certificateRepositoryProvider = Provider<CertificateRepository>((ref) {
  return CertificateRepository();
});

final profileCertificatesProvider =
    FutureProvider.family<List<ProfileCertificate>, String>((ref, profileId) {
  return ref
      .read(certificateRepositoryProvider)
      .fetchForProfile(profileId)
      .timeout(FeedConstants.networkTimeout);
});
