import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/application/providers/pending_reminder_notification.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/core/router/app_router.dart';

class ReminderTapListener extends ConsumerStatefulWidget {
  const ReminderTapListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReminderTapListener> createState() =>
      _ReminderTapListenerState();
}

class _ReminderTapListenerState extends ConsumerState<ReminderTapListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(localNotificationServiceProvider).onReminderTap = _handleTap;
    });
  }

  @override
  void dispose() {
    LocalNotificationService.instance.onReminderTap = null;
    super.dispose();
  }

  void _handleTap(String reminderId) {
    ref.read(pendingReminderTapProvider.notifier).state = reminderId;
    final router = ref.read(routerProvider);
    final path = router.routerDelegate.currentConfiguration.uri.path;
    if (path != '/reminders') {
      router.push('/reminders');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
