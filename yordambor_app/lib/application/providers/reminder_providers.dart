import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/data/reminders/reminders_repository.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/domain/entities/reminder_settings.dart';

final localNotificationServiceProvider =
    Provider<LocalNotificationService>((ref) {
  return LocalNotificationService.instance;
});

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  return RemindersRepository(ref.watch(localNotificationServiceProvider));
});

final remindersProvider = FutureProvider<List<Reminder>>((ref) async {
  return ref.watch(remindersRepositoryProvider).fetchAll();
});

final upcomingRemindersCountProvider = FutureProvider<int>((ref) async {
  final upcoming = await ref.watch(remindersRepositoryProvider).fetchUpcoming();
  return upcoming.length;
});

final reminderSettingsProvider = FutureProvider<ReminderSettings>((ref) async {
  return ref.watch(remindersRepositoryProvider).fetchSettings();
});
