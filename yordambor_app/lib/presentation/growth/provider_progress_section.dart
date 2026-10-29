import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_count_up.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_load_error_retry.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/utils/money_format.dart';
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
                  style: AppTypography.headline.copyWith(color: context.ybColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  strings.providerProgressSubtitle,
                  style: AppTypography.caption.copyWith(color: context.ybColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                YbInlineMessage(
                  message: strings.createXizmatFirst,
                  tone: YbInlineMessageTone.info,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (showAchievements) ...[
                  Text(strings.achievementsTitle, style: AppTypography.label.copyWith(color: context.ybColors.textSecondary)),
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
                            style: AppTypography.headline.copyWith(color: context.ybColors.textPrimary),
                          ),
                          Text(
                            strings.providerProgressSubtitle,
                            style: AppTypography.caption.copyWith(color: context.ybColors.textSecondary),
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
                const SizedBox(height: AppSpacing.lg),
                _HeroStats(
                  jobs: stats.completedJobs,
                  jobsLabel: strings.statJobsDone(stats.completedJobs),
                  rating: stats.hasRating ? stats.averageRating : null,
                  ratingLabel: strings.statRating,
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
                    style: AppTypography.caption.copyWith(color: context.ybColors.textSecondary),
                  ),
                ],
                if (growth.tips.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(strings.providerTipsTitle, style: AppTypography.label.copyWith(color: context.ybColors.textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  ...growth.tips.map(
                    (tip) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(YbIcons.checkCircle, size: 20),
                      title: Text(strings.progressTipLabel(tip.id)),
                      trailing: tip.guideSlug != null
                          ? const Icon(YbIcons.chevronRightFilled, size: 18)
                          : null,
                      onTap: tip.guideSlug != null
                          ? () => context.push('/guides/${tip.guideSlug}')
                          : null,
                    ),
                  ),
                ],
                if (showAchievements) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(strings.achievementsTitle, style: AppTypography.label.copyWith(color: context.ybColors.textSecondary)),
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
                    icon: const Icon(YbIcons.menuBook),
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

/// Jobs done and rating as hero numbers that count up (manual V-04).
class _HeroStats extends StatelessWidget {
  const _HeroStats({
    required this.jobs,
    required this.jobsLabel,
    required this.rating,
    required this.ratingLabel,
  });

  final int jobs;
  final String jobsLabel;

  /// Null until the first review.
  final double? rating;
  final String ratingLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final languageCode = Localizations.localeOf(context).languageCode;
    final number = AppTypography.largeTitle.copyWith(color: colors.ink);
    final label = AppTypography.caption.copyWith(color: colors.textSecondary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YbCountUp(
                value: jobs.toDouble(),
                format: (value) => '${value.round()}',
                style: number,
              ),
              const SizedBox(height: 2),
              Text(jobsLabel, style: label),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (rating != null)
                    YbCountUp(
                      value: rating!,
                      format: (value) => formatRating(value, languageCode),
                      style: number,
                    )
                  else
                    Text('—', style: number),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(YbIcons.starFilled, size: 22, color: colors.star),
                ],
              ),
              const SizedBox(height: 2),
              Text(ratingLabel, style: label),
            ],
          ),
        ),
      ],
    );
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
          Text(strings.achievementsTitle, style: AppTypography.label.copyWith(color: context.ybColors.textSecondary)),
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
