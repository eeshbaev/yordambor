import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/application/providers/schedule_calendar_providers.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';
import 'package:yordambor/domain/entities/working_hours.dart';

/// Reminders the person chose to show as busy, kept in step with the day
/// marks clients see.
///
/// A day's mark is always rebuilt as the person's own mark (what they set
/// by hand in the day view) plus the busy time of every reminder still
/// active on that day. So cancelling, completing or deleting a reminder
/// frees its time, and moving it moves the busy time with it.
///
/// Kept on this device (Hive box [boxName]):
/// - `r:<bookingId>` → `{"minutes": 60}`: a reminder that shows as busy.
/// - `p:<bookingId>` → `{"day": "2026-10-30", "from": 540, "to": 600}`:
///   where its busy time was last written.
/// - `m:<userId>:<day>` → the person's own mark for that day, without any
///   reminder time: `{"status": "busy", "slots": [...]}` or `{}` for none.
class ReminderBusySync {
  ReminderBusySync(this._ref);

  final Ref _ref;

  static const boxName = 'reminder_busy_v1';

  /// One sync at a time, in order.
  Future<void> _queue = Future.value();

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) return Hive.box<Map>(boxName);
    return Hive.openBox<Map>(boxName);
  }

  static String dayKey(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';

  static DateTime? _parseDay(Object? raw) {
    if (raw is! String) return null;
    final parsed = DateTime.tryParse(raw);
    return parsed == null
        ? null
        : DateTime(parsed.year, parsed.month, parsed.day);
  }

  /// Shows the reminder made for [bookingId] as busy for [minutes].
  Future<void> register(String bookingId, int minutes) async {
    final box = await _box();
    await box.put('r:$bookingId', {'minutes': minutes});
    await sync();
  }

  /// Saves the person's own mark for [day] from the day view. The busy time
  /// of active reminders is taken out first, so it can be freed with them.
  Future<void> setOwnMark(DateTime day, DayMark? mark) {
    return _enqueue(() async {
      final userId = _ref.read(sessionProvider).user?.id;
      if (userId == null) return;
      final box = await _box();
      final reminders = await _ref.read(remindersRepositoryProvider).fetchAll();
      final slots = await _activeSlotsByDay(box, reminders);
      final day0 = DateTime(day.year, day.month, day.day);
      final own = stripReminderSlots(mark, slots[day0] ?? const []);
      await box.put('m:$userId:${dayKey(day0)}', _markToMap(own));
      await _write(userId, day0, combineBusy(own, slots[day0] ?? const []));
    });
  }

  /// Brings every day touched by a busy reminder in line with the reminders
  /// as they are now.
  Future<void> sync() {
    return _enqueue(() async {
      final userId = _ref.read(sessionProvider).user?.id;
      if (userId == null) return;
      final box = await _box();
      final reminders = await _ref.read(remindersRepositoryProvider).fetchAll();
      final byBooking = {
        for (final r in reminders)
          if (r.bookingId != null) r.bookingId!: r,
      };

      final changedDays = <DateTime>{};
      final keys = box.keys
          .whereType<String>()
          .where((k) => k.startsWith('r:'))
          .toList();
      for (final key in keys) {
        final bookingId = key.substring(2);
        final minutes = (box.get(key)?['minutes'] as num?)?.toInt() ?? 60;
        final reminder = byBooking[bookingId];
        final placed = box.get('p:$bookingId');
        final oldDay = _parseDay(placed?['day']);
        final oldFrom = (placed?['from'] as num?)?.toInt();
        final oldTo = (placed?['to'] as num?)?.toInt();

        final want = reminder == null ? null : _placement(reminder, minutes);
        final same = want != null &&
            oldDay == want.$1 &&
            oldFrom == want.$2.start &&
            oldTo == want.$2.end;
        if (same) continue;

        if (oldDay != null) changedDays.add(oldDay);
        if (want == null) {
          await box.delete('p:$bookingId');
          // A deleted reminder is gone for good.
          if (reminder == null) await box.delete(key);
        } else {
          changedDays.add(want.$1);
          await box.put('p:$bookingId', {
            'day': dayKey(want.$1),
            'from': want.$2.start,
            'to': want.$2.end,
          });
        }
      }
      if (changedDays.isEmpty) return;

      final slots = await _activeSlotsByDay(box, reminders);
      for (final day in changedDays) {
        final own = await _ownMark(box, userId, day, slots[day] ?? const []);
        await _write(userId, day, combineBusy(own, slots[day] ?? const []));
      }
    });
  }

  Future<void> _enqueue(Future<void> Function() job) {
    final next = _queue.then((_) => job()).catchError((Object _) {});
    _queue = next;
    return next;
  }

  /// Where a reminder's busy time falls; null when it no longer holds.
  static (DateTime, TimeRange)? _placement(Reminder reminder, int minutes) {
    if (!reminder.status.isActive ||
        reminder.status == AppointmentStatus.cancelled) {
      return null;
    }
    final at = reminder.scheduledAt;
    final from = at.hour * 60 + at.minute;
    final to = (from + minutes).clamp(from + 1, 24 * 60);
    return (DateTime(at.year, at.month, at.day), TimeRange(from, to));
  }

  /// The busy time of every reminder still active, by day.
  Future<Map<DateTime, List<TimeRange>>> _activeSlotsByDay(
    Box<Map> box,
    List<Reminder> reminders,
  ) async {
    final byBooking = {
      for (final r in reminders)
        if (r.bookingId != null) r.bookingId!: r,
    };
    final result = <DateTime, List<TimeRange>>{};
    for (final key in box.keys.whereType<String>()) {
      if (!key.startsWith('r:')) continue;
      final reminder = byBooking[key.substring(2)];
      if (reminder == null) continue;
      final minutes = (box.get(key)?['minutes'] as num?)?.toInt() ?? 60;
      final want = _placement(reminder, minutes);
      if (want == null) continue;
      result.putIfAbsent(want.$1, () => []).add(want.$2);
    }
    return result;
  }

  /// The person's own mark for [day]. The first time a reminder touches a
  /// day, the mark already there is taken as their own.
  Future<DayMark?> _ownMark(
    Box<Map> box,
    String userId,
    DateTime day,
    List<TimeRange> reminderSlots,
  ) async {
    final key = 'm:$userId:${dayKey(day)}';
    final stored = box.get(key);
    if (stored != null) return _markFromMap(stored);
    final marks = await _ref
        .read(scheduleCalendarRepositoryProvider)
        .fetchMarksForMonth(userId: userId, month: day);
    final own = stripReminderSlots(marks[day], reminderSlots);
    await box.put(key, _markToMap(own));
    return own;
  }

  Future<void> _write(String userId, DateTime day, DayMark? mark) async {
    await _ref
        .read(scheduleCalendarRepositoryProvider)
        .setMark(userId: userId, day: day, mark: mark);
    _ref.invalidate(scheduleMonthSnapshotProvider);
    _ref.invalidate(ownerUpcomingMarksProvider(userId));
  }

  static Map<String, Object?> _markToMap(DayMark? mark) => mark == null
      ? <String, Object?>{}
      : {'status': mark.status.storageValue, 'slots': mark.slotsJson()};

  static DayMark? _markFromMap(Map raw) {
    final status = ScheduleDayAvailability.fromStorage(raw['status'] as String?);
    if (status == ScheduleDayAvailability.unset) return null;
    return DayMark(status, slots: DayMark.slotsFrom(raw['slots']));
  }
}

/// The day's mark with reminder busy time laid over the person's own: a
/// day busy all day stays so; otherwise busy at the union of both.
DayMark? combineBusy(DayMark? own, List<TimeRange> reminderSlots) {
  if (reminderSlots.isEmpty) return own;
  if (own != null &&
      own.status == ScheduleDayAvailability.busy &&
      own.wholeDay) {
    return own;
  }
  final ownBusy = own != null && own.status == ScheduleDayAvailability.busy
      ? own.slots!
      : const <TimeRange>[];
  return DayMark(
    ScheduleDayAvailability.busy,
    slots: joinTimeRanges([...ownBusy, ...reminderSlots]),
  );
}

/// [mark] without the reminders' busy time, so only what the person set by
/// hand remains. Whole-day marks and free marks are kept as they are.
DayMark? stripReminderSlots(DayMark? mark, List<TimeRange> reminderSlots) {
  if (mark == null ||
      reminderSlots.isEmpty ||
      mark.status != ScheduleDayAvailability.busy ||
      mark.wholeDay) {
    return mark;
  }
  var left = [...mark.slots!];
  for (final cut in reminderSlots) {
    left = [
      for (final r in left) ...[
        if (cut.end <= r.start || cut.start >= r.end)
          r
        else ...[
          if (cut.start > r.start) TimeRange(r.start, cut.start),
          if (cut.end < r.end) TimeRange(cut.end, r.end),
        ],
      ],
    ];
  }
  return left.isEmpty
      ? null
      : DayMark(ScheduleDayAvailability.busy, slots: joinTimeRanges(left));
}

/// [ranges] sorted, with overlapping or touching ones joined.
List<TimeRange> joinTimeRanges(List<TimeRange> ranges) {
  final sorted = [...ranges]..sort((a, b) => a.start.compareTo(b.start));
  final joined = <TimeRange>[];
  for (final range in sorted) {
    if (joined.isNotEmpty && range.start <= joined.last.end) {
      final last = joined.removeLast();
      joined.add(
        TimeRange(last.start, range.end > last.end ? range.end : last.end),
      );
    } else {
      joined.add(range);
    }
  }
  return joined;
}

final reminderBusySyncServiceProvider = Provider<ReminderBusySync>(
  (ref) => ReminderBusySync(ref),
);

/// Watched once at the app's root: every time the reminders change (added,
/// cancelled, completed, moved, deleted), busy time follows.
final reminderBusySyncProvider = Provider<void>((ref) {
  // Only for someone signed in; guests have no marks.
  if (ref.watch(sessionProvider.select((s) => s.user?.id)) == null) return;
  final service = ref.watch(reminderBusySyncServiceProvider);
  ref.listen<AsyncValue<List<Reminder>>>(
    remindersProvider,
    (_, next) {
      if (next.hasValue) unawaited(service.sync());
    },
    fireImmediately: true,
  );
});
