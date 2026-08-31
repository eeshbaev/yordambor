import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/growth/achievement.dart';

class AchievementsChipGrid extends StatelessWidget {
  const AchievementsChipGrid({
    super.key,
    required this.unlockedIds,
    required this.strings,
    this.compact = false,
    this.showLocked = true,
  });

  final Set<String> unlockedIds;
  final AppStrings strings;
  final bool compact;
  final bool showLocked;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final definitions = showLocked
        ? AchievementCatalog.all
        : AchievementCatalog.all
            .where((def) => unlockedIds.contains(def.id))
            .toList();

    if (definitions.isEmpty) {
      return Text(
        strings.achievementsEmptySub,
        style: AppTypography.caption.copyWith(color: colors.textSecondary),
      );
    }

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final def in definitions)
          _AchievementChip(
            label: strings.achievementTitle(def.id),
            unlocked: unlockedIds.contains(def.id),
            compact: compact,
          ),
      ],
    );
  }
}

class _AchievementChip extends StatelessWidget {
  const _AchievementChip({
    required this.label,
    required this.unlocked,
    required this.compact,
  });

  final String label;
  final bool unlocked;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Chip(
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      avatar: Icon(
        unlocked ? Icons.emoji_events_outlined : Icons.lock_outline,
        size: 16,
        color: unlocked ? AppColors.primary : colors.textTertiary,
      ),
      label: Text(
        label,
        style: AppTypography.label.copyWith(
          color: unlocked ? colors.textPrimary : colors.textSecondary,
        ),
      ),
      backgroundColor: unlocked ? colors.primaryMuted : colors.surface,
      side: BorderSide(
        color: unlocked
            ? AppColors.primary.withValues(alpha: 0.2)
            : colors.borderSubtle,
      ),
    );
  }
}
