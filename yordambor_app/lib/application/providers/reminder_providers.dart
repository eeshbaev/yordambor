import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/data/reminders/reminders_repository.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/domain/entities/reminder_settings.dart';

final localNotificationServiceProvider =
    Provider<LocalNotificationService>((ref) {
  return LocalNotificationService.instance;
});

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  final repository = RemindersRepository(
    ref.watch(localNotificationServiceProvider),
    languageOf: () => ref.read(onboardingPrefsProvider).language,
  );
  // Alerts already scheduled are written in the old language.
  ref.listen(
    onboardingPrefsProvider.select((prefs) => prefs.language),
    (previous, next) {
      if (previous != null && previous != next) {
        repository.rescheduleAll().ignore();
      }
    },
  );
  return repository;
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
