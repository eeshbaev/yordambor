/// HTTPS and custom-scheme links for sharing feed items outside the app.
abstract final class AppShareLinks {
  static const httpsHost = 'yordambor.app';
  static const customScheme = 'yordambor';

  static String xizmatLink(String xizmatId) =>
      'https://$httpsHost/xizmat/$xizmatId';

  static String yordamKerakLink(String postId) =>
      'https://$httpsHost/post/$postId';

  static String xizmatCustomLink(String xizmatId) =>
      '$customScheme://xizmat/$xizmatId';

  static String yordamKerakCustomLink(String postId) =>
      '$customScheme://post/$postId';
}
