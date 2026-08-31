import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';

String formatXizmatPriceAmount(double price, String currency) {
  final formatted =
      price % 1 == 0 ? price.toInt().toString() : price.toString();
  return '$formatted $currency';
}

String xizmatPricingLabel(XizmatFeedItem item, AppStrings strings) {
  if (item.pricingModel == XizmatPricingModel.negotiable) {
    return strings.xizmatPriceNegotiable;
  }

  final amount = item.basePrice;
  if (amount == null || amount <= 0) {
    return strings.xizmatPriceNegotiable;
  }

  final formatted = formatXizmatPriceAmount(amount, item.currency);
  return switch (item.pricingModel) {
    XizmatPricingModel.fixed => formatted,
    XizmatPricingModel.hourly => strings.xizmatPricePerHour(formatted),
    XizmatPricingModel.negotiable => strings.xizmatPriceNegotiable,
  };
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
