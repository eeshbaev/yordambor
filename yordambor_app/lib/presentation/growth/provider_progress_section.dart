import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_load_error_retry.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/presentation/growth/widgets/achievements_chip_grid.dart';
import 'package:yordambor/domain/growth/provider_tier.dart';
import 'package:yordambor/presentation/growth/widgets/yb_provider_tier_badge.dart';

class ProviderProgressSection extends ConsumerWidget {
  const ProviderProgressSection({
    super.key,
    this.embedded = false,
    this.showAchievements = true,
  });

  final bool embedded;
  final bool showAchievements;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final growthAsync = ref.watch(providerGrowthProvider);

    return growthAsync.when(
      loading: () => _ProviderProgressPlaceholder(
        embedded: embedded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const YbSkeletonBox(width: 160, height: 18),
            const SizedBox(height: AppSpacing.sm),
            const YbSkeletonBox(width: double.infinity, height: 14),
            const SizedBox(height: AppSpacing.md),
            const YbSkeletonBox(width: 120, height: 24),
          ],
        ),
      ),
      error: (_, _) => _ProviderProgressPlaceholder(
        embedded: embedded,
        child: YbLoadErrorRetry(
          message: strings.profileSectionLoadFailed,
          retryLabel: strings.actionRetry,
          onRetry: () => ref.invalidate(providerGrowthProvider),
        ),
      ),
      data: (growth) {
        if (growth == null) {
          return _ProviderProgressPlaceholder(
            embedded: embedded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  strings.providerProgressTitle,
                  style: AppTypography.headline,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  strings.providerProgressSubtitle,
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppSpacing.md),
                YbInlineMessage(
                  message: strings.createXizmatFirst,
                  tone: YbInlineMessageTone.info,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (showAchievements) ...[
                  Text(strings.achievementsTitle, style: AppTypography.label),
                  const SizedBox(height: AppSpacing.sm),
                  AchievementsChipGrid(
                    unlockedIds: const {},
                    strings: strings,
                  ),
                ],
              ],
            ),
          );
        }

        final stats = growth.stats;
        final ratingText = stats.hasRating
            ? stats.averageRating.toStringAsFixed(1)
            : '—';

        final body = Padding(
          padding: EdgeInsets.all(embedded ? 0 : AppSpacing.lg),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.providerProgressTitle,
                            style: AppTypography.headline,
                          ),
                          Text(
                            strings.providerProgressSubtitle,
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    YbProviderTierBadge(
                      tier: stats.tier,
                      strings: strings,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  strings.providerJobsRating(stats.completedJobs, ratingText),
                  style: AppTypography.title.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                if (stats.jobsUntilNextTier != null &&
                    stats.nextTier != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  LinearProgressIndicator(
                    value: _progressValue(stats),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    strings.providerNextMilestone(
                      stats.jobsUntilNextTier!,
                      strings.providerTierLabel(stats.nextTier!),
                    ),
                    style: AppTypography.caption,
                  ),
                ],
                if (growth.tips.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(strings.providerTipsTitle, style: AppTypography.label),
                  const SizedBox(height: AppSpacing.sm),
                  ...growth.tips.map(
                    (tip) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.check_circle_outline, size: 20),
                      title: Text(strings.progressTipLabel(tip.id)),
                      trailing: tip.guideSlug != null
                          ? const Icon(Icons.chevron_right, size: 18)
                          : null,
                      onTap: tip.guideSlug != null
                          ? () => context.push('/guides/${tip.guideSlug}')
                          : null,
                    ),
                  ),
                ],
                if (showAchievements) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(strings.achievementsTitle, style: AppTypography.label),
                  const SizedBox(height: AppSpacing.sm),
                  AchievementsChipGrid(
                    unlockedIds: growth.unlockedIds.toSet(),
                    strings: strings,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => context.push('/guides'),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: Text(strings.guidesTitle),
                  ),
                ),
              ],
            ),
          );

        if (embedded) return body;
        return Card(child: body);
      },
    );
  }

  double _progressValue(ProviderStats stats) {
    final jobs = stats.completedJobs;
    final until = stats.jobsUntilNextTier;
    if (until == null || until <= 0) return 1;
    final target = jobs + until;
    if (target <= 0) return 0;
    return (jobs / target).clamp(0.05, 1.0);
  }
}

class _ProviderProgressPlaceholder extends StatelessWidget {
  const _ProviderProgressPlaceholder({
    required this.embedded,
    required this.child,
  });

  final bool embedded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: EdgeInsets.all(embedded ? 0 : AppSpacing.lg),
      child: child,
    );
    if (embedded) return body;
    return Card(child: body);
  }
}

class PublicAchievementsRow extends ConsumerWidget {
  const PublicAchievementsRow({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final achievementsAsync = ref.watch(publicAchievementsProvider(profileId));

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.achievementsTitle, style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          achievementsAsync.when(
            loading: () => const YbSkeletonBox(width: double.infinity, height: 36),
            error: (_, _) => Text(
              strings.profileSectionLoadFailed,
              style: AppTypography.caption.copyWith(
                color: context.ybColors.textSecondary,
              ),
            ),
            data: (ids) => AchievementsChipGrid(
              unlockedIds: ids.toSet(),
              strings: strings,
              compact: true,
              showLocked: false,
            ),
          ),
        ],
      ),
    );
  }
}
