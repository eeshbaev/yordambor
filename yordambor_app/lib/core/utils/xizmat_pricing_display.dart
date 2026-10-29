import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';

/// "120 000 soʻm": grouped with no-break spaces, "soʻm" instead of UZS.
String formatXizmatPriceAmount(
  double price,
  String currency, {
  String languageCode = 'uz',
}) {
  return formatMoney(price, currency, languageCode: languageCode);
}

String xizmatPricingLabel(XizmatFeedItem item, AppStrings strings) {
  if (item.pricingModel == XizmatPricingModel.negotiable) {
    return strings.xizmatPriceNegotiable;
  }

  final amount = item.basePrice;
  if (amount == null || amount <= 0) {
    return strings.xizmatPriceNegotiable;
  }

  final formatted = formatXizmatPriceAmount(
    amount,
    item.currency,
    languageCode: strings.languageCode,
  );
  return switch (item.pricingModel) {
    XizmatPricingModel.fixed => formatted,
    XizmatPricingModel.hourly => strings.xizmatPricePerHour(formatted),
    XizmatPricingModel.negotiable => strings.xizmatPriceNegotiable,
  };
}

/// The price in two parts, for a figure with a word under it: "120 000 soʻm"
/// over "narx" (or "soatiga" when it is by the hour); "Kelishiladi" over
/// "narx" when it is agreed case by case.
({String value, String unit}) xizmatPriceParts(
  XizmatFeedItem item,
  AppStrings strings,
) {
  final amount = item.basePrice;
  if (item.pricingModel == XizmatPricingModel.negotiable ||
      amount == null ||
      amount <= 0) {
    return (value: strings.xizmatStatNegotiable, unit: strings.xizmatStatPrice);
  }
  final formatted = formatXizmatPriceAmount(
    amount,
    item.currency,
    languageCode: strings.languageCode,
  );
  return (
    value: formatted,
    unit: item.pricingModel == XizmatPricingModel.hourly
        ? strings.xizmatStatPerHour
        : strings.xizmatStatPrice,
  );
}

class TaklifPricingPrefill {
  const TaklifPricingPrefill({
    this.message,
    this.price,
    this.durationMinutes,
  });

  final String? message;
  final double? price;
  final int? durationMinutes;
}

TaklifPricingPrefill mergeTaklifPrefill(
  TaklifPricingPrefill? primary,
  TaklifPricingPrefill? fallback,
) {
  if (primary == null) return fallback ?? const TaklifPricingPrefill();
  if (fallback == null) return primary;
  return TaklifPricingPrefill(
    message: primary.message ?? fallback.message,
    price: primary.price ?? fallback.price,
    durationMinutes: primary.durationMinutes ?? fallback.durationMinutes,
  );
}

TaklifPricingPrefill taklifPrefillFromKelishuv(Kelishuv kelishuv) {
  return TaklifPricingPrefill(
    message: kelishuv.message,
    price: kelishuv.price,
    durationMinutes: kelishuv.durationMinutes,
  );
}

TaklifPricingPrefill taklifPrefillFromKelishuvSummary(KelishuvSummary summary) {
  return TaklifPricingPrefill(
    message: summary.message,
    price: summary.price,
    durationMinutes: summary.durationMinutes,
  );
}

TaklifPricingPrefill taklifPrefillFromXizmat(XizmatFeedItem item) {
  if (item.pricingModel == XizmatPricingModel.negotiable) {
    return const TaklifPricingPrefill();
  }

  final rate = item.basePrice;
  if (rate == null || rate <= 0) {
    return const TaklifPricingPrefill();
  }

  return switch (item.pricingModel) {
    XizmatPricingModel.fixed => TaklifPricingPrefill(price: rate),
    XizmatPricingModel.hourly => () {
        final min = item.minDurationMinutes;
        if (min != null && min > 0) {
          return TaklifPricingPrefill(
            price: rate * (min / 60),
            durationMinutes: min,
          );
        }
        return TaklifPricingPrefill(price: rate);
      }(),
    XizmatPricingModel.negotiable => const TaklifPricingPrefill(),
  };
}
