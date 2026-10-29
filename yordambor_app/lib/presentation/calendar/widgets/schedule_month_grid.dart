import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/domain/entities/schedule_calendar_event.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';

/// A month of days. Busy days are red all over (light red when busy only at
/// some hours), free days green; under the number, a dot per reminder: the
/// help the person asked for in apricot, help they give in teal, their own
/// notes in grey.
class ScheduleMonthGrid extends StatelessWidget {
  const ScheduleMonthGrid({
    super.key,
    required this.month,
    required this.marks,
    required this.eventsByDay,
    required this.selectedDay,
    required this.weekdayLabels,
    required this.onDaySelected,
    this.appointmentDays = const {},
  });

  final DateTime month;
  final Map<DateTime, DayMark> marks;
  final Map<DateTime, List<ScheduleCalendarEvent>> eventsByDay;
  final DateTime? selectedDay;
  final List<String> weekdayLabels;
  final ValueChanged<DateTime> onDaySelected;

  /// Days with an agreed appointment: a short bar under the number.
  final Set<DateTime> appointmentDays;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final lead = (first.weekday - DateTime.monday) % 7;
    final totalCells = lead + daysInMonth;
    final rows = (totalCells / 7).ceil();
    // 44 dp, taller when large text needs room for the day, its
    // appointment bar and its dots.
    final cellHeight = math.max(
      44.0,
      MediaQuery.textScalerOf(context).scale(13) * 1.5 + 21,
    );

    return Column(
      children: [
        Row(
          children: [
            for (final label in weekdayLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.ink3,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (var row = 0; row < rows; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: _buildCell(
                      colors: colors,
                      index: row * 7 + col,
                      lead: lead,
                      daysInMonth: daysInMonth,
                      height: cellHeight,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCell({
    required YbThemeColors colors,
    required int index,
    required int lead,
    required int daysInMonth,
    required double height,
  }) {
    final dayNum = index - lead + 1;
    if (dayNum < 1 || dayNum > daysInMonth) {
      return SizedBox(height: height);
    }

    final date = DateTime(month.year, month.month, dayNum);
    final mark = marks[DateTime(date.year, date.month, date.day)];
    final events = eventsByDay[DateTime(date.year, date.month, date.day)] ?? [];
    final isToday = _isSameDay(date, DateTime.now());
    final isSelected = selectedDay != null && _isSameDay(date, selectedDay!);

    final status = mark?.status ?? ScheduleDayAvailability.unset;
    final partly = mark != null && !mark.wholeDay;
    // Busy all day: solid red. Busy some hours: light red with a red edge.
    // Free: green.
    final (Color fill, Color number, Color? edge) = switch (status) {
      ScheduleDayAvailability.busy =>
        partly
            ? (colors.errorSoft, colors.error, colors.error)
            : (colors.error, colors.onError, null),
      ScheduleDayAvailability.available => (
        colors.successSoft,
        colors.success,
        partly ? colors.success : null,
      ),
      ScheduleDayAvailability.unset => (
        colors.surface,
        isToday ? colors.teal : colors.ink,
        null,
      ),
    };
    final roles = {for (final event in events) event.role};
    final hasAppointment = appointmentDays.contains(
      DateTime(date.year, date.month, date.day),
    );

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
          side: isSelected
              ? BorderSide(color: colors.teal, width: 2.5)
              : edge != null
              ? BorderSide(color: edge, width: 1.5)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.chip),
          onTap: () => onDaySelected(date),
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // One line always: in a narrow cell with large text the
                // number shrinks rather than wrapping out of the cell.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$dayNum',
                    maxLines: 1,
                    softWrap: false,
                    style: AppTypography.tabular(
                      AppTypography.label.copyWith(
                        fontSize: 13,
                        color: number,
                        fontWeight:
                            isToday ||
                                isSelected ||
                                status != ScheduleDayAvailability.unset
                            ? FontWeight.w700
                            : FontWeight.w400,
                        decoration: isToday ? TextDecoration.underline : null,
                        decorationColor: number,
                      ),
                    ),
                  ),
                ),
                if (hasAppointment) appointmentMarker(colors),
                if (roles.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (roles.contains(ScheduleEventRole.needHelp))
                        _dot(colors.apricot, colors.card),
                      if (roles.contains(ScheduleEventRole.giveHelp))
                        _dot(colors.teal, colors.card),
                      if (roles.contains(ScheduleEventRole.personal))
                        _dot(colors.ink3, colors.card),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The bar that marks an appointment, also used in the legend.
  static Widget appointmentMarker(YbThemeColors colors) {
    return Container(
      width: 14,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 1.5),
      decoration: BoxDecoration(
        color: colors.tealInk,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: colors.card, width: 0.5),
      ),
    );
  }

  /// A light ring keeps the dot visible on a red or green day.
  Widget _dot(Color color, Color ring) {
    return Container(
      width: 7,
      height: 7,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: ring, width: 1),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
