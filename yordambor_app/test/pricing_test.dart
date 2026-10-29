import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';
import 'package:yordambor/presentation/shared/xizmat_pricing_section.dart';

XizmatFeedItem _service(XizmatPricingModel model, double? price) =>
    XizmatFeedItem(
      id: 'x1',
      name: 'Tozalash',
      categoryLabel: '',
      subcategoryLabel: '',
      categoryId: 'c',
      subcategoryId: 's',
      heroImageUrl: '',
      rating: 0,
      completedCount: 0,
      pricingModel: model,
      basePrice: price,
    );

YordamKerakFeedItem _request(XizmatPricingModel model, double? price) =>
    YordamKerakFeedItem(
      id: 'p1',
      title: 'Kerak',
      categoryLabel: '',
      subcategoryLabel: '',
      categoryId: 'c',
      subcategoryId: 's',
      authorName: 'A',
      price: price,
      pricingModel: model,
    );

void main() {
  final strings = AppStrings.forLanguage('en');

  group('XizmatPricingModel', () {
    test('reads every unit stored by migration 024', () {
      for (final model in XizmatPricingModel.values) {
        expect(XizmatPricingModel.fromDb(model.toDb()), model);
      }
      expect(XizmatPricingModel.fromDb(null), XizmatPricingModel.negotiable);
      expect(XizmatPricingModel.fromDb('weekly'), XizmatPricingModel.negotiable);
    });

    test('only negotiable comes without an amount', () {
      expect(XizmatPricingModel.negotiable.hasAmount, isFalse);
      expect(
        XizmatPricingModel.amountUnits.every((unit) => unit.hasAmount),
        isTrue,
      );
    });
  });

  group('validateXizmatPricing', () {
    test('a price must be picked', () {
      expect(
        validateXizmatPricing(model: null, priceText: '', strings: strings),
        strings.priceChoiceRequired,
      );
    });

    test('negotiable needs no amount', () {
      expect(
        validateXizmatPricing(
          model: XizmatPricingModel.negotiable,
          priceText: '',
          strings: strings,
        ),
        isNull,
      );
    });

    test('an amount unit needs an amount above zero', () {
      for (final text in ['', '0', 'abc']) {
        expect(
          validateXizmatPricing(
            model: XizmatPricingModel.daily,
            priceText: text,
            strings: strings,
          ),
          strings.xizmatPricingRequiredError,
        );
      }
      expect(
        validateXizmatPricing(
          model: XizmatPricingModel.monthly,
          priceText: '1 500 000',
          strings: strings,
        ),
        isNull,
      );
    });

    test('grouped amounts read as whole soʻm', () {
      expect(parseOptionalPrice('150 000'), 150000);
      expect(parseOptionalPrice('150.000'), 150000);
      expect(parseOptionalPrice('150,000'), 150000);
      expect(parseOptionalPrice(' '), isNull);
    });
  });

  group('price labels', () {
    test('each unit has its own suffix', () {
      final perDay = xizmatPricingLabel(
        _service(XizmatPricingModel.daily, 50000),
        strings,
      );
      final perMonth = xizmatPricingLabel(
        _service(XizmatPricingModel.monthly, 50000),
        strings,
      );
      final perUnit = xizmatPricingLabel(
        _service(XizmatPricingModel.unit, 50000),
        strings,
      );
      expect(perDay, endsWith('/day'));
      expect(perMonth, endsWith('/month'));
      expect(perUnit, endsWith('/unit'));
      expect(
        xizmatPriceParts(_service(XizmatPricingModel.daily, 50000), strings)
            .unit,
        strings.xizmatStatPerDay,
      );
    });

    test('no amount reads as negotiable', () {
      expect(
        xizmatPricingLabel(_service(XizmatPricingModel.hourly, null), strings),
        strings.xizmatPriceNegotiable,
      );
      expect(
        yordamKerakPriceLabel(
          _request(XizmatPricingModel.negotiable, null),
          strings,
        ),
        strings.xizmatPriceNegotiable,
      );
    });

    test('older requests with an amount read as the whole job', () {
      expect(
        yordamKerakPriceLabel(
          _request(XizmatPricingModel.negotiable, 350000),
          strings,
        ),
        xizmatPricingLabel(_service(XizmatPricingModel.fixed, 350000), strings),
      );
      expect(
        yordamKerakPriceLabel(_request(XizmatPricingModel.daily, 80000), strings),
        endsWith('/day'),
      );
    });
  });

  test('a daily rate starts the offer at one day', () {
    final prefill =
        taklifPrefillFromXizmat(_service(XizmatPricingModel.daily, 80000));
    expect(prefill.price, 80000);
    expect(prefill.durationMinutes, isNull);
  });
}
