import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/data/growth/growth_prefs_stores.dart';
import 'package:yordambor/domain/growth/achievement.dart';

/// A milestone the person reached, shown once as a card on home (manual
/// H-05) instead of a sheet over whatever they were doing. Tapping it opens
/// the profile, where progress lives; closing it marks every milestone
/// reached so far as seen, so a backlog never queues up.
class MilestoneCard extends ConsumerWidget {
  const MilestoneCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(pendingMilestoneProvider).valueOrNull;

    return AnimatedSize(
      duration: AppMotion.of(context, AppMotion.standardDuration),
      curve: AppMotion.standard,
      alignment: Alignment.topCenter,
      child: id == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _MilestoneTile(
                key: ValueKey(id),
                id: id,
                onDismiss: () => _dismiss(
                  ProviderScope.containerOf(context, listen: false),
                ),
              ),
            ),
    );
  }

  /// Uses the container, not the widget's ref: the card may be gone by the
  /// time the write finishes.
  Future<void> _dismiss(ProviderContainer container) async {
    final store = container.read(achievementCelebrationStoreProvider);
    final reached =
        container.read(providerGrowthProvider).valueOrNull?.unlockedIds;
    final pending = container.read(pendingMilestoneProvider).valueOrNull;
    if (reached != null && reached.isNotEmpty) {
      await store.markAllCelebrated(reached);
    } else if (pending != null) {
      await store.markCelebrated(pending);
    }
    container.invalidate(pendingMilestoneProvider);
  }
}

class _MilestoneTile extends ConsumerWidget {
  const _MilestoneTile({
    super.key,
    required this.id,
    required this.onDismiss,
  });

  final String id;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = strings.achievementTitle(id);
    final body = strings.achievementBody(id);
    void openProgress() => context.go('/profile');

    return YbScaleTap(
      onTap: openProgress,
      hitTestBehavior: HitTestBehavior.deferToChild,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: isDark ? Border.all(color: colors.borderSubtle) : null,
          boxShadow: isDark ? null : AppElevation.card(context),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                // The card's text reads as one sentence (manual A-02); the
                // close button stays its own control.
                child: Semantics(
                  button: true,
                  label: '${strings.milestoneOverline}. $title. $body',
                  onTap: openProgress,
                  excludeSemantics: true,
                  child: Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.tealSoft,
                          borderRadius: BorderRadius.circular(AppRadius.tile),
                        ),
                        child: SizedBox.square(
                          dimension: 44,
                          child: Icon(
                            achievementIcon(id),
                            size: 22,
                            color: colors.tealInk,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.milestoneOverline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.label.copyWith(
                                color: colors.tealInk,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.headline.copyWith(
                                color: colors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.body.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                tooltip: strings.milestoneDismiss,
                icon: const Icon(YbIcons.close),
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The icon for a milestone, from its catalog entry.
IconData achievementIcon(String id) {
  for (final def in AchievementCatalog.all) {
    if (def.id == id) {
      return switch (def.iconName) {
        'handyman' => YbIcons.handyman,
        'handshake' => YbIcons.handshake,
        'star' => YbIcons.star,
        'stars' => YbIcons.stars,
        'emoji_events' => YbIcons.emojiEvents,
        'grade' => YbIcons.grade,
        'workspace_premium' => YbIcons.workspacePremium,
        'favorite' => YbIcons.favorite,
        _ => YbIcons.celebration,
      };
    }
  }
  return YbIcons.celebration;
}
