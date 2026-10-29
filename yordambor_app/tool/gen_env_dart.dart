// Reads .env.json and writes lib/core/config/env_local.g.dart so that
// the app can be launched directly from Xcode / Android Studio without
// passing --dart-define-from-file on the command line. Without .env.json
// it writes empty values, so a fresh checkout (and CI) still compiles.
//
// Run: dart run tool/gen_env_dart.dart
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() {
  final envFile = File('.env.json');
  final env = envFile.existsSync()
      ? jsonDecode(envFile.readAsStringSync()) as Map<String, dynamic>
      : <String, dynamic>{};
  if (env.isEmpty) {
    print('No .env.json: writing empty values (the app runs with samples).');
  }
  final url = env['SUPABASE_URL'] as String? ?? '';
  final key = env['SUPABASE_ANON_KEY'] as String? ?? '';

  final out = File('lib/core/config/env_local.g.dart');
  out.writeAsStringSync('''
// AUTO-GENERATED — do not commit (listed in .gitignore)
// Generated from .env.json by tool/gen_env_dart.dart
// Regenerate any time you update .env.json:
//   dart run tool/gen_env_dart.dart

const String kLocalSupabaseUrl = '$url';
const String kLocalSupabaseAnonKey = '$key';
''');
  print('✓ Written ${out.path}');
}
