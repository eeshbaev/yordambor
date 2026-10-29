import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/notification_providers.dart';
import 'package:yordambor/application/schedule/reminder_busy_sync.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';

/// Listens for new in-app notifications and surfaces them immediately.
class NotificationsRealtimeListener extends ConsumerStatefulWidget {
  const NotificationsRealtimeListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationsRealtimeListener> createState() =>
      _NotificationsRealtimeListenerState();
}

class _NotificationsRealtimeListenerState
    extends ConsumerState<NotificationsRealtimeListener> {
  RealtimeChannel? _channel;
  String? _subscribedUserId;
  bool _askedPermission = false;

  /// Asks for notifications once per launch, when someone is signed in:
  /// deal alerts, reminders and tips need it (Android 13+). It used to be
  /// asked on every rebuild.
  void _askPermissionOnce() {
    if (_askedPermission || ref.read(sessionProvider).user == null) return;
    _askedPermission = true;
    unawaited(LocalNotificationService.instance.requestPermission());
  }

  @override
  void dispose() {
    unawaited(_channel?.unsubscribe());
    super.dispose();
  }

  void _syncSubscription() {
    if (!Env.isConfigured) return;

    final userId = ref.read(sessionProvider).user?.id;
    if (userId == null) {
      unawaited(_channel?.unsubscribe());
      _channel = null;
      _subscribedUserId = null;
      return;
    }

    if (_subscribedUserId == userId && _channel != null) return;

    unawaited(_channel?.unsubscribe());
    _subscribedUserId = userId;

    final client = Supabase.instance.client;
    _channel = client
        .channel('notifications-$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            ref.invalidate(notificationsProvider);
            ref.invalidate(unreadNotificationsCountProvider);
            _showLocalBanner(payload.newRecord);
          },
        )
        .subscribe();
  }

  Future<void> _showLocalBanner(Map<String, dynamic>? record) async {
    if (record == null) return;
    final payload = record['payload'] as Map<String, dynamic>?;
    final type = record['type'] as String? ?? '';
    final title = payload?['title'] as String? ?? 'YordamBor';
    final body = payload?['body'] as String? ?? '';
    final id = record['id'] as String? ?? type;

    final xizmatId = payload?['xizmat_id'] as String?;
    final postId = payload?['post_id'] as String?;
    final kelishuvId = payload?['kelishuv_id'] as String?;

    final localPayload = LocalNotificationService.instance.buildAppPayload(
      type: type,
      xizmatId: xizmatId,
      postId: postId,
      kelishuvId: kelishuvId,
    );

    await LocalNotificationService.instance.showInstant(
      notificationId: id,
      title: title,
      body: body,
      payload: localPayload,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionProvider.select((s) => s.user?.id), (_, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncSubscription();
        _askPermissionOnce();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncSubscription();
      _askPermissionOnce();
    });

    // Keeps reminders shown as busy in step with the calendar marks.
    ref.watch(reminderBusySyncProvider);

    return widget.child;
  }
}
