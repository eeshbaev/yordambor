import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/data/profile/public_profile_repository.dart';
import 'package:yordambor/domain/entities/public_user_profile.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

final publicProfileRepositoryProvider = Provider<PublicProfileRepository>((ref) {
  return PublicProfileRepository(
    xizmatRepository: ref.watch(xizmatRepositoryProvider),
    yordamKerakRepository: ref.watch(yordamKerakRepositoryProvider),
  );
});

final publicUserProfileProvider =
    FutureProvider.family<PublicUserProfile?, String>((ref, userId) async {
  return ref.watch(publicProfileRepositoryProvider).fetchProfile(userId);
});

final publicUserXizmatlarProvider =
    FutureProvider.family<List<XizmatFeedItem>, String>((ref, userId) async {
  final language = ref.watch(onboardingPrefsProvider).language;
  final items = await ref.watch(publicProfileRepositoryProvider).fetchXizmatlar(
        userId,
        language,
      );
  if (!userId.startsWith('demo-user-')) return items;

  final resolver = ref.watch(categoryLabelResolverProvider);
  await resolver.ensureLoaded();
  return resolver.localizeXizmatList(items, language);
});

final publicUserYordamKerakProvider =
    FutureProvider.family<List<YordamKerakFeedItem>, String>((ref, userId) async {
  final language = ref.watch(onboardingPrefsProvider).language;
  final items =
      await ref.watch(publicProfileRepositoryProvider).fetchYordamKerakPosts(
            userId,
            language,
          );
  if (!userId.startsWith('demo-user-')) return items;

  final resolver = ref.watch(categoryLabelResolverProvider);
  await resolver.ensureLoaded();
  return resolver.localizeYordamKerakList(items, language);
});
