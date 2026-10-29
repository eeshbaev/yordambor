import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/application/providers/schedule_calendar_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_tile.dart';

class CalendarRemindersList extends ConsumerWidget {
  const CalendarRemindersList({super.key});

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
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: YbEmptyState(
              icon: YbIcons.alarm,
              title: strings.remindersEmptyTitle,
              subtitle: strings.remindersEmptySubtitle,
            ),
          );
        }

        final upcoming = items.where((r) => !r.isPast).toList();
        final past = items.where((r) => r.isPast).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (upcoming.isNotEmpty) ...[
              ReminderSectionHeader(label: strings.remindersUpcoming),
              ...upcoming.map(
                (r) => ReminderTile(reminder: r, strings: strings),
              ),
            ],
            if (past.isNotEmpty) ...[
              ReminderSectionHeader(label: strings.remindersPast),
              ...past.map(
                (r) => ReminderTile(
                  reminder: r,
                  strings: strings,
                  dimmed: true,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  static Future<void> refresh(WidgetRef ref) async {
    invalidateProviderTools(ref);
    ref.invalidate(scheduleMonthSnapshotProvider);
  }
}
