import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';

class AppNotificationTapListener extends ConsumerStatefulWidget {
  const AppNotificationTapListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppNotificationTapListener> createState() =>
      _AppNotificationTapListenerState();
}

class _AppNotificationTapListenerState
    extends ConsumerState<AppNotificationTapListener> {
  @override
  void initState() {
    super.initState();
    LocalNotificationService.instance.onAppNotificationTap = _onTap;
  }

  @override
  void dispose() {
    LocalNotificationService.instance.onAppNotificationTap = null;
    super.dispose();
  }

  void _onTap(Map<String, String> payload) {
    final kelishuvId = payload['kelishuv_id'];
    final xizmatId = payload['xizmat_id'];
    final postId = payload['post_id'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final router = GoRouter.of(context);
      if (kelishuvId != null && kelishuvId.isNotEmpty) {
        router.push('/kelishuv/$kelishuvId');
      } else if (postId != null && postId.isNotEmpty) {
        router.push('/post/$postId');
      } else if (xizmatId != null && xizmatId.isNotEmpty) {
        router.push('/xizmat/$xizmatId');
      } else {
        router.push('/notifications');
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
