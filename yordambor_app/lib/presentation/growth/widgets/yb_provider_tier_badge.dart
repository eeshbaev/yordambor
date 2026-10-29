import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
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
    final colors = _colors(context, tier);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
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

  /// The tiers climb from neutral to teal, ending on the brand teal.
  ({Color background, Color border, Color foreground}) _colors(
    BuildContext context,
    ProviderTier tier,
  ) {
    final c = context.ybColors;
    return switch (tier) {
      ProviderTier.newProvider => (
          background: c.surface2,
          border: c.surface2,
          foreground: c.ink2,
        ),
      ProviderTier.active => (
          background: c.tealSoft,
          border: c.tealSoft,
          foreground: c.tealInk,
        ),
      ProviderTier.trusted => (
          background: c.teal,
          border: c.teal,
          foreground: c.onTeal,
        ),
      ProviderTier.top => (
          background: c.tealBrand,
          border: c.tealBrand,
          foreground: c.onTeal,
        ),
    };
  }
}
