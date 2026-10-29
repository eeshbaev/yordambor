import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/domain/entities/margin_product.dart';
import 'package:yordambor/core/utils/money_format.dart';

class MarginSummaryCard extends StatelessWidget {
  const MarginSummaryCard({
    super.key,
    required this.product,
    required this.strings,
  });

  final MarginProduct product;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final margin = product.marginPercent;
    final marginColor = margin >= 40
        ? context.ybColors.teal
        : margin >= 20
            ? colors.textPrimary
            : context.ybColors.error;

    return YbSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Metric(
                label: strings.marginCostTotal,
                value: _formatUzs(product.totalCostUzs),
                colors: colors,
              ),
              _Metric(
                label: strings.marginSalePrice.split(' ').first,
                value: _formatUzs(product.salePriceUzs),
                colors: colors,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _Metric(
                label: strings.marginProfit,
                value: _formatUzs(product.profitUzs),
                colors: colors,
                valueColor: product.profitUzs >= 0
                    ? context.ybColors.teal
                    : context.ybColors.error,
              ),
              _Metric(
                label: strings.marginMarginPercent,
                value: '${margin.toStringAsFixed(0)}%',
                colors: colors,
                valueColor: marginColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatUzs(double amount) => formatSom(amount);
}

class _Metric extends StatelessWidget {
  const _Metric({
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.headline.copyWith(
              color: valueColor ?? colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

String formatMarginUzs(double amount) => MarginSummaryCard._formatUzs(amount);

String formatMarginLineSubtitle(
  MarginProductLine line,
  AppStrings strings,
) {
  final qty = line.quantity == line.quantity.roundToDouble()
      ? line.quantity.toStringAsFixed(0)
      : line.quantity.toStringAsFixed(2);
  final label = line.quantityLabel?.trim();
  final qtyPart = label == null || label.isEmpty ? qty : '$qty $label';
  return '$qtyPart × ${formatMarginUzs(line.unitCostUzs)}';
}
