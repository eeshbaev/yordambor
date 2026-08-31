import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/pending_reminder_notification.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_add_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_open_helper.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_status_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_tile.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  bool _followUpChecked = false;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(localNotificationServiceProvider).requestPermission();
      await _maybePromptFollowUp();
    });
  }

  Future<void> _maybePromptFollowUp() async {
    if (_followUpChecked || !mounted) return;
    _followUpChecked = true;

    final needingFollowUp =
        await ref.read(remindersRepositoryProvider).fetchNeedingFollowUp();
    if (needingFollowUp.isEmpty || !mounted) return;

    final reminder = needingFollowUp.first;
    final strings = ref.read(appStringsProvider);
    await showReminderStatusSheet(
      context: context,
      ref: ref,
      strings: strings,
      reminder: reminder,
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
    final remindersAsync = ref.watch(remindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.remindersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: strings.remindersSettingsTitle,
            onPressed: () => context.push('/reminders/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showReminderAddSheet(
          context: context,
          ref: ref,
          strings: strings,
        ),
        icon: const Icon(Icons.add),
        label: Text(strings.remindersAdd),
      ),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async => invalidateProviderTools(ref),
          child: remindersAsync.when(
            loading: () => const YbSkeletonList(count: 4),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                YbEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: strings.remindersTitle,
                  subtitle: '$error',
                ),
              ],
            ),
            data: (items) {
              if (items.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    YbEmptyState(
                      icon: Icons.alarm_outlined,
                      title: strings.remindersEmptyTitle,
                      subtitle: strings.remindersEmptySubtitle,
                    ),
                  ],
                );
              }

              final upcoming = items.where((r) => !r.isPast).toList();
              final past = items.where((r) => r.isPast).toList();

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 88),
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
          ),
        ),
      ),
    );
  }
}
