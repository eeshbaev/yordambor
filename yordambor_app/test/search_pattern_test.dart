import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/data/xizmat/xizmat_repository.dart';

void main() {
  test('any apostrophe matches any other', () {
    expect(XizmatRepository.searchPattern("o'zbek"), '%o_zbek%');
    expect(XizmatRepository.searchPattern('oʻzbek'), '%o_zbek%');
    expect(normalizeUz("Oʻzbek  oshi"), normalizeUz("o'zbek oshi"));
  });

  test('what people type stays literal otherwise', () {
    expect(XizmatRepository.searchPattern('100%_a'), r'%100\%\_a%');
  });
}
