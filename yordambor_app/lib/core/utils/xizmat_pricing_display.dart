import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

/// "120 000 soʻm": grouped with no-break spaces, "soʻm" instead of UZS.
String formatXizmatPriceAmount(
  double price,
  String currency, {
  String languageCode = 'uz',
}) {
  return formatMoney(price, currency, languageCode: languageCode);
}

String xizmatPricingLabel(XizmatFeedItem item, AppStrings strings) =>
    pricingLabel(
      model: item.pricingModel,
      amount: item.basePrice,
      currency: item.currency,
      strings: strings,
    );

/// What a help request offers to pay: "350 000 soʻm", "50 000 soʻm/day"...,
/// or "Price negotiable".
String yordamKerakPriceLabel(YordamKerakFeedItem item, AppStrings strings) {
  final price = item.price;
  // Requests from before price units (and the samples) give an amount for
  // the whole job.
  final model = price != null && price > 0 && !item.pricingModel.hasAmount
      ? XizmatPricingModel.fixed
      : item.pricingModel;
  return pricingLabel(
    model: model,
    amount: price,
    currency: item.currency,
    strings: strings,
  );
}

/// "120 000 soʻm", "120 000 soʻm/hr" and so on; "Price negotiable" when
/// there is no amount to show.
String pricingLabel({
  required XizmatPricingModel model,
  required double? amount,
  required String? currency,
  required AppStrings strings,
}) {
  if (!model.hasAmount || amount == null || amount <= 0) {
    return strings.xizmatPriceNegotiable;
  }

  final formatted = formatXizmatPriceAmount(
    amount,
    currency ?? 'UZS',
    languageCode: strings.languageCode,
  );
  return switch (model) {
    XizmatPricingModel.fixed => formatted,
    XizmatPricingModel.hourly => strings.xizmatPricePerHour(formatted),
    XizmatPricingModel.daily => strings.xizmatPricePerDay(formatted),
    XizmatPricingModel.monthly => strings.xizmatPricePerMonth(formatted),
    XizmatPricingModel.unit => strings.xizmatPricePerUnit(formatted),
    XizmatPricingModel.negotiable => strings.xizmatPriceNegotiable,
  };
}

/// The price in two parts, for a figure with a word under it: "120 000 soʻm"
/// over "narx" (or "soatiga", "kuniga"... for a rate); "Kelishiladi" over
/// "narx" when it is agreed case by case.
({String value, String unit}) xizmatPriceParts(
  XizmatFeedItem item,
  AppStrings strings,
) {
  final amount = item.basePrice;
  if (!item.pricingModel.hasAmount || amount == null || amount <= 0) {
    return (value: strings.xizmatStatNegotiable, unit: strings.xizmatStatPrice);
  }
  final formatted = formatXizmatPriceAmount(
    amount,
    item.currency,
    languageCode: strings.languageCode,
  );
  return (
    value: formatted,
    unit: switch (item.pricingModel) {
      XizmatPricingModel.hourly => strings.xizmatStatPerHour,
      XizmatPricingModel.daily => strings.xizmatStatPerDay,
      XizmatPricingModel.monthly => strings.xizmatStatPerMonth,
      XizmatPricingModel.unit => strings.xizmatStatPerUnit,
      XizmatPricingModel.fixed ||
      XizmatPricingModel.negotiable =>
        strings.xizmatStatPrice,
    },
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
  final rate = item.basePrice;
  if (!item.pricingModel.hasAmount || rate == null || rate <= 0) {
    return const TaklifPricingPrefill();
  }

  if (item.pricingModel == XizmatPricingModel.hourly) {
    final min = item.minDurationMinutes;
    if (min != null && min > 0) {
      return TaklifPricingPrefill(
        price: rate * (min / 60),
        durationMinutes: min,
      );
    }
  }
  // Per job, day, month or piece: the rate is where the offer starts.
  return TaklifPricingPrefill(price: rate);
}
