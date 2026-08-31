import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/data/notifications/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationsProvider =
    FutureProvider<List<AppNotification>>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return [];
  return ref.watch(notificationRepositoryProvider).fetchMine();
});

final unreadNotificationsCountProvider = FutureProvider<int>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return 0;
  return ref.watch(notificationRepositoryProvider).unreadCount();
});
