import 'package:share_plus/share_plus.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/share/app_share_links.dart';

/// Opens the platform share sheet (Telegram, WhatsApp, Messages, etc.).
abstract final class FeedShare {
  static Future<void> shareXizmat({
    required AppStrings strings,
    required String xizmatId,
    required String xizmatName,
  }) {
    final message =
        '${strings.shareXizmatMessage(xizmatName)}\n${AppShareLinks.xizmatLink(xizmatId)}';
    return SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: xizmatName,
      ),
    );
  }

  static Future<void> shareYordamKerakPost({
    required AppStrings strings,
    required String postId,
    required String title,
  }) {
    final message =
        '${strings.shareYordamKerakMessage(title)}\n${AppShareLinks.yordamKerakLink(postId)}';
    return SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: title,
      ),
    );
  }
}
