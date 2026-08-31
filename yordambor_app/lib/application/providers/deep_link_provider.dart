import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/core/deep_links/deep_link_mapper.dart';
import 'package:yordambor/core/router/app_router.dart';

/// Route to open after splash / auth bootstrap completes.
final pendingDeepLinkProvider = StateProvider<String?>((ref) => null);

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final service = DeepLinkService(ref);
  ref.onDispose(service.dispose);
  return service;
});

class DeepLinkService {
  DeepLinkService(this._ref);

  final Ref _ref;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      _handleUri(initial);
    }

    _subscription = _appLinks.uriLinkStream.listen(_handleUri);
  }

  void _handleUri(Uri uri) {
    final route = DeepLinkMapper.routeForUri(uri);
    if (route == null) return;

    final router = _ref.read(routerProvider);
    final location = router.state.matchedLocation;

    if (location == '/splash' ||
        location == '/welcome' ||
        location == '/verify-email' ||
        location == '/reset-password') {
      _ref.read(pendingDeepLinkProvider.notifier).state = route;
      return;
    }

    router.go(route);
  }

  void dispose() {
    unawaited(_subscription?.cancel());
  }
}

/// Returns and clears a pending deep link route, if any.
String? consumePendingDeepLink(WidgetRef ref) {
  final pending = ref.read(pendingDeepLinkProvider);
  if (pending != null) {
    ref.read(pendingDeepLinkProvider.notifier).state = null;
  }
  return pending;
}

/// Navigates to a pending deep link or [fallbackRoute].
void goAfterBootstrap(BuildContext context, WidgetRef ref, String fallbackRoute) {
  final pending = consumePendingDeepLink(ref);
  context.go(pending ?? fallbackRoute);
}
