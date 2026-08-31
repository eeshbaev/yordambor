import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/growth/provider_tier.dart';

class YbProviderTierBadge extends StatelessWidget {
  const YbProviderTierBadge({
    super.key,
    required this.tier,
    required this.strings,
    this.compact = false,
  });

  final ProviderTier tier;
  final AppStrings strings;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label = strings.providerTierLabel(tier);
    final colors = _colors(tier);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w600,
          fontSize: compact ? 11 : null,
        ),
      ),
    );
  }

  ({Color background, Color border, Color foreground}) _colors(ProviderTier tier) {
    return switch (tier) {
      ProviderTier.newProvider => (
          background: AppColors.skeleton,
          border: AppColors.border,
          foreground: AppColors.textSecondary,
        ),
      ProviderTier.active => (
          background: AppColors.primaryMuted,
          border: AppColors.primary.withValues(alpha: 0.2),
          foreground: AppColors.primary,
        ),
      ProviderTier.trusted => (
          background: const Color(0xFFECFDF5),
          border: const Color(0xFF10B981).withValues(alpha: 0.3),
          foreground: const Color(0xFF059669),
        ),
      ProviderTier.top => (
          background: const Color(0xFFFFFBEB),
          border: const Color(0xFFF59E0B).withValues(alpha: 0.4),
          foreground: const Color(0xFFD97706),
        ),
    };
  }
}
