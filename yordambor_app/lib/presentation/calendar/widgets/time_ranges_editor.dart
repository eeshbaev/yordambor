import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/working_hours.dart';

/// Whether [ranges] can be saved: at least one, each starting before it
/// ends, none overlapping another.
bool timeRangesValid(List<TimeRange> ranges) {
  if (ranges.isEmpty) return false;
  final sorted = sortedTimeRanges(ranges);
  for (var i = 0; i < sorted.length; i++) {
    if (!sorted[i].isValid) return false;
    if (i > 0 && sorted[i].start < sorted[i - 1].end) return false;
  }
  return true;
}

/// [ranges] from the earliest.
List<TimeRange> sortedTimeRanges(List<TimeRange> ranges) =>
    [...ranges]..sort((a, b) => a.start.compareTo(b.start));

/// Stretches of a day, each as "from – to" with a button to remove it, and
/// one button to add another after the last.
class TimeRangesEditor extends StatelessWidget {
  const TimeRangesEditor({
    super.key,
    required this.ranges,
    required this.onChanged,
    required this.strings,
  });

  final List<TimeRange> ranges;
  final ValueChanged<List<TimeRange>> onChanged;
  final AppStrings strings;

  Future<void> _pick(
    BuildContext context,
    int index, {
    required bool start,
  }) async {
    final range = ranges[index];
    final minutes = start ? range.start : range.end;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: (minutes ~/ 60) % 24, minute: minutes % 60),
      helpText: start ? strings.calendarHoursFrom : strings.calendarHoursTo,
    );
    if (picked == null) return;
    final value = picked.hour * 60 + picked.minute;
    final next = [...ranges];
    // An end at 0:00 means midnight, the end of the day.
    next[index] = start
        ? TimeRange(value, range.end)
        : TimeRange(range.start, value == 0 ? 24 * 60 : value);
    onChanged(next);
  }

  void _add() {
    final last = ranges.isEmpty ? null : sortedTimeRanges(ranges).last;
    final start = last == null ? 9 * 60 : math.min(last.end + 60, 23 * 60);
    final end = math.min(start + 60, 24 * 60);
    onChanged([...ranges, TimeRange(start, end)]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, range) in ranges.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Flexible(
                  child: _TimeButton(
                    label: TimeRange.clock(range.start),
                    semanticLabel: '${strings.calendarHoursFrom} '
                        '${TimeRange.clock(range.start)}',
                    onTap: () => _pick(context, index, start: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Text(
                    '–',
                    style: AppTypography.headline.copyWith(color: colors.ink2),
                  ),
                ),
                Flexible(
                  child: _TimeButton(
                    label: TimeRange.clock(range.end),
                    semanticLabel: '${strings.calendarHoursTo} '
                        '${TimeRange.clock(range.end)}',
                    onTap: () => _pick(context, index, start: false),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: strings.calendarRemoveHours,
                  onPressed: () => onChanged([...ranges]..removeAt(index)),
                  icon: Icon(YbIcons.close, color: colors.ink2),
                ),
              ],
            ),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: _add,
            icon: const Icon(YbIcons.addFilled, size: 18),
            label: Text(strings.calendarAddHours),
          ),
        ),
      ],
    );
  }
}

/// A time to tap and change: "9:00" in an outlined pill.
class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.semanticLabel,
    required this.onTap,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: colors.outline),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 76,
              minHeight: AppTouch.minTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(YbIcons.schedule, size: 16, color: colors.teal),
                  const SizedBox(width: 6),
                  // With very large text the time shrinks to fit the row.
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: AppTypography.tabular(
                          AppTypography.headline.copyWith(color: colors.ink),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
