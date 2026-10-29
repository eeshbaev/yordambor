import 'package:yordambor/domain/entities/create_xizmat_prefill.dart';

/// Maps incoming URIs (HTTPS universal links or custom scheme) to app routes.
abstract final class DeepLinkMapper {
  static const httpsHosts = {'yordambor.app', 'www.yordambor.app'};
  static const customScheme = 'yordambor';

  static String? routeForUri(Uri uri) {
    if (uri.scheme == customScheme) {
      return _routeFromCustomScheme(uri);
    }

    if (uri.scheme == 'https' && httpsHosts.contains(uri.host)) {
      return _routeFromHttpsPath(uri);
    }

    return null;
  }

  static String? _routeFromCustomScheme(Uri uri) {
    final host = uri.host;
    if (host == 'join') return _joinRoute(uri);

    final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    if (id == null || id.isEmpty) return null;

    return switch (host) {
      'xizmat' => '/xizmat/$id',
      'post' => '/post/$id',
      'kelishuv' => '/kelishuv/$id',
      _ => null,
    };
  }

  static String? _routeFromHttpsPath(Uri uri) {
    final segments =
        uri.path.split('/').where((segment) => segment.isNotEmpty).toList();
    if (segments.length == 1 && segments.first == 'join') {
      return _joinRoute(uri);
    }
    if (segments.length < 2) return null;

    return switch (segments[0]) {
      'xizmat' => '/xizmat/${segments[1]}',
      'post' => '/post/${segments[1]}',
      'kelishuv' => '/kelishuv/${segments[1]}',
      _ => null,
    };
  }

  /// An invite to add a service, with only the parts of its query that
  /// check out.
  static String _joinRoute(Uri uri) {
    final query =
        CreateXizmatPrefill.fromQuery(uri.queryParameters).toQuery();
    return Uri(
      path: '/join',
      queryParameters: query.isEmpty ? null : query,
    ).toString();
  }
}
