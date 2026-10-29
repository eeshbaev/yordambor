import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/deep_links/deep_link_mapper.dart';

void main() {
  group('DeepLinkMapper', () {
    test('maps https xizmat links', () {
      expect(
        DeepLinkMapper.routeForUri(
          Uri.parse('https://yordambor.app/xizmat/abc-123'),
        ),
        '/xizmat/abc-123',
      );
    });

    test('maps https kelishuv links', () {
      expect(
        DeepLinkMapper.routeForUri(
          Uri.parse('https://www.yordambor.app/kelishuv/deal-1'),
        ),
        '/kelishuv/deal-1',
      );
    });

    test('maps custom scheme links', () {
      expect(
        DeepLinkMapper.routeForUri(Uri.parse('yordambor://xizmat/abc-123')),
        '/xizmat/abc-123',
      );
    });

    test('maps https post links', () {
      expect(
        DeepLinkMapper.routeForUri(
          Uri.parse('https://yordambor.app/post/job-123'),
        ),
        '/post/job-123',
      );
    });

    test('maps custom scheme post links', () {
      expect(
        DeepLinkMapper.routeForUri(Uri.parse('yordambor://post/job-123')),
        '/post/job-123',
      );
    });

    test('maps https invite links with their prefill', () {
      expect(
        DeepLinkMapper.routeForUri(
          Uri.parse(
            'https://yordambor.app/join?category=home_repair&sub=plumber'
            '&city=samarqand&type=individual',
          ),
        ),
        '/join?category=home_repair&sub=plumber&city=samarqand&type=individual',
      );
    });

    test('maps custom scheme invite links', () {
      expect(
        DeepLinkMapper.routeForUri(Uri.parse('yordambor://join?city=nukus')),
        '/join?city=nukus',
      );
      expect(
        DeepLinkMapper.routeForUri(Uri.parse('yordambor://join')),
        '/join',
      );
    });

    test('drops invite values that do not check out', () {
      expect(
        DeepLinkMapper.routeForUri(
          Uri.parse(
            'https://yordambor.app/join?category=a%2Fb&city=mars'
            '&type=robot&other=1',
          ),
        ),
        '/join',
      );
    });

    test('ignores unknown paths', () {
      expect(
        DeepLinkMapper.routeForUri(Uri.parse('https://yordambor.app/home')),
        isNull,
      );
    });
  });
}
