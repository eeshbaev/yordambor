import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';

void main() {
  group('repeat booking prefill', () {
    test('mergeTaklifPrefill prefers primary values', () {
      const primary = TaklifPricingPrefill(
        message: 'Same job as last time',
        price: 150000,
      );
      const fallback = TaklifPricingPrefill(
        message: 'fallback',
        price: 100000,
        durationMinutes: 60,
      );

      final merged = mergeTaklifPrefill(primary, fallback);

      expect(merged.message, 'Same job as last time');
      expect(merged.price, 150000);
      expect(merged.durationMinutes, 60);
    });

    test('canRepeatBook allows completed deals for clients only', () {
      const kelishuv = Kelishuv(
        id: 'k1',
        status: KelishuvStatus.bajarildi,
        partyAId: 'client',
        partyBId: 'provider',
        initiatorId: 'client',
        xizmatId: 'x1',
        xizmatOwnerId: 'provider',
      );

      expect(kelishuv.canRepeatBook('client'), isTrue);
      expect(kelishuv.canRepeatBook('provider'), isFalse);
    });

    test('canRepeatBook rejects active deals', () {
      const kelishuv = Kelishuv(
        id: 'k1',
        status: KelishuvStatus.jarayonda,
        partyAId: 'client',
        partyBId: 'provider',
        initiatorId: 'client',
        xizmatId: 'x1',
        xizmatOwnerId: 'provider',
      );

      expect(kelishuv.canRepeatBook('client'), isFalse);
    });
  });
}
