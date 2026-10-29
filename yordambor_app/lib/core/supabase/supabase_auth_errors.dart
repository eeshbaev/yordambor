import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';

/// Detects Supabase auth failures caused by offline / DNS issues.
bool isSupabaseAuthNetworkError(Object error) {
  if (error is AuthRetryableFetchException) return true;

  final message = error.toString().toLowerCase();
  if (!message.contains('supabase')) return false;

  return message.contains('failed host lookup') ||
      message.contains('socketexception') ||
      message.contains('network is unreachable') ||
      message.contains('connection refused') ||
      message.contains('connection timed out');
}

Future<void> signOutSupabaseIfConfigured({bool localOnly = true}) async {
  if (!Env.isConfigured) return;
  try {
    await Supabase.instance.client.auth.signOut(
      scope: localOnly ? SignOutScope.local : SignOutScope.global,
    );
  } catch (_) {
    // Best-effort — local session may already be cleared.
  }
}

String mapSupabaseNetworkMessage(Object error) {
  if (!isSupabaseAuthNetworkError(error)) {
    return error.toString();
  }
  return 'Internet aloqasi yoʻq yoki serverga ulanib boʻlmadi. Keyinroq qayta urinib koʻring.';
}
