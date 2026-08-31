import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/share/app_share_links.dart';

void main() {
  group('AppShareLinks', () {
    test('builds xizmat https link', () {
      expect(
        AppShareLinks.xizmatLink('abc-123'),
        'https://yordambor.app/xizmat/abc-123',
      );
    });

    test('builds yordam kerak https link', () {
      expect(
        AppShareLinks.yordamKerakLink('post-456'),
        'https://yordambor.app/post/post-456',
      );
    });
  });
}
