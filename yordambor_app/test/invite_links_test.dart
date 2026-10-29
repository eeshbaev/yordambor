import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/deep_links/deep_link_mapper.dart';
import 'package:yordambor/core/share/app_share_links.dart';
import 'package:yordambor/domain/entities/create_xizmat_prefill.dart';

void main() {
  group('Invite links', () {
    test('a join link opens the invite with the same prefill', () {
      const prefill = CreateXizmatPrefill(
        categoryId: 'home_repair',
        subcategoryId: 'electrician',
        cityId: 'toshkent',
        providerType: 'individual',
      );
      final link = AppShareLinks.joinLink(prefill);
      expect(link, startsWith('https://yordambor.app/join?'));

      final route = DeepLinkMapper.routeForUri(Uri.parse(link))!;
      final read = CreateXizmatPrefill.fromQuery(Uri.parse(route).queryParameters);
      expect(read.categoryId, 'home_repair');
      expect(read.subcategoryId, 'electrician');
      expect(read.cityId, 'toshkent');
      expect(read.providerType, 'individual');
    });

    test('a link with nothing picked is plain', () {
      expect(AppShareLinks.joinLink(), 'https://yordambor.app/join');
      expect(const CreateXizmatPrefill().isEmpty, isTrue);
    });

    test('the prefill keeps only values that check out', () {
      final read = CreateXizmatPrefill.fromQuery({
        'category': '../../etc',
        'sub': 'plumber',
        'city': 'atlantis',
        'type': 'company',
      });
      expect(read.categoryId, isNull);
      expect(read.subcategoryId, 'plumber');
      expect(read.cityId, isNull);
      expect(read.providerType, isNull);
    });
  });
}
