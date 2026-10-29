import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yordambor/app.dart';
import 'package:yordambor/application/providers/experience_providers.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/data/experience/experience_prefs_repository.dart';
import 'package:yordambor/data/onboarding/onboarding_prefs_repository.dart';

/// Plugins are not registered under `flutter test`: local notifications gets
/// its Android implementation over a silent channel, and Hive a temporary
/// home.
void setUpPluginFakes() {
  AndroidFlutterLocalNotificationsPlugin.registerWith();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('dexterous.com/flutter/local_notifications'),
    (call) async => null,
  );
  Hive.init(Directory.systemTemp.createTempSync('yb_test_hive').path);
}

/// A returning guest who has seen the welcome and this release's notes.
void mockReturningGuestPrefs() {
  SharedPreferences.setMockInitialValues({
    OnboardingPrefsRepository.welcomeSeenKey: true,
    OnboardingPrefsRepository.onboardingDoneKey: true,
    ExperiencePrefsRepository.whatsNewSeenKey: kWhatsNewVersion,
  });
}

/// Pumps the app through the splash and its hand-off to home.
Future<void> pumpAppToHome(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        upcomingRemindersCountProvider.overrideWith((ref) async => 0),
      ],
      child: const YordamBorApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 1300));
  // Frame by frame, so the launch hand-off and the greeting finish.
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
