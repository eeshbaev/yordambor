import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_filter_chip.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';

/// The price, which every service and help request states: "Kelishiladi"
/// or an amount with its unit (per job, hour, day, month or piece).
///
/// [pricingModel] is null until the person picks one of the two.
class XizmatPricingSection extends StatefulWidget {
  const XizmatPricingSection({
    super.key,
    required this.strings,
    required this.pricingModel,
    required this.onPricingModelChanged,
    required this.priceController,
    this.minDurationController,
    this.forRequest = false,
    this.errorText,
  });

  final AppStrings strings;
  final XizmatPricingModel? pricingModel;
  final ValueChanged<XizmatPricingModel> onPricingModelChanged;
  final TextEditingController priceController;

  /// Shown for an hourly service; null hides it (help requests).
  final TextEditingController? minDurationController;

  /// A help request ("How much are you ready to pay?") rather than a
  /// service.
  final bool forRequest;

  final String? errorText;

  @override
  State<XizmatPricingSection> createState() => _XizmatPricingSectionState();
}

class _XizmatPricingSectionState extends State<XizmatPricingSection> {
  /// The unit "Aniq narx" comes back to after a switch to "Kelishiladi".
  late XizmatPricingModel _lastUnit = _unitOf(widget.pricingModel);

  static XizmatPricingModel _unitOf(XizmatPricingModel? model) =>
      model != null && model.hasAmount ? model : XizmatPricingModel.fixed;

  @override
  void didUpdateWidget(covariant XizmatPricingSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final model = widget.pricingModel;
    if (model != null && model.hasAmount) _lastUnit = model;
  }

  String _unitLabel(XizmatPricingModel unit) {
    final strings = widget.strings;
    return switch (unit) {
      XizmatPricingModel.hourly => strings.priceUnitHour,
      XizmatPricingModel.daily => strings.priceUnitDay,
      XizmatPricingModel.monthly => strings.priceUnitMonth,
      XizmatPricingModel.unit => strings.priceUnitUnit,
      XizmatPricingModel.fixed ||
      XizmatPricingModel.negotiable =>
        strings.priceUnitFixed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final colors = context.ybColors;
    final model = widget.pricingModel;
    final withAmount = model != null && model.hasAmount;
    final errorText = widget.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${strings.priceChoiceTitle} *',
          style: AppTypography.headline.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          widget.forRequest
              ? strings.priceChoiceRequestHint
              : strings.priceChoiceServiceHint,
          style: AppTypography.caption.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _ChoiceTile(
                  icon: YbIcons.handshake,
                  title: strings.priceChoiceNegotiable,
                  hint: strings.priceChoiceNegotiableHint,
                  selected: model == XizmatPricingModel.negotiable,
                  onTap: () => widget
                      .onPricingModelChanged(XizmatPricingModel.negotiable),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ChoiceTile(
                  icon: YbIcons.paymentsFilled,
                  title: strings.priceChoiceAmount,
                  hint: strings.priceChoiceAmountHint,
                  selected: withAmount,
                  onTap: () => widget.onPricingModelChanged(_lastUnit),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText,
            style: AppTypography.caption.copyWith(color: colors.error),
          ),
        ],
        if (withAmount) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final unit in XizmatPricingModel.amountUnits)
                YbFilterChip(
                  label: _unitLabel(unit),
                  selected: model == unit,
                  onTap: () => widget.onPricingModelChanged(unit),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: widget.priceController,
            decoration: InputDecoration(
              labelText: '${strings.priceAmountLabel} *',
              hintText: strings.priceAmountHint,
              suffixText: model == XizmatPricingModel.fixed
                  ? null
                  : _unitLabel(model).toLowerCase(),
            ),
            keyboardType: TextInputType.number,
          ),
          if (model == XizmatPricingModel.hourly &&
              widget.minDurationController != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: widget.minDurationController,
              decoration: InputDecoration(
                labelText: strings.xizmatPricingMinDurationLabel,
                hintText: strings.xizmatPricingMinDurationHint,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ],
      ],
    );
  }
}

/// One of the two answers, as a card that fills teal once picked.
class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.hint,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String hint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final foreground = selected ? colors.tealInk : colors.ink;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: AnimatedContainer(
            duration: AppMotion.quick,
            curve: AppMotion.quickCurve,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: selected ? colors.tealSoft : colors.card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: selected ? colors.teal : colors.line,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: selected ? colors.teal : colors.ink2,
                    ),
                    const Spacer(),
                    Icon(
                      selected
                          ? YbIcons.checkCircleFilled
                          : YbIcons.radioButtonUnchecked,
                      size: 20,
                      color: selected ? colors.teal : colors.ink3,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hint,
                  style: AppTypography.caption.copyWith(
                    color: selected
                        ? colors.tealInk.withValues(alpha: 0.8)
                        : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "150 000", "150.000" and "150,000" all read as 150000 (see [parseSom]).
double? parseOptionalPrice(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  return parseSom(trimmed)?.toDouble();
}

int? parseOptionalMinutes(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  return int.tryParse(trimmed);
}

/// Null when the price is complete: "Kelishiladi", or an amount above zero.
String? validateXizmatPricing({
  required XizmatPricingModel? model,
  required String priceText,
  required AppStrings strings,
}) {
  if (model == null) return strings.priceChoiceRequired;
  if (!model.hasAmount) return null;

  final price = parseOptionalPrice(priceText);
  if (price == null || price <= 0) {
    return strings.xizmatPricingRequiredError;
  }
  return null;
}
