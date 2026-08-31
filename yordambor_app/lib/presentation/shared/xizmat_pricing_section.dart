import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';

class XizmatPricingSection extends StatelessWidget {
  const XizmatPricingSection({
    super.key,
    required this.strings,
    required this.pricingModel,
    required this.onPricingModelChanged,
    required this.priceController,
    required this.minDurationController,
  });

  final AppStrings strings;
  final XizmatPricingModel pricingModel;
  final ValueChanged<XizmatPricingModel> onPricingModelChanged;
  final TextEditingController priceController;
  final TextEditingController minDurationController;

  @override
  Widget build(BuildContext context) {
    final showRate = pricingModel != XizmatPricingModel.negotiable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.xizmatPricingSectionTitle, style: AppTypography.headline),
        const SizedBox(height: AppSpacing.sm),
        Text(
          strings.xizmatPricingSectionSubtitle,
          style: AppTypography.caption,
        ),
        const SizedBox(height: AppSpacing.lg),
        SegmentedButton<XizmatPricingModel>(
          segments: [
            ButtonSegment(
              value: XizmatPricingModel.negotiable,
              label: Text(strings.xizmatPricingNegotiable),
            ),
            ButtonSegment(
              value: XizmatPricingModel.fixed,
              label: Text(strings.xizmatPricingFixed),
            ),
            ButtonSegment(
              value: XizmatPricingModel.hourly,
              label: Text(strings.xizmatPricingHourly),
            ),
          ],
          selected: {pricingModel},
          onSelectionChanged: (value) => onPricingModelChanged(value.first),
        ),
        if (showRate) ...[
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: pricingModel == XizmatPricingModel.hourly
                  ? strings.xizmatPricingHourlyRateLabel
                  : strings.xizmatPricingFixedRateLabel,
              hintText: strings.xizmatPricingRateHint,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
        if (pricingModel == XizmatPricingModel.hourly) ...[
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: minDurationController,
            decoration: InputDecoration(
              labelText: strings.xizmatPricingMinDurationLabel,
              hintText: strings.xizmatPricingMinDurationHint,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ],
    );
  }
}

double? parseOptionalPrice(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  return double.tryParse(trimmed.replaceAll(' ', ''));
}

int? parseOptionalMinutes(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  return int.tryParse(trimmed);
}

String? validateXizmatPricing({
  required XizmatPricingModel model,
  required String priceText,
  required AppStrings strings,
}) {
  if (model == XizmatPricingModel.negotiable) return null;

  final price = parseOptionalPrice(priceText);
  if (price == null || price <= 0) {
    return strings.xizmatPricingRequiredError;
  }
  return null;
}
