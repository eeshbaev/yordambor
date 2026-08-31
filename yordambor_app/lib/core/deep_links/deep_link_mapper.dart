/// Maps incoming URIs (HTTPS universal links or custom scheme) to app routes.
abstract final class DeepLinkMapper {
  static const httpsHosts = {'yordambor.app', 'www.yordambor.app'};
  static const customScheme = 'yordambor';

  static String? routeForUri(Uri uri) {
    if (uri.scheme == customScheme) {
      return _routeFromCustomScheme(uri);
    }

    if (uri.scheme == 'https' && httpsHosts.contains(uri.host)) {
      return _routeFromHttpsPath(uri.path);
    }

    return null;
  }

  static String? _routeFromCustomScheme(Uri uri) {
    final host = uri.host;
    final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    if (id == null || id.isEmpty) return null;

    return switch (host) {
      'xizmat' => '/xizmat/$id',
      'post' => '/post/$id',
      'kelishuv' => '/kelishuv/$id',
      _ => null,
    };
  }

  static String? _routeFromHttpsPath(String path) {
    final segments =
        path.split('/').where((segment) => segment.isNotEmpty).toList();
    if (segments.length < 2) return null;

    return switch (segments[0]) {
      'xizmat' => '/xizmat/${segments[1]}',
      'post' => '/post/${segments[1]}',
      'kelishuv' => '/kelishuv/${segments[1]}',
      _ => null,
    };
  }
}
