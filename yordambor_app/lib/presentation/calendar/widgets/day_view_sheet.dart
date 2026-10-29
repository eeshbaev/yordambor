import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/application/providers/schedule_calendar_providers.dart';
import 'package:yordambor/application/schedule/reminder_busy_sync.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/schedule_calendar_event.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_add_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_open_helper.dart';
import 'package:yordambor/presentation/xizmat/widgets/xizmat_schedule_section.dart';

/// Opens one day as an hour-by-hour timeline, like a desktop calendar.
Future<void> showDayViewSheet(BuildContext context, {required DateTime day}) {
  return showModalBottomSheet<void>(
    context: context,
    sheetAnimationStyle: AppMotion.sheetOf(context),
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.92,
      child: DayViewSheet(initialDay: day),
    ),
  );
}

/// One day: whether it is a working day, the whole-day busy switch, then
/// the hours. Working hours are green, busy time red, the rest grey;
/// appointments and reminders sit on top as blocks. Tap a block to open
/// it, tap an empty hour to add a reminder there or mark it busy or free.
class DayViewSheet extends ConsumerStatefulWidget {
  const DayViewSheet({super.key, required this.initialDay});

  final DateTime initialDay;

  @override
  ConsumerState<DayViewSheet> createState() => _DayViewSheetState();
}

const double _hourHeight = 64;
const double _gutter = 52;

class _DayViewSheetState extends ConsumerState<DayViewSheet> {
  late DateTime _day = _dateOnly(widget.initialDay);
  final _scroll = ScrollController();
  bool _saving = false;

  /// Scroll to the start of the day (or to now) after the next frame.
  bool _jumpPending = true;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _goTo(DateTime day) {
    final next = _dateOnly(day);
    final month = ref.read(scheduleVisibleMonthProvider);
    if (next.year != month.year || next.month != month.month) {
      ref.read(scheduleVisibleMonthProvider.notifier).state =
          DateTime(next.year, next.month);
    }
    AppHaptics.select();
    setState(() {
      _day = next;
      _jumpPending = true;
    });
  }

  Future<void> _setMark(DayMark? mark) async {
    final userId = ref.read(sessionProvider).user?.id;
    if (userId == null || _saving) return;
    setState(() => _saving = true);
    try {
      // Through the sync, so reminders shown as busy stay theirs.
      await ref.read(reminderBusySyncServiceProvider).setOwnMark(_day, mark);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(appStringsProvider).stateErrorBody)),
        );
      }
    }
    ref.invalidate(scheduleMonthSnapshotProvider);
    ref.invalidate(ownerUpcomingMarksProvider(userId));
    if (mounted) setState(() => _saving = false);
  }

  /// Busy at [range], on top of what the day already has.
  Future<void> _markBusy(DayMark? mark, TimeRange range) {
    final merged = mergeBusyHours(
      {_day: ?mark},
      {_day: [range]},
    );
    return _setMark(merged[_day]);
  }

  /// Free at [range]: taken out of the busy time.
  Future<void> _markFree(
    DayMark? mark,
    TimeRange range,
    WorkingHours hours,
  ) {
    if (mark == null || mark.status != ScheduleDayAvailability.busy) {
      return Future.value();
    }
    final busy = mark.wholeDay ? hours.ranges : mark.slots!;
    final left = subtractTimeRange(busy, range);
    return _setMark(
      left.isEmpty
          ? null
          : DayMark(ScheduleDayAvailability.busy, slots: left),
    );
  }

  Future<void> _onEmptyHour({
    required int hour,
    required DayMark? mark,
    required WorkingHours hours,
    required bool isProvider,
    required AppStrings strings,
  }) async {
    final range = TimeRange(hour * 60, math.min((hour + 1) * 60, 24 * 60));
    final busy = isBusyAt(mark, range, hours);
    final start = _day.add(Duration(hours: hour));
    final choice = await showModalBottomSheet<int>(
      context: context,
      sheetAnimationStyle: AppMotion.sheetOf(context),
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                range.label,
                style: AppTypography.tabular(
                  AppTypography.headline.copyWith(
                    color: sheetContext.ybColors.ink,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(YbIcons.addAlarmFilled),
              title: Text(strings.remindersAdd),
              onTap: () => Navigator.of(sheetContext).pop(0),
            ),
            if (isProvider)
              ListTile(
                leading: Icon(
                  busy ? YbIcons.checkCircleFilled : YbIcons.eventBusyFilled,
                ),
                title: Text(
                  busy ? strings.calendarSlotMarkFree : strings.calendarSlotMarkBusy,
                ),
                onTap: () => Navigator.of(sheetContext).pop(1),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
    if (!mounted || choice == null) return;
    if (choice == 0) {
      await showReminderAddSheet(
        context: context,
        ref: ref,
        strings: strings,
        initialStart: start,
      );
      ref.invalidate(scheduleMonthSnapshotProvider);
    } else {
      await (busy ? _markFree(mark, range, hours) : _markBusy(mark, range));
    }
  }

  Future<void> _openReminder(ScheduleCalendarEvent event) async {
    final reminder =
        await ref.read(remindersRepositoryProvider).fetchById(event.id);
    if (reminder == null || !mounted) return;
    await openReminderContext(
      context: context,
      ref: ref,
      strings: ref.read(appStringsProvider),
      reminder: reminder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final locale = strings.languageCode;
    final snapshot = ref.watch(scheduleMonthSnapshotProvider).valueOrNull;
    final hours =
        ref.watch(myWorkingHoursProvider).valueOrNull ?? WorkingHours.standard;
    final mark = snapshot?.marks[_day];
    final isProvider = snapshot?.isProvider ?? false;
    final events = snapshot?.eventsByDay[_day] ?? const [];
    final appointments = ref.watch(
      appointmentsByDayProvider.select(
        (map) => map[_day] ?? const <CalendarAppointment>[],
      ),
    );
    final timed = [
      for (final a in appointments)
        if (a.range != null && !a.isCancelled) a,
    ];
    final allDay = [
      for (final a in appointments)
        if (a.range == null && !a.isCancelled) a,
    ];
    final working = hours.worksOn(_day);
    final busyAllDay =
        mark?.status == ScheduleDayAvailability.busy && mark!.wholeDay;

    // The hours shown: the working day with room around it, widened to
    // anything that falls outside.
    var first = working && hours.ranges.isNotEmpty
        ? math.max(0, hours.ranges.first.start ~/ 60 - 1)
        : 8;
    var last = working && hours.ranges.isNotEmpty
        ? math.min(24, (hours.ranges.last.end + 59) ~/ 60 + 1)
        : 20;
    for (final e in events) {
      first = math.min(first, e.scheduledAt.hour);
      last = math.max(last, math.min(24, e.scheduledAt.hour + 1));
    }
    for (final a in timed) {
      first = math.min(first, a.range!.start ~/ 60);
      last = math.max(last, math.min(24, (a.range!.end + 59) ~/ 60));
    }
    final now = DateTime.now();
    final isToday = _dateOnly(now) == _day;
    final scrollTarget = isToday
        ? math.max(0.0, (now.hour - first - 1) * _hourHeight)
        : 0.0;
    if (_jumpPending) {
      _jumpPending = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scroll.hasClients) return;
        _scroll.jumpTo(
          scrollTarget.clamp(0.0, _scroll.position.maxScrollExtent),
        );
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Day header with arrows.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              IconButton(
                tooltip: strings.calendarPreviousDay,
                onPressed: () => _goTo(_day.subtract(const Duration(days: 1))),
                icon: Icon(YbIcons.chevronLeftFilled, color: colors.ink2),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.quick),
                  child: Text(
                    DateFormat.MMMMEEEEd(locale).format(_day),
                    key: ValueKey(_day),
                    textAlign: TextAlign.center,
                    style: AppTypography.headline.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: strings.calendarNextDay,
                onPressed: () => _goTo(_day.add(const Duration(days: 1))),
                icon: Icon(YbIcons.chevronRightFilled, color: colors.ink2),
              ),
            ],
          ),
        ),
        // Working day or day off, and the whole-day switch.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _Pill(
                    icon: working
                        ? YbIcons.scheduleFilled
                        : YbIcons.eventBusyFilled,
                    label: working
                        ? '${strings.calendarDayWorking} · ${hours.label}'
                        : strings.calendarDayOff,
                    fill: working ? colors.successSoft : colors.surface2,
                    ink: working ? colors.success : colors.ink2,
                  ),
                ),
              ),
              if (isProvider) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  strings.calendarBusyAllDay,
                  style: AppTypography.caption.copyWith(color: colors.ink2),
                ),
                Switch(
                  value: busyAllDay,
                  onChanged: _saving
                      ? null
                      : (on) => _setMark(
                            on
                                ? const DayMark(ScheduleDayAvailability.busy)
                                : null,
                          ),
                ),
              ],
            ],
          ),
        ),
        if (allDay.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Column(
              children: [
                for (final a in allDay)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _Block(
                      title: a.serviceName,
                      subtitle: a.otherPartyName,
                      fill: colors.tealSoft,
                      ink: colors.tealInk,
                      icon: YbIcons.eventAvailableFilled,
                      onTap: () => context.push('/kelishuv/${a.id}'),
                    ),
                  ),
              ],
            ),
          ),
        Divider(height: 1, color: colors.line),
        Expanded(
          child: SingleChildScrollView(
            controller: _scroll,
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: _Timeline(
              key: ValueKey('timeline-$_day'),
              first: first,
              last: last,
              hours: hours,
              working: working,
              mark: mark,
              events: events,
              appointments: timed,
              nowMinute: isToday ? now.hour * 60 + now.minute : null,
              onEmptyHour: (hour) => _onEmptyHour(
                hour: hour,
                mark: mark,
                hours: hours,
                isProvider: isProvider,
                strings: strings,
              ),
              onAppointment: (a) => context.push('/kelishuv/${a.id}'),
              onReminder: _openReminder,
            ),
          ),
        ),
      ],
    );
  }
}

/// Whether the day's mark makes [range] busy.
bool isBusyAt(DayMark? mark, TimeRange range, WorkingHours hours) {
  if (mark == null || mark.status != ScheduleDayAvailability.busy) {
    return false;
  }
  if (mark.wholeDay) return true;
  return mark.slots!.any((s) => s.start < range.end && s.end > range.start);
}

/// [ranges] with [cut] taken out, sorted.
List<TimeRange> subtractTimeRange(List<TimeRange> ranges, TimeRange cut) {
  final out = <TimeRange>[];
  for (final r in ranges) {
    if (cut.end <= r.start || cut.start >= r.end) {
      out.add(r);
      continue;
    }
    if (cut.start > r.start) out.add(TimeRange(r.start, cut.start));
    if (cut.end < r.end) out.add(TimeRange(cut.end, r.end));
  }
  return out..sort((a, b) => a.start.compareTo(b.start));
}

/// One item placed on the timeline, in minutes, with its lane.
class _Placed {
  _Placed(this.start, this.end, this.child);

  final int start;
  final int end;
  final Widget Function(double height) child;
  int lane = 0;
  int lanes = 1;
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    super.key,
    required this.first,
    required this.last,
    required this.hours,
    required this.working,
    required this.mark,
    required this.events,
    required this.appointments,
    required this.nowMinute,
    required this.onEmptyHour,
    required this.onAppointment,
    required this.onReminder,
  });

  final int first;
  final int last;
  final WorkingHours hours;
  final bool working;
  final DayMark? mark;
  final List<ScheduleCalendarEvent> events;
  final List<CalendarAppointment> appointments;
  final int? nowMinute;
  final ValueChanged<int> onEmptyHour;
  final ValueChanged<CalendarAppointment> onAppointment;
  final ValueChanged<ScheduleCalendarEvent> onReminder;

  double _y(int minute) => (minute - first * 60) / 60 * _hourHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final height = (last - first) * _hourHeight;

    // Background bands: working hours green, busy time red.
    final free = working ? hours.ranges : const <TimeRange>[];
    final busy = mark?.status == ScheduleDayAvailability.busy
        ? (mark!.wholeDay
            ? [TimeRange(first * 60, last * 60)]
            : mark!.slots!)
        : const <TimeRange>[];

    // Blocks, laid out in lanes where they overlap.
    final placed = <_Placed>[
      for (final a in appointments)
        _Placed(
          a.range!.start,
          a.range!.end,
          (h) => _Block(
            title: a.serviceName,
            subtitle:
                '${a.range!.label} · ${a.otherPartyName}',
            fill: colors.teal,
            ink: colors.onTeal,
            icon: YbIcons.eventAvailableFilled,
            height: h,
            onTap: () => onAppointment(a),
          ),
        ),
      for (final e in events)
        _Placed(
          e.scheduledAt.hour * 60 + e.scheduledAt.minute,
          math.min(24 * 60, e.scheduledAt.hour * 60 + e.scheduledAt.minute + 45),
          (h) => _Block(
            title: e.title,
            subtitle: DateFormat.Hm().format(e.scheduledAt),
            fill: switch (e.role) {
              ScheduleEventRole.needHelp => colors.apricotSoft,
              ScheduleEventRole.giveHelp => colors.tealSoft,
              ScheduleEventRole.personal => colors.surface2,
            },
            ink: switch (e.role) {
              ScheduleEventRole.needHelp => colors.apricotInk,
              ScheduleEventRole.giveHelp => colors.tealInk,
              ScheduleEventRole.personal => colors.ink,
            },
            icon: YbIcons.alarm,
            height: h,
            onTap: () => onReminder(e),
          ),
        ),
    ]..sort((a, b) => a.start.compareTo(b.start));
    _assignLanes(placed);

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final area = constraints.maxWidth - _gutter - AppSpacing.lg;
          return Stack(
            children: [
              for (final r in free)
                _band(r, colors.successSoft.withValues(alpha: 0.7)),
              for (final r in busy)
                _band(r, colors.errorSoft),
              // Hour lines, labels and the tap targets.
              for (var h = first; h < last; h++)
                Positioned(
                  top: _y(h * 60),
                  left: 0,
                  right: 0,
                  height: _hourHeight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onEmptyHour(h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: _gutter,
                          child: Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.md),
                            child: Text(
                              TimeRange.clock(h * 60),
                              style: AppTypography.tabular(
                                AppTypography.caption.copyWith(
                                  color: colors.ink3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: colors.line),
                              ),
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              for (final p in placed)
                Positioned(
                  top: _y(p.start) + 1,
                  left: _gutter + 4 + area / p.lanes * p.lane,
                  width: area / p.lanes - 4,
                  height: math.max(30.0, _y(p.end) - _y(p.start) - 2),
                  child: p.child(
                    math.max(30.0, _y(p.end) - _y(p.start) - 2),
                  ),
                ),
              if (nowMinute != null &&
                  nowMinute! >= first * 60 &&
                  nowMinute! <= last * 60)
                Positioned(
                  top: _y(nowMinute!) - 1,
                  left: _gutter - 4,
                  right: 0,
                  child: IgnorePointer(
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Container(height: 2, color: colors.error),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _band(TimeRange r, Color color) {
    final start = math.max(r.start, first * 60);
    final end = math.min(r.end, last * 60);
    if (end <= start) return const SizedBox.shrink();
    return Positioned(
      top: _y(start),
      height: _y(end) - _y(start),
      left: _gutter,
      right: 0,
      child: IgnorePointer(child: ColoredBox(color: color)),
    );
  }

  /// Side by side where blocks overlap: each cluster of overlapping blocks
  /// shares its width, each block in the first free lane.
  static void _assignLanes(List<_Placed> items) {
    var i = 0;
    while (i < items.length) {
      var clusterEnd = items[i].end;
      var j = i;
      final laneEnds = <int>[];
      while (j < items.length && (j == i || items[j].start < clusterEnd)) {
        final item = items[j];
        var lane = laneEnds.indexWhere((end) => end <= item.start);
        if (lane == -1) {
          lane = laneEnds.length;
          laneEnds.add(item.end);
        } else {
          laneEnds[lane] = item.end;
        }
        item.lane = lane;
        clusterEnd = math.max(clusterEnd, item.end);
        j++;
      }
      for (var k = i; k < j; k++) {
        items[k].lanes = laneEnds.length;
      }
      i = j;
    }
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.title,
    required this.subtitle,
    required this.fill,
    required this.ink,
    required this.icon,
    required this.onTap,
    this.height,
  });

  final String title;
  final String subtitle;
  final Color fill;
  final Color ink;
  final IconData icon;
  final VoidCallback onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final roomy = (height ?? 60) >= 48;
    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, size: 14, color: ink),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(
                        color: ink,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    if (roomy)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: ink.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.fill,
    required this.ink,
  });

  final IconData icon;
  final String label;
  final Color fill;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: ink),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(color: ink, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
