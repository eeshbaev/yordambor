import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/l10n/current_strings.dart';
import 'package:yordambor/data/kelishuv/kelishuv_exceptions.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';

void main() {
  tearDown(() => CurrentStrings.language = 'uz');

  test('messages without a screen follow the chosen language', () {
    CurrentStrings.language = 'en';
    expect(CurrentStrings.value.errSignInRequired, 'Please sign in first');
    expect(CurrentStrings.value.errMaxServices(5), 'Up to 5 services');
    CurrentStrings.language = 'ru';
    expect(CurrentStrings.value.errSignInRequired, 'Сначала войдите');
    CurrentStrings.language = 'uz';
    expect(CurrentStrings.value.errSignInRequired, 'Kirish talab qilinadi');
    expect(KelishuvFailure('x').message, 'x');
  });

  test('a deal with no names falls back in the chosen language', () {
    const deal = Kelishuv(
      id: 'k',
      status: KelishuvStatus.muzokarada,
      partyAId: 'a',
      partyBId: 'b',
      initiatorId: 'a',
    );
    CurrentStrings.language = 'en';
    expect(deal.otherPartyNameFor('a'), 'User');
    CurrentStrings.language = 'zh';
    expect(deal.otherPartyNameFor('a'), '用户');
  });
}
