import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/supabase/supabase_auth_errors.dart';

/// Initializes Supabase and clears stale sessions when refresh is impossible.
abstract final class SupabaseBootstrap {
  static Future<void> initialize() async {
    if (!Env.isConfigured) return;

    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );

    await _sanitizeExpiredSession();
  }

  static Future<void> _sanitizeExpiredSession() async {
    final auth = Supabase.instance.client.auth;
    final session = auth.currentSession;
    if (session == null) return;

    final expiresAt = session.expiresAt;
    if (expiresAt == null) return;

    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expiresSoon = expiresAt <= nowSeconds + 60;
    if (!expiresSoon) return;

    // Clear stale tokens locally — do not call refreshSession() here.
    // Offline / emulator DNS failures during refresh throw from the SDK's
    // background listener and can crash the app.
    if (kDebugMode) {
      debugPrint(
        'Supabase session expired or expiring — clearing local session',
      );
    }
    await signOutSupabaseIfConfigured();
  }

  static void installGlobalErrorHandlers() {
    if (!Env.isConfigured) return;

    final previousPlatformHandler = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      if (isSupabaseAuthNetworkError(error)) {
        unawaited(signOutSupabaseIfConfigured());
        if (kDebugMode) {
          debugPrint('Supabase auth network error (handled): $error');
        }
        return true;
      }
      return previousPlatformHandler?.call(error, stack) ?? false;
    };
  }
}
