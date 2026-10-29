import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/application/growth/growth_program.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';

XizmatFeedItem _service({
  String type = 'individual',
  DateTime? created,
  int photos = 0,
  XizmatPricingModel pricing = XizmatPricingModel.negotiable,
  double? price,
  bool availability = false,
}) =>
    XizmatFeedItem(
      id: 'x${created?.day ?? 0}',
      name: 'S',
      categoryLabel: '',
      subcategoryLabel: '',
      categoryId: 'c',
      subcategoryId: 's',
      heroImageUrl: '',
      rating: 0,
      completedCount: 0,
      providerType: type,
      createdAt: created,
      portfolioImageUrls: [for (var i = 0; i < photos; i++) 'p$i.jpg'],
      pricingModel: pricing,
      basePrice: price,
      availabilityVisible: availability,
    );

void main() {
  test('each track has a tip a few days apart through the 30 days', () {
    for (final track in GrowthTrack.values) {
      final tips = GrowthProgram.tipsFor(track);
      expect(tips.first.day, 0);
      expect(tips.last.day, GrowthProgram.days);
      final days = [for (final tip in tips) tip.day];
      expect(days, [...days]..sort());
      expect(tips.map((tip) => tip.id).toSet().length, tips.length);
    }
  });

  test('every tip has its words in every language', () {
    for (final code in AppStrings.supportedLanguages) {
      final strings = AppStrings.forLanguage(code);
      for (final track in GrowthTrack.values) {
        for (final tip in GrowthProgram.tipsFor(track)) {
          expect(GrowthProgram.title(strings, tip.id), isNotEmpty);
          expect(GrowthProgram.body(strings, tip.id), isNotEmpty);
        }
      }
    }
  });

  test('the track follows the first service', () {
    expect(
      GrowthProgram.trackOf([
        _service(type: 'individual', created: DateTime(2030, 1, 5)),
        _service(type: 'institution', created: DateTime(2030, 1, 2)),
      ]),
      GrowthTrack.institution,
    );
    expect(GrowthProgram.trackOf([]), GrowthTrack.individual);
  });

  test('a tip already done is not sent', () {
    final ready = _service(
      photos: 3,
      pricing: XizmatPricingModel.daily,
      price: 50000,
      availability: true,
    );
    final bare = _service();
    expect(GrowthProgram.isDone(GrowthAction.photos, [ready]), isTrue);
    expect(GrowthProgram.isDone(GrowthAction.price, [ready]), isTrue);
    expect(GrowthProgram.isDone(GrowthAction.availability, [ready]), isTrue);
    expect(GrowthProgram.isDone(GrowthAction.photos, [ready, bare]), isFalse);
    expect(GrowthProgram.isDone(GrowthAction.price, [bare]), isFalse);
    expect(GrowthProgram.isDone(GrowthAction.share, [ready]), isFalse);
    expect(
      GrowthProgram.serviceNeeding(GrowthAction.photos, [ready, bare]),
      bare,
    );
  });
}
