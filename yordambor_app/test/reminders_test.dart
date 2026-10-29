import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/data/reminders/reminders_repository.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/domain/entities/reminder_settings.dart';

void main() {
  group('ReminderSettings', () {
    test('nothing saved: the day before, an hour before and at the time', () {
      const settings = ReminderSettings();
      expect(settings.alertMinutesBefore, [1440, 60, 0]);
      expect(ReminderSettings.fromMap({}).alertMinutesBefore, [1440, 60, 0]);
    });

    test('reads numbers of any kind, drops repeats and bad values', () {
      final settings = ReminderSettings.fromMap({
        'alertMinutesBefore': [60, 60.0, '15', -5, 'x', 1440],
        'followUpHoursAfter': [24, 2],
      });
      expect(settings.alertMinutesBefore, [1440, 60, 15]);
      expect(settings.followUpHoursAfter, [2, 24]);
    });

    test('an empty list falls back to the defaults', () {
      final settings = ReminderSettings.fromMap({
        'alertMinutesBefore': <int>[],
        'followUpHoursAfter': 'bad',
      });
      expect(settings.alertMinutesBefore, ReminderSettings.defaultAlerts);
      expect(settings.followUpHoursAfter, ReminderSettings.defaultFollowUps);
    });
  });

  group('lead times in each language', () {
    test('days, hours, minutes and at the time', () {
      final en = AppStrings.forLanguage('en');
      expect(en.reminderLead(1440), '1 day before');
      expect(en.reminderLead(180), '3 hours before');
      expect(en.reminderLead(15), '15 minutes before');
      expect(en.reminderLead(0), en.remindersSettingsAtTime);
      expect(AppStrings.forLanguage('uz').reminderLead(180), '3 soat oldin');
      expect(AppStrings.forLanguage('ru').reminderLead(180), 'За 3 часа');
      expect(AppStrings.forLanguage('ru').reminderLead(60), 'За 1 час');
    });
  });

  group('RemindersRepository', () {
    setUpAll(() {
      Hive.init(Directory.systemTemp.createTempSync('yb_reminders').path);
    });

    tearDown(() async {
      await Hive.deleteBoxFromDisk(RemindersRepository.boxName);
    });

    test('saved settings are not read as a reminder', () async {
      final repository = RemindersRepository(
        LocalNotificationService.instance,
        languageOf: () => 'en',
      );
      final box = await Hive.openBox<Map>(RemindersRepository.boxName);
      await box.put(
        RemindersRepository.settingsKey,
        const ReminderSettings().toMap(),
      );
      final reminder = Reminder(
        id: 'r1',
        title: 'Haircut',
        scheduledAt: DateTime(2030, 1, 1, 10),
        status: AppointmentStatus.upcoming,
      );
      await box.put(reminder.id, reminder.toMap());
      await box.put('broken', {'id': 'broken'});

      final all = await repository.fetchAll();
      expect(all.map((r) => r.id), ['r1']);
      expect(
        await repository.fetchById(RemindersRepository.settingsKey),
        isNull,
      );
      expect(repository.language, 'en');
      expect(
        (await repository.fetchSettings()).alertMinutesBefore,
        ReminderSettings.defaultAlerts,
      );
    });
  });
}
