import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/presentation/calendar/widgets/time_ranges_editor.dart';

/// Edits a usual working day. Returns the new hours, or null when the person
/// keeps the old ones.
Future<WorkingHours?> showWorkingHoursSheet(
  BuildContext context, {
  required AppStrings strings,
  required WorkingHours initial,
  String? title,
}) {
  return showModalBottomSheet<WorkingHours>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => _WorkingHoursSheet(
      strings: strings,
      initial: initial,
      title: title,
    ),
  );
}

class _WorkingHoursSheet extends StatefulWidget {
  const _WorkingHoursSheet({
    required this.strings,
    required this.initial,
    this.title,
  });

  final AppStrings strings;
  final WorkingHours initial;
  final String? title;

  @override
  State<_WorkingHoursSheet> createState() => _WorkingHoursSheetState();
}

class _WorkingHoursSheetState extends State<_WorkingHoursSheet> {
  late List<TimeRange> _ranges = [...widget.initial.ranges];

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final valid = timeRangesValid(_ranges);

    return YbSheetBody(
      title: widget.title ?? strings.workingHoursTitle,
      subtitle: strings.workingHoursSheetHint,
      children: [
        TimeRangesEditor(
          ranges: _ranges,
          strings: strings,
          onChanged: (next) => setState(() => _ranges = next),
        ),
        if (!valid) ...[
          const SizedBox(height: AppSpacing.sm),
          YbInlineMessage(message: strings.workingHoursInvalid),
        ],
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => setState(
              () => _ranges = [...WorkingHours.standard.ranges],
            ),
            icon: const Icon(YbIcons.replay, size: 18),
            label: Text(strings.workingHoursReset),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        YbPrimaryButton(
          label: strings.actionSave,
          onPressed: valid
              ? () => Navigator.of(context).pop(
                    WorkingHours(sortedTimeRanges(_ranges)),
                  )
              : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        YbSecondaryButton(
          label: strings.actionCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
