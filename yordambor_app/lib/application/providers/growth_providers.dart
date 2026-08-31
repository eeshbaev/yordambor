import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/data/growth/achievement_repository.dart';
import 'package:yordambor/data/growth/provider_stats_repository.dart';
import 'package:yordambor/data/support/support_repository.dart';
import 'package:yordambor/domain/growth/achievement.dart';
import 'package:yordambor/domain/growth/provider_tier.dart';

final providerStatsRepositoryProvider = Provider<ProviderStatsRepository>((ref) {
  return ProviderStatsRepository();
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepository();
});

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository();
});

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepository();
});

final providerStatsProvider = FutureProvider<ProviderStats?>((ref) async {
  final userId = ref.watch(sessionProvider).user?.id;
  if (userId == null) return null;

  final mine = await ref.watch(myXizmatlarProvider.future);
  if (mine.isEmpty) {
    final completed = await ref
        .watch(providerStatsRepositoryProvider)
        .countCompletedAsProvider(userId);
    if (completed == 0) return null;
  }

  return ref.watch(providerStatsRepositoryProvider).fetchProviderStats(userId);
});

final publicProviderStatsProvider =
    FutureProvider.family<ProviderStats?, String>((ref, userId) async {
  return ref.watch(providerStatsRepositoryProvider).fetchPublicProviderStats(
        userId,
      );
});

class ProviderGrowthState {
  const ProviderGrowthState({
    required this.stats,
    required this.unlockedIds,
    required this.tips,
    required this.newlyUnlockedIds,
  });

  final ProviderStats stats;
  final List<String> unlockedIds;
  final List<ProgressTip> tips;
  final List<String> newlyUnlockedIds;
}

final providerGrowthProvider = FutureProvider<ProviderGrowthState?>((ref) async {
  final userId = ref.watch(sessionProvider).user?.id;
  if (userId == null) return null;

  final statsRepo = ref.watch(providerStatsRepositoryProvider);
  final achievementRepo = ref.watch(achievementRepositoryProvider);

  final ctx = await statsRepo.fetchAchievementContext(userId);

  if (ctx.xizmatCount == 0 && ctx.completedJobs == 0) return null;

  final stats = await statsRepo.fetchProviderStats(userId);
  final computed = computeUnlockedAchievementIds(ctx);
  final newlyUnlocked = await achievementRepo.syncUnlocks(
    profileId: userId,
    computedIds: computed,
  );

  return ProviderGrowthState(
    stats: stats,
    unlockedIds: computed,
    tips: computeProgressTips(ctx),
    newlyUnlockedIds: newlyUnlocked,
  );
});

final myAchievementsProvider = FutureProvider<Set<String>>((ref) async {
  final userId = ref.watch(sessionProvider).user?.id;
  if (userId == null) return {};

  final growth = await ref.watch(providerGrowthProvider.future);
  if (growth != null) return growth.unlockedIds.toSet();

  final achievementRepo = ref.watch(achievementRepositoryProvider);
  final stored = await achievementRepo.fetchUnlocked(userId);
  if (stored.isNotEmpty) return stored.map((e) => e.id).toSet();

  final ctx = await ref
      .watch(providerStatsRepositoryProvider)
      .fetchAchievementContext(userId);
  return computeUnlockedAchievementIds(ctx).toSet();
});

final publicAchievementsProvider =
    FutureProvider.family<List<String>, String>((ref, profileId) async {
  final unlocked =
      await ref.watch(achievementRepositoryProvider).fetchUnlocked(profileId);
  if (unlocked.isNotEmpty) return unlocked.map((e) => e.id).toList();

  final ctx = await ref
      .watch(providerStatsRepositoryProvider)
      .fetchAchievementContext(profileId);
  return computeUnlockedAchievementIds(ctx);
});
