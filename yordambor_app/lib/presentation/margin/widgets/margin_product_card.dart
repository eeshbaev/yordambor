import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/margin_product.dart';
import 'package:yordambor/presentation/margin/widgets/margin_summary_card.dart';

class MarginProductCard extends StatelessWidget {
  const MarginProductCard({
    super.key,
    required this.product,
    required this.strings,
    required this.onTap,
  });

  final MarginProduct product;
  final AppStrings strings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final margin = product.marginPercent;
    final marginColor = _marginColor(margin, colors);
    final profitColor =
        product.profitUzs >= 0 ? context.ybColors.teal : context.ybColors.error;

    return YbSurfaceCard(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTypography.headline.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    _MarginBadge(
                      label: strings.marginMarginPercent,
                      value: '${margin.toStringAsFixed(0)}%',
                      color: marginColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  strings.marginSalePrice.split(' (').first,
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  formatMarginUzs(product.salePriceUzs),
                  style: AppTypography.title.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.borderSubtle,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: _MetricCell(
                            label: strings.marginCostTotal,
                            value: formatMarginUzs(product.totalCostUzs),
                            colors: colors,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: colors.borderSubtle,
                        ),
                        Expanded(
                          child: _MetricCell(
                            label: strings.marginProfit,
                            value: formatMarginUzs(product.profitUzs),
                            colors: colors,
                            valueColor: profitColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (product.lines.isEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    strings.marginAddLine,
                    style: AppTypography.caption.copyWith(
                      color: colors.textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${product.lines.length} · ${strings.marginCostBreakdown}',
                    style: AppTypography.caption.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Icon(
              YbIcons.chevronRightFilled,
              color: colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Color _marginColor(double margin, YbThemeColors colors) {
    if (margin >= 40) return colors.teal;
    if (margin >= 20) return colors.textPrimary;
    return colors.error;
  }
}

class _MarginBadge extends StatelessWidget {
  const _MarginBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          value,
          style: AppTypography.label.copyWith(color: color),
        ),
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.label,
    required this.value,
    required this.colors,
    this.valueColor,
  });

  final String label;
  final String value;
  final YbThemeColors colors;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: colors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: valueColor ?? colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
