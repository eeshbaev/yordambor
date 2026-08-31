import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';

class XizmatAvailabilitySection extends StatelessWidget {
  const XizmatAvailabilitySection({
    super.key,
    required this.strings,
    required this.visible,
    required this.onVisibleChanged,
    required this.mode,
    required this.onModeChanged,
    required this.from,
    required this.until,
    required this.onFromChanged,
    required this.onUntilChanged,
  });

  final AppStrings strings;
  final bool visible;
  final ValueChanged<bool> onVisibleChanged;
  final XizmatAvailabilityMode? mode;
  final ValueChanged<XizmatAvailabilityMode> onModeChanged;
  final DateTime? from;
  final DateTime? until;
  final ValueChanged<DateTime?> onFromChanged;
  final ValueChanged<DateTime?> onUntilChanged;

  @override
  Widget build(BuildContext context) {
    final showWindow =
        visible && mode != null && mode != XizmatAvailabilityMode.callMe;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.xizmatAvailabilitySectionTitle, style: AppTypography.headline),
        const SizedBox(height: AppSpacing.sm),
        Text(
          strings.xizmatAvailabilitySectionSubtitle,
          style: AppTypography.caption,
        ),
        const SizedBox(height: AppSpacing.lg),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(strings.xizmatAvailabilityShowLabel),
          subtitle: Text(strings.xizmatAvailabilityShowSubtitle),
          value: visible,
          onChanged: onVisibleChanged,
        ),
        if (visible) ...[
          const SizedBox(height: AppSpacing.lg),
          SegmentedButton<XizmatAvailabilityMode>(
            segments: [
              ButtonSegment(
                value: XizmatAvailabilityMode.availableNow,
                label: Text(strings.xizmatAvailabilityAvailableNow),
              ),
              ButtonSegment(
                value: XizmatAvailabilityMode.busy,
                label: Text(strings.xizmatAvailabilityBusy),
              ),
              ButtonSegment(
                value: XizmatAvailabilityMode.callMe,
                label: Text(strings.xizmatAvailabilityCallMe),
              ),
            ],
            selected: mode == null ? {} : {mode!},
            onSelectionChanged: (value) => onModeChanged(value.first),
          ),
        ],
        if (showWindow) ...[
          const SizedBox(height: AppSpacing.lg),
          _DateTimeField(
            label: strings.xizmatAvailabilityFromLabel,
            value: from,
            onChanged: onFromChanged,
            onClear: () => onFromChanged(null),
          ),
          const SizedBox(height: AppSpacing.md),
          _DateTimeField(
            label: strings.xizmatAvailabilityUntilLabel,
            value: until,
            onChanged: onUntilChanged,
            onClear: () => onUntilChanged(null),
          ),
        ],
      ],
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final formatted = value == null
        ? null
        : '${value!.day.toString().padLeft(2, '0')}.${value!.month.toString().padLeft(2, '0')}.${value!.year} '
            '${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}';

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _pick(context),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(formatted ?? label),
            ),
          ),
        ),
        if (value != null) ...[
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close),
            tooltip: label,
          ),
        ],
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final initial = value ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }
}

String? validateXizmatAvailability({
  required bool visible,
  required XizmatAvailabilityMode? mode,
  required DateTime? from,
  required DateTime? until,
  required AppStrings strings,
}) {
  if (!visible) return null;
  if (mode == null) return strings.xizmatAvailabilityModeRequiredError;
  if (from != null && until != null && !until.isAfter(from)) {
    return strings.xizmatAvailabilityWindowInvalidError;
  }
  return null;
}
