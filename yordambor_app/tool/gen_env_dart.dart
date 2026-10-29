/// Reads .env.json and writes lib/core/config/env_local.g.dart so that
/// the app can be launched directly from Xcode / Android Studio without
/// passing --dart-define-from-file on the command line.
///
/// Run: dart run tool/gen_env_dart.dart
import 'dart:convert';
import 'dart:io';

void main() {
  final envFile = File('.env.json');
  if (!envFile.existsSync()) {
    stderr.writeln('Missing .env.json — copy from .env.json.example first.');
    exit(1);
  }
  final env = jsonDecode(envFile.readAsStringSync()) as Map<String, dynamic>;
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
