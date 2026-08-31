import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/demo/demo_xizmat_feed.dart';
import 'package:yordambor/data/storage/storage_repository.dart';
import 'package:yordambor/data/xizmat/xizmat_repository.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository();
});

final xizmatRepositoryProvider = Provider<XizmatRepository>((ref) {
  return XizmatRepository(ref.watch(categoryRepositoryProvider));
});

final myXizmatlarProvider = FutureProvider<List<XizmatFeedItem>>((ref) async {
  final userId = ref.watch(sessionProvider.select((s) => s.user?.id));
  if (userId == null) return [];

  final language = ref.watch(onboardingPrefsProvider.select((p) => p.language));
  return ref.read(xizmatRepositoryProvider).fetchMine(userId, language).timeout(
        FeedConstants.networkTimeout,
      );
});

final xizmatDetailProvider =
    FutureProvider.family<XizmatFeedItem?, String>((ref, id) async {
  final language = ref.watch(onboardingPrefsProvider).language;
  final demo = DemoXizmatFeed.findById(id);
  if (demo != null) {
    final resolver = ref.watch(categoryLabelResolverProvider);
    await resolver.ensureLoaded();
    return resolver.localizeXizmat(demo, language);
  }

  return ref.watch(xizmatRepositoryProvider).fetchById(id, language);
});

final favoriteXizmatlarProvider =
    FutureProvider<List<XizmatFeedItem>>((ref) async {
  final ids = ref.watch(favoritesProvider).toList();
  if (ids.isEmpty) return [];

  final language = ref.watch(onboardingPrefsProvider).language;
  final repo = ref.watch(xizmatRepositoryProvider);
  final resolver = ref.watch(categoryLabelResolverProvider);
  await resolver.ensureLoaded();
  final demoIds = ids.where((id) => id.startsWith('demo-')).toList();
  final realIds = ids.where((id) => !id.startsWith('demo-')).toList();

  final items = <XizmatFeedItem>[
    for (final id in demoIds)
      if (DemoXizmatFeed.findById(id) != null)
        resolver.localizeXizmat(DemoXizmatFeed.findById(id)!, language),
  ];

  if (realIds.isNotEmpty) {
    items.addAll(await repo.fetchByIds(realIds, language));
  }

  return [
    for (final id in ids)
      if (items.any((item) => item.id == id))
        items.firstWhere((item) => item.id == id),
  ];
});
