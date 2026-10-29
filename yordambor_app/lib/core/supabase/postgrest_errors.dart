import 'package:supabase_flutter/supabase_flutter.dart';

/// Whether the server has no such database function yet: the app is newer
/// than the migration that adds it, so it falls back to the older way.
bool isMissingRpc(PostgrestException error) =>
    error.code == 'PGRST202' || error.code == '42883';
