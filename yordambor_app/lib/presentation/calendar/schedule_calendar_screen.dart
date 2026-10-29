import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/pending_reminder_notification.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/application/providers/schedule_calendar_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/auth/auth_bottom_sheet.dart';
import 'package:yordambor/presentation/calendar/widgets/calendar_reminders_list.dart';
import 'package:yordambor/presentation/calendar/widgets/day_view_sheet.dart';
import 'package:yordambor/presentation/calendar/widgets/schedule_month_grid.dart';
import 'package:yordambor/presentation/calendar/widgets/service_availability_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_add_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_open_helper.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_status_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_tile.dart';

/// The calendar tab: the month (tap a day to open it hour by hour), the
/// person's services (tap one to set when clients can reach it), a button to
/// add a job reminder, and the reminders, upcoming or cancelled.
class ScheduleCalendarScreen extends ConsumerStatefulWidget {
  const ScheduleCalendarScreen({super.key});

  @override
  ConsumerState<ScheduleCalendarScreen> createState() =>
      _ScheduleCalendarScreenState();
}

/// Which reminders are listed.
enum _ReminderView { upcoming, cancelled }

class _ScheduleCalendarScreenState
    extends ConsumerState<ScheduleCalendarScreen> {
  bool _followUpChecked = false;
  _ReminderView _view = _ReminderView.upcoming;
  DateTime? _selectedDay;

  void _shiftMonth(int delta) {
    final month = ref.read(scheduleVisibleMonthProvider);
    ref.read(scheduleVisibleMonthProvider.notifier).state =
        DateTime(month.year, month.month + delta);
  }

  Future<void> _openDay(DateTime day) async {
    setState(() => _selectedDay = day);
    await showDayViewSheet(context, day: day);
  }

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
    // Loading the appointments keeps their reminders in step with the deals.
    ref.watch(myAppointmentsProvider);

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

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myXizmatlarProvider);
          ref.invalidate(myAppointmentsProvider);
          await CalendarRemindersList.refresh(ref);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: AppShell.scrollBottomPadding(context),
          ),
          children: [
            _MonthHeader(
              month: ref.watch(scheduleVisibleMonthProvider),
              locale: strings.languageCode,
              strings: strings,
              selectedDay: _selectedDay,
              onPrev: () => _shiftMonth(-1),
              onNext: () => _shiftMonth(1),
              onDaySelected: _openDay,
            ),
            const _MyServices(),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        strings.calendarReminders,
                        style: AppTypography.headline.copyWith(
                          color: context.ybColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: strings.remindersSettingsTitle,
                    onPressed: () => context.push('/reminders/settings'),
                    icon: Icon(
                      YbIcons.tuneFilled,
                      color: context.ybColors.ink2,
                    ),
                  ),
                ],
              ),
            ),
            // Job reminders of the person's own: a client (saved to the
            // client list) and, if they want, the time shown as busy.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: YbSecondaryButton(
                label: strings.remindersAdd,
                icon: YbIcons.addAlarmFilled,
                onPressed: () => showReminderAddSheet(
                  context: context,
                  ref: ref,
                  strings: strings,
                ),
              ),
            ),
            _RemindersByStatus(
              view: _view,
              onView: (view) => setState(() => _view = view),
            ),
          ],
        ),
      ),
    );
  }
}

/// The month with its arrows. Busy days red, free days green, a bar for
/// appointments and dots for reminders; a tap opens the day.
class _MonthHeader extends ConsumerWidget {
  const _MonthHeader({
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
    final appointmentDays = ref.watch(
      appointmentsByDayProvider.select(
        (byDay) => {
          for (final entry in byDay.entries)
            if (entry.value.any((appt) => !appt.isCancelled)) entry.key,
        },
      ),
    );
    final colors = context.ybColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
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
              weekdayLabels: strings.calendarWeekdayShortLabels,
              onDaySelected: onDaySelected,
              appointmentDays: appointmentDays,
            ),
          ),
        ],
      ),
    );
  }
}

/// The person's services, one row each: its status as clients see it and
/// its hours. Tapping a row opens that service's availability sheet.
class _MyServices extends ConsumerWidget {
  const _MyServices();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final items = ref.watch(myXizmatlarProvider).valueOrNull;
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              strings.calendarServicesStrip,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            _ServiceRow(item: item, strings: strings),
          ],
        ],
      ),
    );
  }
}

class _ServiceRow extends ConsumerWidget {
  const _ServiceRow({required this.item, required this.strings});

  final XizmatFeedItem item;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;
    final icon = CategoryIcons.forService(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
    );
    final status = xizmatAvailabilityDisplay(item, strings);
    final hours = ref.watch(xizmatOwnHoursProvider(item.id)).valueOrNull ??
        ref.watch(myWorkingHoursProvider).valueOrNull ??
        WorkingHours.standard;

    return YbScaleTap(
      onTap: () => showServiceAvailabilitySheet(context, ref, item: item),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox.square(
                dimension: 48,
                child: YbNetworkImage(
                  url: item.galleryUrls.isNotEmpty ? item.galleryUrls.first : '',
                  placeholderIcon: icon,
                  errorIcon: icon,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.serviceDisplayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hours.fullLabel(strings.calendarWeekdayShortLabels),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.tabular(
                      AppTypography.caption.copyWith(color: colors.ink2),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  YbStatusBadge(
                    label: status?.label ?? strings.availabilityTileHidden,
                    tone: status?.tone ?? YbStatusTone.neutral,
                  ),
                ],
              ),
            ),
            Icon(YbIcons.chevronRight, color: colors.ink3),
          ],
        ),
      ),
    );
  }
}

/// Reminders in two lists: upcoming (not cancelled, not yet due) and
/// cancelled. A two-way switch picks the list.
class _RemindersByStatus extends ConsumerWidget {
  const _RemindersByStatus({required this.view, required this.onView});

  final _ReminderView view;
  final ValueChanged<_ReminderView> onView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final remindersAsync = ref.watch(remindersProvider);

    return remindersAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: YbSkeletonList(count: 3),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(strings.profileSectionLoadFailed),
      ),
      data: (items) {
        final upcoming = <Reminder>[
          for (final r in items)
            if (r.status != AppointmentStatus.cancelled && !r.isPast) r,
        ]..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        final cancelled = <Reminder>[
          for (final r in items)
            if (r.status == AppointmentStatus.cancelled) r,
        ]..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
        final shown =
            view == _ReminderView.upcoming ? upcoming : cancelled;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SegmentedButton<_ReminderView>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: _ReminderView.upcoming,
                    label: Text(
                      '${strings.remindersUpcoming} · ${upcoming.length}',
                    ),
                  ),
                  ButtonSegment(
                    value: _ReminderView.cancelled,
                    label: Text(
                      '${strings.appointmentPhaseCancelled} · '
                      '${cancelled.length}',
                    ),
                  ),
                ],
                selected: {view},
                onSelectionChanged: (picked) => onView(picked.first),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AnimatedSwitcher(
              duration: AppMotion.of(context, AppMotion.standardDuration),
              child: shown.isEmpty
                  ? Padding(
                      key: ValueKey('empty-$view'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: YbEmptyState(
                        icon: view == _ReminderView.upcoming
                            ? YbIcons.alarm
                            : YbIcons.eventBusy,
                        title: view == _ReminderView.upcoming
                            ? strings.remindersEmptyTitle
                            : strings.appointmentPhaseCancelled,
                        subtitle: view == _ReminderView.upcoming
                            ? strings.remindersEmptySubtitle
                            : strings.remindersCancelledEmpty,
                      ),
                    )
                  : Column(
                      key: ValueKey('list-$view'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final r in shown)
                          ReminderTile(
                            reminder: r,
                            strings: strings,
                            dimmed: view == _ReminderView.cancelled,
                          ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}
