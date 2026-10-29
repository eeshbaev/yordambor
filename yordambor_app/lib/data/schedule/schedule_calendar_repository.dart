import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';

/// Free and busy days. They live on the server (migration 022), where
/// people looking at a service see them, with a copy on this device so the
/// calendar works offline and before the server has the table.
class ScheduleCalendarRepository {
  static const boxName = 'schedule_calendar_v1';
  static const _table = 'provider_day_marks';

  /// True once the server answers that the table does not exist yet.
  static bool _serverMissing = false;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }
    return Hive.openBox<Map>(boxName);
  }

  static DateTime _day(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  /// "2026-10-25".
  static String _dateKey(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  String _key(String userId, DateTime day) => '$userId:${_dateKey(day)}';

  /// The person's own marks for [month].
  Future<Map<DateTime, DayMark>> fetchMarksForMonth({
    required String userId,
    required DateTime month,
  }) async {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    await _uploadLocalOnce(userId);
    final server = await _fetchServer(ownerId: userId, from: first, to: last);
    if (server != null) return server;
    return _fetchLocal(userId, first, last);
  }

  /// Marks made before the server kept them lived on this device only. The
  /// first time the server is there, they move up once, so clients see them
  /// and nothing marked earlier is lost.
  Future<void> _uploadLocalOnce(String userId) async {
    if (_client == null || _serverMissing) return;
    final box = await _box();
    final flag = 'uploaded:$userId';
    if (box.containsKey(flag)) return;

    final prefix = '$userId:';
    final today = _day(DateTime.now());
    for (final key in box.keys.whereType<String>().toList()) {
      if (!key.startsWith(prefix)) continue;
      final day = DateTime.tryParse(key.substring(prefix.length));
      // Past days no longer matter to anyone.
      if (day == null || day.isBefore(today)) continue;
      final raw = box.get(key);
      if (raw == null) continue;
      final map = Map<dynamic, dynamic>.from(raw);
      final status = ScheduleDayAvailability.fromStorage(
        map['mark'] as String?,
      );
      if (status == ScheduleDayAvailability.unset) continue;
      final saved = await _saveServer(
        userId,
        day,
        DayMark(status, slots: DayMark.slotsFrom(map['slots'])),
      );
      // No server yet, or offline: try again another time.
      if (!saved) return;
    }
    await box.put(flag, {'at': DateTime.now().toIso8601String()});
  }

  /// Someone's marks from [from] to [to], as clients see them. Empty when
  /// the server has none or cannot say.
  Future<Map<DateTime, DayMark>> fetchMarksForOwner({
    required String ownerId,
    required DateTime from,
    required DateTime to,
  }) async {
    return await _fetchServer(ownerId: ownerId, from: from, to: to) ??
        const {};
  }

  /// Saves the mark for [day] (null clears it): on this device at once,
  /// then on the server. False when only the device copy was saved.
  Future<bool> setMark({
    required String userId,
    required DateTime day,
    DayMark? mark,
  }) async {
    final box = await _box();
    final key = _key(userId, day);
    if (mark == null || mark.status == ScheduleDayAvailability.unset) {
      await box.delete(key);
      return _saveServer(userId, day, null);
    }
    await box.put(key, {
      'mark': mark.status.storageValue,
      'slots': mark.slotsJson(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
    return _saveServer(userId, day, mark);
  }

  Future<Map<DateTime, DayMark>> _fetchLocal(
    String userId,
    DateTime first,
    DateTime last,
  ) async {
    final box = await _box();
    final result = <DateTime, DayMark>{};
    for (var date = first;
        !date.isAfter(last);
        date = DateTime(date.year, date.month, date.day + 1)) {
      final raw = box.get(_key(userId, date));
      if (raw == null) continue;
      final map = Map<dynamic, dynamic>.from(raw);
      final status = ScheduleDayAvailability.fromStorage(
        map['mark'] as String?,
      );
      if (status == ScheduleDayAvailability.unset) continue;
      result[_day(date)] = DayMark(
        status,
        slots: DayMark.slotsFrom(map['slots']),
      );
    }
    return result;
  }

  Future<Map<DateTime, DayMark>?> _fetchServer({
    required String ownerId,
    required DateTime from,
    required DateTime to,
  }) async {
    final client = _client;
    if (client == null || _serverMissing) return null;
    try {
      final rows = await client
          .from(_table)
          .select('day, status, slots')
          .eq('owner_id', ownerId)
          .gte('day', _dateKey(from))
          .lte('day', _dateKey(to));
      final result = <DateTime, DayMark>{};
      for (final row in rows) {
        final day = DateTime.tryParse(row['day'] as String? ?? '');
        final status = ScheduleDayAvailability.fromStorage(
          row['status'] as String?,
        );
        if (day == null || status == ScheduleDayAvailability.unset) continue;
        result[_day(day)] = DayMark(
          status,
          slots: DayMark.slotsFrom(row['slots']),
        );
      }
      return result;
    } on PostgrestException catch (error) {
      if (_isMissingTable(error)) _serverMissing = true;
      return null;
    } catch (_) {
      // Offline: the device copy answers.
      return null;
    }
  }

  Future<bool> _saveServer(String userId, DateTime day, DayMark? mark) async {
    final client = _client;
    if (client == null || _serverMissing) return false;
    try {
      if (mark == null) {
        await client
            .from(_table)
            .delete()
            .eq('owner_id', userId)
            .eq('day', _dateKey(day));
      } else {
        await client.from(_table).upsert({
          'owner_id': userId,
          'day': _dateKey(day),
          'status': mark.status.storageValue,
          'slots': mark.slotsJson(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
      return true;
    } on PostgrestException catch (error) {
      if (_isMissingTable(error)) _serverMissing = true;
      return false;
    } catch (_) {
      return false;
    }
  }

  static bool _isMissingTable(PostgrestException error) =>
      error.code == '42P01' ||
      error.code == 'PGRST205' ||
      error.message.contains(_table);
}
