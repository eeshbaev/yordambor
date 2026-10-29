import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/domain/entities/working_hours.dart';

/// Working hours: one set per person (profiles.working_hours) and, for
/// someone with several services, an optional set per service
/// (xizmatlar.working_hours). Both come with migration 022; before it the
/// person's own hours are kept on this device and services follow them.
class WorkingHoursRepository {
  static const _boxName = 'working_hours_v1';

  /// True once the server answers that a column does not exist yet.
  static bool _profileColumnMissing = false;
  static bool _xizmatColumnMissing = false;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<Box<List>> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box<List>(_boxName);
    return Hive.openBox<List>(_boxName);
  }

  /// The person's hours; the standard day when they never set any.
  Future<WorkingHours> fetchForUser(String userId) async {
    final client = _client;
    if (client != null && !_profileColumnMissing) {
      try {
        final row = await client
            .from('profiles')
            .select('working_hours')
            .eq('id', userId)
            .maybeSingle();
        final hours = WorkingHours.fromJson(row?['working_hours']);
        if (hours != null) return hours;
      } on PostgrestException catch (error) {
        if (_mentions(error, 'working_hours')) _profileColumnMissing = true;
      } catch (_) {
        // Offline: the device copy answers.
      }
    }
    final box = await _box();
    return WorkingHours.fromJson(box.get('user:$userId')) ??
        WorkingHours.standard;
  }

  /// A service's own hours, or null when it follows its owner's.
  Future<WorkingHours?> fetchForXizmat(String xizmatId) async {
    final client = _client;
    if (client == null || _xizmatColumnMissing) return null;
    try {
      final row = await client
          .from('xizmatlar')
          .select('working_hours')
          .eq('id', xizmatId)
          .maybeSingle();
      return WorkingHours.fromJson(row?['working_hours']);
    } on PostgrestException catch (error) {
      if (_mentions(error, 'working_hours')) _xizmatColumnMissing = true;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveForUser(String userId, WorkingHours hours) async {
    final box = await _box();
    await box.put('user:$userId', hours.toJson());
    final client = _client;
    if (client == null || _profileColumnMissing) return;
    try {
      await client
          .from('profiles')
          .update({'working_hours': hours.toJson()})
          .eq('id', userId);
    } on PostgrestException catch (error) {
      if (!_mentions(error, 'working_hours')) rethrow;
      _profileColumnMissing = true;
    }
  }

  /// [hours] null: the service follows its owner's hours again.
  Future<void> saveForXizmat(String xizmatId, WorkingHours? hours) async {
    final client = _client;
    if (client == null || _xizmatColumnMissing) return;
    try {
      await client
          .from('xizmatlar')
          .update({'working_hours': hours?.toJson()})
          .eq('id', xizmatId);
    } on PostgrestException catch (error) {
      if (!_mentions(error, 'working_hours')) rethrow;
      _xizmatColumnMissing = true;
    }
  }

  /// Whether a service can keep hours of its own on this server.
  bool get supportsServiceHours => _client != null && !_xizmatColumnMissing;

  static bool _mentions(PostgrestException error, String column) =>
      error.code == '42703' ||
      error.code == 'PGRST204' ||
      error.message.contains(column);
}
