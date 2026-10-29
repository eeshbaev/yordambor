import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/schedule_calendar_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_section_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';
import 'package:yordambor/domain/entities/working_hours.dart';

/// On a service: when its provider works, what they say about now, and for
/// the next two weeks which days they marked free (green) or busy (red), as
/// in their calendar. What a client wants to know before asking.
class XizmatScheduleSection extends ConsumerWidget {
  const XizmatScheduleSection({
    super.key,
    required this.xizmatId,
    required this.ownerId,
    this.isDemo = false,
    this.status,
  });

  final String xizmatId;
  final String? ownerId;

  /// Sample services have no calendar; they show the standard hours.
  final bool isDemo;

  /// What the provider says about now: "Hozir mavjud", "Oldindan yozilish".
  final XizmatAvailabilityDisplay? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final owner = isDemo ? null : ownerId;

    // The service's own hours, else its provider's, else the standard day.
    final ownHours =
        isDemo ? null : ref.watch(xizmatOwnHoursProvider(xizmatId)).valueOrNull;
    final ownerHours = owner == null
        ? null
        : ref.watch(userWorkingHoursProvider(owner)).valueOrNull;
    final hours = ownHours ?? ownerHours ?? WorkingHours.standard;

    final marks = owner == null
        ? const <DateTime, DayMark>{}
        : ref.watch(ownerUpcomingMarksProvider(owner)).valueOrNull ??
            const <DateTime, DayMark>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayLine = _todayLine(strings, marks[today]);

    return YbSectionCard(
      icon: YbIcons.scheduleFilled,
      title: strings.xizmatScheduleTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: strings.workingHoursTitle,
            child: Text(
              hours.label,
              style: AppTypography.tabular(
                AppTypography.headline.copyWith(color: colors.ink),
              ),
            ),
          ),
          if (status != null || todayLine != null) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (status != null)
                  YbStatusBadge(label: status!.label, tone: status!.tone),
                if (todayLine != null)
                  _TodayPill(label: todayLine.$1, busy: todayLine.$2),
              ],
            ),
          ],
          if (marks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              strings.xizmatScheduleNextDays,
              style: AppTypography.label.copyWith(color: colors.ink2),
            ),
            const SizedBox(height: AppSpacing.sm),
            _TwoWeeks(
              from: today,
              marks: marks,
              strings: strings,
              locale: strings.languageCode,
            ),
          ],
        ],
      ),
    );
  }

  /// "Busy today: 10:00–12:00", and whether it is busy.
  (String, bool)? _todayLine(AppStrings strings, DayMark? mark) {
    if (mark == null) return null;
    final hours = mark.wholeDay
        ? null
        : mark.slots!.map((slot) => slot.label).join(', ');
    return switch (mark.status) {
      ScheduleDayAvailability.busy => (
          hours == null
              ? strings.xizmatTodayBusy
              : strings.xizmatTodayBusyAt(hours),
          true,
        ),
      ScheduleDayAvailability.available => (
          hours == null
              ? strings.xizmatTodayFree
              : strings.xizmatTodayFreeAt(hours),
          false,
        ),
      ScheduleDayAvailability.unset => null,
    };
  }
}

class _TodayPill extends StatelessWidget {
  const _TodayPill({required this.label, required this.busy});

  final String label;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final (fill, ink) = busy
        ? (colors.errorSoft, colors.error)
        : (colors.successSoft, colors.success);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              busy ? YbIcons.eventBusy : YbIcons.checkCircleFilled,
              size: 16,
              color: ink,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: AppTypography.label.copyWith(color: ink, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fourteen days from today, a week to a row, coloured as in the
/// provider's calendar. Long press (or a screen reader) tells the hours.
class _TwoWeeks extends StatelessWidget {
  const _TwoWeeks({
    required this.from,
    required this.marks,
    required this.strings,
    required this.locale,
  });

  final DateTime from;
  final Map<DateTime, DayMark> marks;
  final AppStrings strings;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final days = [
      for (var i = 0; i < 14; i++) DateTime(from.year, from.month, from.day + i),
    ];

    return Column(
      children: [
        for (var row = 0; row < 2; row++)
          Padding(
            padding: EdgeInsets.only(bottom: row == 0 ? AppSpacing.xs : 0),
            child: Row(
              children: [
                for (final day in days.skip(row * 7).take(7))
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _DayCell(
                        day: day,
                        mark: marks[day],
                        strings: strings,
                        locale: locale,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.mark,
    required this.strings,
    required this.locale,
  });

  final DateTime day;
  final DayMark? mark;
  final AppStrings strings;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final status = mark?.status ?? ScheduleDayAvailability.unset;
    final partly = mark != null && !mark!.wholeDay;
    final (Color fill, Color ink, Color? edge) = switch (status) {
      ScheduleDayAvailability.busy => partly
          ? (colors.errorSoft, colors.error, colors.error)
          : (colors.error, colors.onError, null),
      ScheduleDayAvailability.available => (
          colors.successSoft,
          colors.success,
          partly ? colors.success : null,
        ),
      ScheduleDayAvailability.unset => (colors.surface2, colors.ink2, null),
    };
    final weekday = DateFormat.E(locale).format(day);
    final hours = partly ? mark!.slots!.map((slot) => slot.label).join(', ') : '';
    final state = switch (status) {
      ScheduleDayAvailability.busy => strings.calendarLegendBusy,
      ScheduleDayAvailability.available => strings.calendarLegendAvailable,
      ScheduleDayAvailability.unset => strings.calendarDayNotMarked,
    };
    final description = [
      '$weekday ${day.day}',
      state,
      if (hours.isNotEmpty) hours,
    ].join(', ');

    return Tooltip(
      message: description,
      excludeFromSemantics: true,
      child: Semantics(
        label: description,
        excludeSemantics: true,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: edge == null ? null : Border.all(color: edge, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weekday,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: AppTypography.caption.copyWith(color: ink, fontSize: 11),
              ),
              Text(
                '${day.day}',
                style: AppTypography.tabular(
                  AppTypography.label.copyWith(
                    color: ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
