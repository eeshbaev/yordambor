// Supabase credentials loaded in priority order:
//   1. --dart-define / --dart-define-from-file (CI, release, run_dev.sh)
//   2. env_local.g.dart fallback (Xcode / Android Studio direct launch)
//
// env_local.g.dart is not committed. Create it (again after changing
// .env.json) with:
//   dart run tool/gen_env_dart.dart
// ignore: uri_does_not_exist
import 'env_local.g.dart'
    // If env_local.g.dart doesn't exist yet the stub provides empty strings.
    if (dart.library.html) 'env_local_stub.dart';

class Env {
  static const _definedUrl = String.fromEnvironment('SUPABASE_URL');
  static const _definedKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// The active Supabase project URL.
  static String get supabaseUrl =>
      _definedUrl.isNotEmpty ? _definedUrl : kLocalSupabaseUrl;

  /// The active Supabase anon key.
  static String get supabaseAnonKey =>
      _definedKey.isNotEmpty ? _definedKey : kLocalSupabaseAnonKey;

  /// Tests set this to false: the keys on a developer's machine would
  /// otherwise make the app reach for a Supabase it never started.
  static bool? debugConfiguredOverride;

  static bool get isConfigured =>
      debugConfiguredOverride ??
      supabaseUrl.isNotEmpty &&
      !supabaseUrl.contains('YOUR_PROJECT') &&
      supabaseAnonKey.isNotEmpty &&
      !supabaseAnonKey.contains('YOUR_ANON_KEY') &&
      !supabaseAnonKey.contains('paste-your-anon-key') &&
      supabaseAnonKey.startsWith('eyJ');
}
