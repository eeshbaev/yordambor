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

  testWidgets('App reaches home after splash', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: YordamBorApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('YordamBor'), findsOneWidget);
    expect(find.text('Asosiy'), findsOneWidget);
    expect(find.text('Sanjar — Santexnika'), findsOneWidget);
  });
}
