import 'package:yordambor/domain/entities/create_xizmat_prefill.dart';

/// HTTPS and custom-scheme links for sharing feed items outside the app.
abstract final class AppShareLinks {
  static const httpsHost = 'yordambor.app';
  static const customScheme = 'yordambor';

  /// The app's Google Play page, for someone who does not have it yet.
  static const playStoreLink =
      'https://play.google.com/store/apps/details?id=uz.yordambor.yordambor';

  static String xizmatLink(String xizmatId) =>
      'https://$httpsHost/xizmat/$xizmatId';

  static String yordamKerakLink(String postId) =>
      'https://$httpsHost/post/$postId';

  static String xizmatCustomLink(String xizmatId) =>
      '$customScheme://xizmat/$xizmatId';

  static String yordamKerakCustomLink(String postId) =>
      '$customScheme://post/$postId';

  /// An invite to add a service: opens "new service" with [prefill] in the
  /// app (the trade, city and provider type the inviter picked).
  static String joinLink([CreateXizmatPrefill prefill = const CreateXizmatPrefill()]) {
    final query = prefill.toQuery();
    return Uri(
      scheme: 'https',
      host: httpsHost,
      path: '/join',
      queryParameters: query.isEmpty ? null : query,
    ).toString();
  }
}
