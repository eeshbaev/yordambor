import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yordambor/app.dart';
import 'package:yordambor/data/onboarding/onboarding_prefs_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      OnboardingPrefsRepository.welcomeSeenKey: true,
    });
  });

  testWidgets('Profile tab shows guest content', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: YordamBorApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.text('YordamBor\'ga xush kelibsiz'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });
}
