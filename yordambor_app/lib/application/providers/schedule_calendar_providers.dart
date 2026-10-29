import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/data/schedule/schedule_calendar_repository.dart';
import 'package:yordambor/data/schedule/working_hours_repository.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/domain/entities/schedule_calendar_event.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';
import 'package:yordambor/domain/entities/working_hours.dart';

final scheduleCalendarRepositoryProvider =
    Provider<ScheduleCalendarRepository>((ref) {
  return ScheduleCalendarRepository();
});

final workingHoursRepositoryProvider = Provider<WorkingHoursRepository>((ref) {
  return WorkingHoursRepository();
});

final scheduleVisibleMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

class ScheduleMonthSnapshot {
  const ScheduleMonthSnapshot({
    required this.marks,
    required this.eventsByDay,
    required this.isProvider,
  });

  final Map<DateTime, DayMark> marks;
  final Map<DateTime, List<ScheduleCalendarEvent>> eventsByDay;
  final bool isProvider;
}

DateTime _dayKey(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

final scheduleMonthSnapshotProvider =
    FutureProvider<ScheduleMonthSnapshot>((ref) async {
  final userId = ref.watch(sessionProvider.select((s) => s.user?.id));
  if (userId == null) {
    return const ScheduleMonthSnapshot(
      marks: {},
      eventsByDay: {},
      isProvider: false,
    );
  }

  final month = ref.watch(scheduleVisibleMonthProvider);
  final marks = await ref
      .read(scheduleCalendarRepositoryProvider)
      .fetchMarksForMonth(userId: userId, month: month);

  final reminders = await ref.read(remindersRepositoryProvider).fetchAll();
  final mine = await ref.watch(myXizmatlarProvider.future);
  final isProvider = mine.isNotEmpty;

  // Which deals the person gives help in, to tell their reminders apart.
  final iProvideByDeal = <String, bool>{};
  try {
    final incoming = await ref.watch(incomingKelishuvProvider.future);
    final requests = await ref.watch(myKelishuvRequestsProvider.future);
    for (final KelishuvSummary deal in [
      for (final group in incoming) ...group.items,
      ...requests,
    ]) {
      iProvideByDeal[deal.id] = deal.iProvide;
    }
  } catch (_) {
    // Unknown deals read as the person's own reminders.
  }

  final eventsByDay = <DateTime, List<ScheduleCalendarEvent>>{};
  for (final reminder in reminders) {
    if (!_isInMonth(reminder.scheduledAt, month)) continue;
    if (!reminder.isActive && reminder.isPast) continue;
    final key = _dayKey(reminder.scheduledAt);
    eventsByDay
        .putIfAbsent(key, () => [])
        .add(_eventFromReminder(reminder, _roleOf(reminder, iProvideByDeal)));
  }

  for (final list in eventsByDay.values) {
    list.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  return ScheduleMonthSnapshot(
    marks: marks,
    eventsByDay: eventsByDay,
    isProvider: isProvider,
  );
});

bool _isInMonth(DateTime date, DateTime month) =>
    date.year == month.year && date.month == month.month;

ScheduleEventRole _roleOf(Reminder reminder, Map<String, bool> iProvideByDeal) {
  final dealId = reminder.kelishuvId;
  if (dealId != null && iProvideByDeal.containsKey(dealId)) {
    return iProvideByDeal[dealId]!
        ? ScheduleEventRole.giveHelp
        : ScheduleEventRole.needHelp;
  }
  // A booking from the client book is always help the person gives.
  if (reminder.bookingId != null || reminder.clientId != null) {
    return ScheduleEventRole.giveHelp;
  }
  return ScheduleEventRole.personal;
}

ScheduleCalendarEvent _eventFromReminder(
  Reminder reminder,
  ScheduleEventRole role,
) {
  return ScheduleCalendarEvent(
    id: reminder.id,
    title: reminder.title,
    subtitle: reminder.body,
    day: _dayKey(reminder.scheduledAt),
    scheduledAt: reminder.scheduledAt,
    kind: ScheduleEventKind.reminder,
    kelishuvId: reminder.kelishuvId,
    role: role,
  );
}

/// The signed-in person's working hours.
final myWorkingHoursProvider = FutureProvider<WorkingHours>((ref) async {
  final userId = ref.watch(sessionProvider.select((s) => s.user?.id));
  if (userId == null) return WorkingHours.standard;
  return ref.watch(workingHoursRepositoryProvider).fetchForUser(userId);
});

/// Anyone's working hours, as shown on their services. Read again each
/// time a service page opens, so it shows the latest.
final userWorkingHoursProvider =
    FutureProvider.autoDispose.family<WorkingHours, String>((ref, userId) {
  return ref.watch(workingHoursRepositoryProvider).fetchForUser(userId);
});

/// A service's own hours; null when it follows its owner's.
final xizmatOwnHoursProvider =
    FutureProvider.autoDispose.family<WorkingHours?, String>((ref, xizmatId) {
  return ref.watch(workingHoursRepositoryProvider).fetchForXizmat(xizmatId);
});

/// The next two weeks of someone's free and busy days, for their services.
/// Read again each time a service page opens, so a day the provider has
/// just marked shows at once.
final ownerUpcomingMarksProvider = FutureProvider.autoDispose
    .family<Map<DateTime, DayMark>, String>((ref, ownerId) {
  final today = _dayKey(DateTime.now());
  return ref.watch(scheduleCalendarRepositoryProvider).fetchMarksForOwner(
        ownerId: ownerId,
        from: today,
        to: today.add(const Duration(days: 13)),
      );
});
