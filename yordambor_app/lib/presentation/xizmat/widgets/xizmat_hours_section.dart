import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/schedule_calendar_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/presentation/calendar/widgets/working_hours_sheet.dart';

/// On "manage service": the days and hours this service is offered. With
/// one service they are the person's working hours, edited right here; with
/// two to five services, each one can keep hours of its own. Saved at once.
class XizmatHoursSection extends ConsumerStatefulWidget {
  const XizmatHoursSection({super.key, required this.xizmatId});

  final String xizmatId;

  @override
  ConsumerState<XizmatHoursSection> createState() =>
      _XizmatHoursSectionState();
}

class _XizmatHoursSectionState extends ConsumerState<XizmatHoursSection> {
  bool _saving = false;

  Future<void> _edit(WorkingHours initial) async {
    final strings = ref.read(appStringsProvider);
    final picked = await showWorkingHoursSheet(
      context,
      strings: strings,
      initial: initial,
      title: strings.xizmatOwnHoursTitle,
    );
    if (picked == null || !mounted) return;
    await _save(picked);
  }

  /// The person's own hours, which a single service follows.
  Future<void> _editMine(WorkingHours initial) async {
    final strings = ref.read(appStringsProvider);
    final repo = ref.read(workingHoursRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final userId = ref.read(sessionProvider).user?.id;
    final picked = await showWorkingHoursSheet(
      context,
      strings: strings,
      initial: initial,
    );
    if (picked == null || userId == null || !mounted) return;
    setState(() => _saving = true);
    var saved = true;
    try {
      await repo.saveForUser(userId, picked);
    } catch (_) {
      saved = false;
    }
    if (!mounted) return;
    ref.invalidate(myWorkingHoursProvider);
    ref.invalidate(userWorkingHoursProvider(userId));
    setState(() => _saving = false);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            saved ? strings.workingHoursSaved : strings.stateErrorBody,
          ),
        ),
      );
  }

  /// [hours] null: the service follows the person's hours again.
  Future<void> _save(WorkingHours? hours) async {
    final strings = ref.read(appStringsProvider);
    final repo = ref.read(workingHoursRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    var saved = true;
    try {
      await repo.saveForXizmat(widget.xizmatId, hours);
      saved = repo.supportsServiceHours;
    } catch (_) {
      saved = false;
    }
    if (!mounted) return;
    ref.invalidate(xizmatOwnHoursProvider(widget.xizmatId));
    setState(() => _saving = false);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            saved ? strings.workingHoursSaved : strings.stateErrorBody,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final services = ref.watch(myXizmatlarProvider).valueOrNull ?? const [];
    final several = services.length >= 2;
    final myHours =
        ref.watch(myWorkingHoursProvider).valueOrNull ?? WorkingHours.standard;
    final own = several
        ? ref.watch(xizmatOwnHoursProvider(widget.xizmatId)).valueOrNull
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(YbIcons.schedule, color: colors.teal, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    strings.workingHoursTitle,
                    style: AppTypography.headline.copyWith(color: colors.ink),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (!several) ...[
              Text(
                myHours.fullLabel(strings.calendarWeekdayShortLabels),
                style: AppTypography.tabular(
                  AppTypography.body.copyWith(
                    color: colors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: _saving ? null : () => _editMine(myHours),
                  icon: const Icon(YbIcons.edit, size: 18),
                  label: Text(strings.actionEdit),
                ),
              ),
            ] else ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: own != null,
                onChanged: _saving
                    ? null
                    : (on) => on ? _edit(myHours) : _save(null),
                title: Text(
                  strings.xizmatOwnHoursTitle,
                  style: AppTypography.body.copyWith(
                    color: colors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  own?.fullLabel(strings.calendarWeekdayShortLabels) ??
                      strings.xizmatOwnHoursOff(
                        myHours.fullLabel(strings.calendarWeekdayShortLabels),
                      ),
                  style: AppTypography.caption.copyWith(color: colors.ink2),
                ),
              ),
              if (own != null)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: _saving ? null : () => _edit(own),
                    icon: const Icon(YbIcons.edit, size: 18),
                    label: Text(strings.actionEdit),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
