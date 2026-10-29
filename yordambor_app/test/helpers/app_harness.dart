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
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/data/experience/experience_prefs_repository.dart';
import 'package:yordambor/data/onboarding/onboarding_prefs_repository.dart';

/// Plugins are not registered under `flutter test`: local notifications gets
/// its Android implementation over a silent channel, deep links answer
/// "none", and Hive a temporary home.
void setUpPluginFakes() {
  // Tests run without Supabase, whatever keys this machine has.
  Env.debugConfiguredOverride = false;
  AndroidFlutterLocalNotificationsPlugin.registerWith();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('dexterous.com/flutter/local_notifications'),
    // Answers as a device would: set up, nothing pending, exact alarms
    // allowed; scheduling and cancelling succeed.
    (call) async => switch (call.method) {
      'initialize' => true,
      'pendingNotificationRequests' => <Object?>[],
      'canScheduleExactNotifications' => true,
      _ => null,
    },
  );
  // Deep links: the app was not opened from one, and none arrive.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    ..setMockMethodCallHandler(
      const MethodChannel('com.llfbandit.app_links/messages'),
      (call) async => null,
    )
    ..setMockStreamHandler(
      const EventChannel('com.llfbandit.app_links/events'),
      MockStreamHandler.inline(onListen: (_, _) {}),
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
  Env.debugConfiguredOverride = false;
  // The categories file is parsed in a background isolate, which fake time
  // never finishes; read it for real once, and the app gets it from the
  // bundle's cache.
  await tester.runAsync(
    () => rootBundle.loadString('assets/data/categories.json'),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        upcomingRemindersCountProvider.overrideWith((ref) async => 0),
      ],
      child: const YordamBorApp(),
    ),
  );
  await tester.pump();
  await settleRealWork(tester);
  await tester.pump(const Duration(milliseconds: 1300));
  // Home starts loading its feed once the splash hands off.
  await settleRealWork(tester);
  // Frame by frame, so the launch hand-off and the greeting finish.
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Lets work that runs outside the test clock finish, such as Hive reading
/// its real files. Fake time alone never completes it.
Future<void> settleRealWork(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 500)),
  );
  await tester.pump();
}
