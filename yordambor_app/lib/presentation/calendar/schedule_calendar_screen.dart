import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/pending_reminder_notification.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/application/providers/schedule_calendar_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/domain/entities/schedule_calendar_event.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/auth/auth_bottom_sheet.dart';
import 'package:yordambor/presentation/calendar/widgets/appointment_pass.dart';
import 'package:yordambor/presentation/calendar/widgets/calendar_reminders_list.dart';
import 'package:yordambor/presentation/calendar/widgets/schedule_month_grid.dart';
import 'package:yordambor/presentation/calendar/widgets/service_availability_sheet.dart';
import 'package:yordambor/presentation/calendar/widgets/time_ranges_editor.dart';
import 'package:yordambor/presentation/calendar/widgets/working_hours_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_status_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_add_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_open_helper.dart';

class ScheduleCalendarScreen extends ConsumerStatefulWidget {
  const ScheduleCalendarScreen({super.key});

  @override
  ConsumerState<ScheduleCalendarScreen> createState() =>
      _ScheduleCalendarScreenState();
}

class _ScheduleCalendarScreenState extends ConsumerState<ScheduleCalendarScreen> {
  DateTime? _selectedDay;
  bool _followUpChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(localNotificationServiceProvider).requestPermission();
      await _maybePromptFollowUp();
    });
  }

  Future<void> _openReminderById(String reminderId) async {
    final reminder =
        await ref.read(remindersRepositoryProvider).fetchById(reminderId);
    if (reminder == null || !mounted) return;
    final strings = ref.read(appStringsProvider);
    await openReminderContext(
      context: context,
      ref: ref,
      strings: strings,
      reminder: reminder,
    );
  }

  Future<void> _maybePromptFollowUp() async {
    if (_followUpChecked || !mounted) return;
    _followUpChecked = true;

    final needingFollowUp =
        await ref.read(remindersRepositoryProvider).fetchNeedingFollowUp();
    if (needingFollowUp.isEmpty || !mounted) return;

    final strings = ref.read(appStringsProvider);
    await showReminderStatusSheet(
      context: context,
      ref: ref,
      strings: strings,
      reminder: needingFollowUp.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(pendingReminderTapProvider, (previous, next) {
      if (next == null) return;
      ref.read(pendingReminderTapProvider.notifier).state = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openReminderById(next);
      });
    });

    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final colors = context.ybColors;

    if (session.isLoading) {
      return const YbSkeletonList(count: 4);
    }

    if (!session.isAuthenticated) {
      return ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppShell.scrollBottomPadding(context),
        ),
        children: [
          YbEmptyState(
            icon: YbIcons.calendarMonthFilled,
            title: strings.tabCalendar,
            subtitle: strings.calendarGuestSubtitle,
            actionLabel: strings.login,
            onAction: () => showAuthBottomSheet(
              context,
              ref,
              initialTab: AuthSheetTab.login,
            ),
          ),
        ],
      );
    }

    final month = ref.watch(scheduleVisibleMonthProvider);
    final snapshotAsync = ref.watch(scheduleMonthSnapshotProvider);
    final locale = _localeTag(ref.watch(onboardingPrefsProvider).language);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showReminderAddSheet(
          context: context,
          ref: ref,
          strings: strings,
        ),
        icon: const Icon(YbIcons.addFilled),
        label: Text(strings.remindersAdd),
      ),
      body: RefreshIndicator(
        onRefresh: () => CalendarRemindersList.refresh(ref),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            AppShell.scrollBottomPadding(context, includeExtendedFab: true),
          ),
          children: [
          _CalendarHeader(
            month: month,
            locale: locale,
            strings: strings,
            selectedDay: _selectedDay,
            onPrev: () => _shiftMonth(-1),
            onNext: () => _shiftMonth(1),
            onDaySelected: (day) => setState(() => _selectedDay = day),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            child: snapshotAsync.when(
              loading: () =>
                  const YbSkeletonBox(width: double.infinity, height: 320),
              error: (_, _) => Text(strings.profileSectionLoadFailed),
              data: (snapshot) {
                final selected = _selectedDay ?? DateTime.now();
                final day =
                    DateTime(selected.year, selected.month, selected.day);
                final dayEvents = snapshot.eventsByDay[day] ?? const [];
                // Appointments on the selected day.
                final dayAppts = ref.watch(
                  appointmentsByDayProvider.select(
                    (map) => map[day] ?? const <CalendarAppointment>[],
                  ),
                );
                final savedClients = ref.watch(savedClientAccountsProvider);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Legend(
                      strings: strings,
                      showStatus: snapshot.isProvider,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      snapshot.isProvider
                          ? strings.calendarHintMark
                          : strings.calendarHintClient,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    if (snapshot.isProvider) ...[
                      const SizedBox(height: AppSpacing.md),
                      const _WorkingHoursTile(),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    YbSurfaceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            DateFormat.yMMMd(locale).format(selected),
                            style: AppTypography.title.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          // Appointments on this day.
                          if (dayAppts.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              strings.calendarTabTitle,
                              style: AppTypography.label.copyWith(
                                color: colors.ink2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            for (final appt in dayAppts)
                              AppointmentPass(
                                key: ValueKey('appt-${appt.id}'),
                                appt: appt,
                                strings: strings,
                                onCancel: () => _cancelAppointment(appt.id),
                                onSaveClient:
                                    appt.iProvide && appt.isActive &&
                                            !savedClients.contains(appt.otherPartyId)
                                        ? () => _promptSaveClient(appt)
                                        : null,
                              ),
                          ],
                          // "Band vaqt" busy control for providers.
                          if (snapshot.isProvider) ...[
                            const SizedBox(height: AppSpacing.sm),
                            _BusyDayControl(
                              key: ValueKey('busy-${day.toIso8601String()}'),
                              mark: snapshot.marks[day],
                              strings: strings,
                              workingHours:
                                  ref.watch(myWorkingHoursProvider).valueOrNull ??
                                      WorkingHours.standard,
                              onChanged: (mark) => _saveMark(day, mark),
                            ),
                          ],
                          // Reminders for this day (non-appointment).
                          const SizedBox(height: AppSpacing.md),
                          if (dayEvents.isEmpty && dayAppts.isEmpty)
                            Text(
                              strings.calendarNoRemindersDay,
                              style: AppTypography.bodyRegular.copyWith(
                                color: colors.textSecondary,
                              ),
                            )
                          else if (dayEvents.isNotEmpty) ...[
                            Text(
                              strings.calendarDayEvents,
                              style: AppTypography.label.copyWith(
                                color: colors.ink2,
                              ),
                            ),
                            for (final event in dayEvents)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  _roleIcon(event.role),
                                  color: _roleColor(colors, event.role),
                                ),
                                title: Text(event.title),
                                subtitle: Text(
                                  DateFormat.Hm(locale).format(event.scheduledAt),
                                ),
                                onTap: () async {
                                  final reminder = await ref
                                      .read(remindersRepositoryProvider)
                                      .fetchById(event.id);
                                  if (reminder == null || !context.mounted) {
                                    return;
                                  }
                                  await openReminderContext(
                                    context: context,
                                    ref: ref,
                                    strings: strings,
                                    reminder: reminder,
                                  );
                                },
                              ),
                          ],
                          const SizedBox(height: AppSpacing.sm),
                          YbSecondaryButton(
                            label: strings.remindersAdd,
                            icon: YbIcons.addAlarmFilled,
                            onPressed: () => showReminderAddSheet(
                              context: context,
                              ref: ref,
                              strings: strings,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              strings.remindersTitle,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const CalendarRemindersList(),
          // Services strip — providers only.
          const _ServicesStrip(),
          SizedBox(height: AppShell.scrollBottomPadding(context, includeExtendedFab: true) / 2),
        ],
        ),
      ),
    );
  }

  void _shiftMonth(int delta) {
    final current = ref.read(scheduleVisibleMonthProvider);
    ref.read(scheduleVisibleMonthProvider.notifier).state =
        DateTime(current.year, current.month + delta);
    setState(() => _selectedDay = null);
  }

  /// Saves the day's mark (null clears it) and shows the calendar again.
  Future<void> _saveMark(DateTime day, DayMark? mark) async {
    final userId = ref.read(sessionProvider).user?.id;
    if (userId == null) return;

    await ref
        .read(scheduleCalendarRepositoryProvider)
        .setMark(userId: userId, day: day, mark: mark);
    if (!mounted) return;
    ref.invalidate(scheduleMonthSnapshotProvider);
    ref.invalidate(ownerUpcomingMarksProvider(userId));
    setState(() => _selectedDay = day);
  }

  Future<void> _cancelAppointment(String dealId) async {
    final userId = ref.read(sessionProvider).user?.id;
    if (userId == null) return;
    try {
      await ref
          .read(kelishuvRepositoryProvider)
          .cancel(dealId, userId);
      if (!mounted) return;
      ref.invalidate(myAppointmentsProvider);
    } catch (e) {
      // Errors surface in the Kelishuv screen; nothing more to do here.
    }
  }

  Future<void> _promptSaveClient(CalendarAppointment appt) async {
    final strings = ref.read(appStringsProvider);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.saveClientPromptTitle),
        content: Text(strings.saveClientPromptBody(appt.otherPartyName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(strings.saveClientSkip),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(strings.saveClientConfirm),
          ),
        ],
      ),
    );
    await ClientSavePrompts.markAsked(appt.id);
    if (saved == true && mounted) {
      await ref.read(clientRegistryRepositoryProvider).create(
            clientName: appt.otherPartyName,
            yordamBorUserId: appt.otherPartyId,
          );
      invalidateProviderTools(ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.saveClientDone)),
        );
      }
    }
  }

  String _localeTag(String language) => switch (language) {
        'ru' => 'ru',
        'en' => 'en',
        'zh' => 'zh',
        _ => 'uz',
      };
}

class _CalendarHeader extends ConsumerWidget {
  const _CalendarHeader({
    required this.month,
    required this.locale,
    required this.strings,
    required this.selectedDay,
    required this.onPrev,
    required this.onNext,
    required this.onDaySelected,
  });

  final DateTime month;
  final String locale;
  final AppStrings strings;
  final DateTime? selectedDay;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(scheduleMonthSnapshotProvider);
    final weekdayLabels = strings.calendarWeekdayShortLabels;
    final colors = context.ybColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: strings.actionPreviousMonth,
                onPressed: onPrev,
                icon: Icon(YbIcons.chevronLeftFilled, color: colors.ink2),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(locale).format(month),
                  textAlign: TextAlign.center,
                  style: AppTypography.headline.copyWith(
                    color: colors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: strings.actionNextMonth,
                onPressed: onNext,
                icon: Icon(YbIcons.chevronRightFilled, color: colors.ink2),
              ),
              IconButton(
                tooltip: strings.remindersSettingsTitle,
                onPressed: () => context.push('/reminders/settings'),
                icon: Icon(YbIcons.tuneFilled, color: colors.ink2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          snapshotAsync.when(
            loading: () => const SizedBox(height: 280),
            error: (_, _) => const SizedBox.shrink(),
            data: (snapshot) => ScheduleMonthGrid(
              month: month,
              marks: snapshot.marks,
              eventsByDay: snapshot.eventsByDay,
              selectedDay: selectedDay,
              weekdayLabels: weekdayLabels,
              onDaySelected: onDaySelected,
            ),
          ),
        ],
      ),
    );
  }
}

/// Help the person asked for in apricot, help they give in teal, their own
/// notes in grey: the same colours as the dots on the days.
IconData _roleIcon(ScheduleEventRole role) => switch (role) {
      ScheduleEventRole.needHelp => YbIcons.campaignFilled,
      ScheduleEventRole.giveHelp => YbIcons.handshake,
      ScheduleEventRole.personal => YbIcons.notificationsActiveFilled,
    };

Color _roleColor(YbThemeColors colors, ScheduleEventRole role) =>
    switch (role) {
      ScheduleEventRole.needHelp => colors.apricot,
      ScheduleEventRole.giveHelp => colors.teal,
      ScheduleEventRole.personal => colors.ink3,
    };

/// What the colours mean, in two groups: the person's free and busy days
/// (which clients see), then their reminders.
class _Legend extends StatelessWidget {
  const _Legend({required this.strings, required this.showStatus});

  final AppStrings strings;

  /// Free and busy days are for people who offer services.
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final caption = AppTypography.label.copyWith(color: colors.ink2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showStatus) ...[
          Text(strings.calendarStatusCaption, style: caption),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: [
              _LegendItem(
                swatch: _DaySwatch(
                  fill: colors.successSoft,
                  edge: colors.success,
                ),
                label: strings.calendarLegendAvailable,
              ),
              _LegendItem(
                swatch: _DaySwatch(fill: colors.error),
                label: strings.calendarLegendBusy,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Text(strings.remindersTitle, style: caption),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: [
            for (final role in ScheduleEventRole.values)
              _LegendItem(
                swatch: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _roleColor(colors, role),
                    shape: BoxShape.circle,
                  ),
                ),
                label: switch (role) {
                  ScheduleEventRole.needHelp => strings.calendarLegendNeedHelp,
                  ScheduleEventRole.giveHelp => strings.calendarLegendGiveHelp,
                  ScheduleEventRole.personal => strings.calendarLegendPersonal,
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.swatch, required this.label});

  final Widget swatch;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        swatch,
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: context.ybColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// A small day cell, coloured like the calendar's.
class _DaySwatch extends StatelessWidget {
  const _DaySwatch({required this.fill, this.edge});

  final Color fill;
  final Color? edge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(4),
        border: edge == null ? null : Border.all(color: edge!, width: 1.5),
      ),
    );
  }
}

/// The person's usual working day, one tap from changing it.
class _WorkingHoursTile extends ConsumerWidget {
  const _WorkingHoursTile();

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    WorkingHours hours,
  ) async {
    final strings = ref.read(appStringsProvider);
    final picked = await showWorkingHoursSheet(
      context,
      strings: strings,
      initial: hours,
    );
    if (picked == null || !context.mounted) return;
    final userId = ref.read(sessionProvider).user?.id;
    if (userId == null) return;
    final messenger = ScaffoldMessenger.of(context);

    var saved = true;
    try {
      await ref.read(workingHoursRepositoryProvider).saveForUser(userId, picked);
    } catch (_) {
      saved = false;
    }
    if (!context.mounted) return;
    ref.invalidate(myWorkingHoursProvider);
    ref.invalidate(userWorkingHoursProvider(userId));
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
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final hours =
        ref.watch(myWorkingHoursProvider).valueOrNull ?? WorkingHours.standard;

    return Semantics(
      button: true,
      label: '${strings.workingHoursTitle}: ${hours.label}. '
          '${strings.workingHoursHint}',
      excludeSemantics: true,
      child: Material(
        color: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: colors.borderSubtle),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () => _edit(context, ref, hours),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.tealSoft,
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                  child: SizedBox.square(
                    dimension: 44,
                    child: Icon(YbIcons.schedule, color: colors.teal),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.workingHoursTitle,
                        style: AppTypography.label.copyWith(
                          color: colors.ink2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hours.label,
                        style: AppTypography.tabular(
                          AppTypography.headline.copyWith(color: colors.ink),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        strings.workingHoursHint,
                        style: AppTypography.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  strings.actionEdit,
                  style: AppTypography.label.copyWith(
                    color: colors.teal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A simpler "Band vaqt" control: toggle busy all day or pick hours.
class _BusyDayControl extends StatefulWidget {
  const _BusyDayControl({
    super.key,
    required this.mark,
    required this.strings,
    required this.workingHours,
    required this.onChanged,
  });

  final DayMark? mark;
  final AppStrings strings;
  final WorkingHours workingHours;
  final ValueChanged<DayMark?> onChanged;

  @override
  State<_BusyDayControl> createState() => _BusyDayControlState();
}

class _BusyDayControlState extends State<_BusyDayControl> {
  late bool _busyAllDay;
  late List<TimeRange> _slots;

  @override
  void initState() {
    super.initState();
    _busyAllDay = widget.mark?.status == ScheduleDayAvailability.busy &&
        (widget.mark?.slots ?? const []).isEmpty;
    _slots = [...?widget.mark?.slots];
  }

  @override
  void didUpdateWidget(covariant _BusyDayControl old) {
    super.didUpdateWidget(old);
    if (old.mark != widget.mark) {
      _busyAllDay = widget.mark?.status == ScheduleDayAvailability.busy &&
          (widget.mark?.slots ?? const []).isEmpty;
      _slots = [...?widget.mark?.slots];
    }
  }

  void _toggleBusy(bool value) {
    setState(() {
      _busyAllDay = value;
      if (!value) _slots = [];
    });
    widget.onChanged(
      value
          ? const DayMark(ScheduleDayAvailability.busy)
          : null,
    );
  }

  void _setSlots(List<TimeRange> slots) {
    setState(() => _slots = slots);
    if (!timeRangesValid(slots)) return;
    widget.onChanged(
      DayMark(ScheduleDayAvailability.busy, slots: sortedTimeRanges(slots)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final colors = context.ybColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _busyAllDay,
          onChanged: _toggleBusy,
          title: Text(
            strings.calendarBusyTitle,
            style: AppTypography.body.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            strings.calendarBusyAllDay,
            style: AppTypography.caption.copyWith(color: colors.ink2),
          ),
        ),
        if (_busyAllDay) ...[
          const SizedBox(height: AppSpacing.xs),
          OutlinedButton.icon(
            onPressed: () => showWorkingHoursSheet(
              context,
              strings: strings,
              initial: widget.workingHours,
            ),
            icon: const Icon(YbIcons.scheduleFilled, size: 18),
            label: Text(strings.availabilityHoursTitle),
          ),
          if (_slots.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            TimeRangesEditor(
              ranges: _slots,
              strings: strings,
              onChanged: _setSlots,
            ),
            if (!timeRangesValid(_slots))
              YbInlineMessage(message: strings.workingHoursInvalid),
          ],
        ],
      ],
    );
  }
}

/// Horizontal strip of the provider's services at the bottom of the
/// calendar screen. Tapping one opens the availability sheet.
class _ServicesStrip extends ConsumerWidget {
  const _ServicesStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    if (!session.isAuthenticated) return const SizedBox.shrink();

    final mineAsync = ref.watch(myXizmatlarProvider);
    final items = mineAsync.valueOrNull;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              strings.calendarServicesStrip,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) =>
                  _ServiceChip(item: items[i], strings: strings),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceChip extends ConsumerWidget {
  const _ServiceChip({required this.item, required this.strings});

  final XizmatFeedItem item;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;
    final icon = CategoryIcons.forService(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
    );

    return YbScaleTap(
      onTap: () => showServiceAvailabilitySheet(context, ref, item: item),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: colors.teal),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.serviceDisplayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Free or busy for one day, and when: the whole working day unless the
/// person picks hours. Every valid change is saved at once.
class _DayStatusEditor extends StatefulWidget {
  const _DayStatusEditor({
    super.key,
    required this.mark,
    required this.strings,
    required this.workingHours,
    required this.onChanged,
  });

  final DayMark? mark;
  final AppStrings strings;
  final WorkingHours workingHours;
  final ValueChanged<DayMark?> onChanged;

  @override
  State<_DayStatusEditor> createState() => _DayStatusEditorState();
}

class _DayStatusEditorState extends State<_DayStatusEditor> {
  late ScheduleDayAvailability _status;
  late List<TimeRange> _slots;

  /// Hours picked by hand; else the whole working day.
  late bool _custom;

  @override
  void initState() {
    super.initState();
    _load(widget.mark);
  }

  @override
  void didUpdateWidget(covariant _DayStatusEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A new mark from the server replaces what is shown; the same one keeps
    // an edit in progress.
    if (!_sameMark(oldWidget.mark, widget.mark)) _load(widget.mark);
  }

  void _load(DayMark? mark) {
    _status = mark?.status ?? ScheduleDayAvailability.unset;
    _slots = [...?mark?.slots];
    _custom = _slots.isNotEmpty;
  }

  static bool _sameMark(DayMark? a, DayMark? b) {
    if (a == null || b == null) return a == b;
    if (a.status != b.status) return false;
    final x = a.slots ?? const <TimeRange>[];
    final y = b.slots ?? const <TimeRange>[];
    if (x.length != y.length) return false;
    for (var i = 0; i < x.length; i++) {
      if (x[i] != y[i]) return false;
    }
    return true;
  }

  void _emit() {
    if (_status == ScheduleDayAvailability.unset) {
      widget.onChanged(null);
      return;
    }
    // Hours that do not make sense wait, with a note, until they are fixed.
    if (_custom && !timeRangesValid(_slots)) return;
    widget.onChanged(
      DayMark(_status, slots: _custom ? sortedTimeRanges(_slots) : null),
    );
  }

  void _setStatus(ScheduleDayAvailability status) {
    if (status == _status) return;
    setState(() => _status = status);
    _emit();
  }

  void _setWholeDay(bool wholeDay) {
    setState(() {
      _custom = !wholeDay;
      if (_custom && _slots.isEmpty) {
        _slots = [widget.workingHours.ranges.first];
      }
    });
    _emit();
  }

  void _setSlots(List<TimeRange> slots) {
    setState(() {
      _slots = slots;
      if (slots.isEmpty) _custom = false;
    });
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final colors = context.ybColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final (index, status) in ScheduleDayAvailability.values.indexed) ...[
              if (index > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatusChoice(
                  status: status,
                  selected: status == _status,
                  label: switch (status) {
                    ScheduleDayAvailability.unset => strings.calendarDayNotMarked,
                    ScheduleDayAvailability.available =>
                      strings.calendarLegendAvailable,
                    ScheduleDayAvailability.busy => strings.calendarLegendBusy,
                  },
                  onTap: () => _setStatus(status),
                ),
              ),
            ],
          ],
        ),
        if (_status != ScheduleDayAvailability.unset) ...[
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: !_custom,
            onChanged: _setWholeDay,
            title: Text(
              strings.calendarWholeWorkingDay,
              style: AppTypography.body.copyWith(
                color: colors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              widget.workingHours.label,
              style: AppTypography.caption.copyWith(color: colors.ink2),
            ),
          ),
          if (_custom) ...[
            const SizedBox(height: AppSpacing.xs),
            TimeRangesEditor(
              ranges: _slots,
              strings: strings,
              onChanged: _setSlots,
            ),
            if (!timeRangesValid(_slots))
              YbInlineMessage(message: strings.workingHoursInvalid),
          ],
        ],
      ],
    );
  }
}

/// One of "Not marked", "Free" and "Busy": chosen, it takes the colour the
/// day will have in the calendar.
class _StatusChoice extends StatelessWidget {
  const _StatusChoice({
    required this.status,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final ScheduleDayAvailability status;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final (Color fill, Color ink, Color edge) = switch (status) {
      ScheduleDayAvailability.available => selected
          ? (colors.successSoft, colors.success, colors.success)
          : (colors.card, colors.ink2, colors.line),
      ScheduleDayAvailability.busy => selected
          ? (colors.error, colors.onError, colors.error)
          : (colors.card, colors.ink2, colors.line),
      ScheduleDayAvailability.unset => selected
          ? (colors.surface2, colors.ink, colors.outline)
          : (colors.card, colors.ink2, colors.line),
    };

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: edge, width: selected ? 1.5 : 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppTouch.minTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.sm,
              ),
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(
                    color: ink,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
