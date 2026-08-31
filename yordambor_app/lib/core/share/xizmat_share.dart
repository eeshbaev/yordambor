import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/share/app_share_links.dart';
import 'package:yordambor/core/share/feed_share.dart';

abstract final class XizmatShare {
  static String get baseUrl => 'https://${AppShareLinks.httpsHost}/xizmat';

  static String linkFor(String xizmatId) => AppShareLinks.xizmatLink(xizmatId);

  static String customLinkFor(String xizmatId) =>
      AppShareLinks.xizmatCustomLink(xizmatId);

  static Future<void> share({
    required AppStrings strings,
    required String xizmatId,
    required String xizmatName,
  }) =>
      FeedShare.shareXizmat(
        strings: strings,
        xizmatId: xizmatId,
        xizmatName: xizmatName,
      );
}
