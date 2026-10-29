import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';

import 'helpers/app_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setUpPluginFakes);
  setUp(mockReturningGuestPrefs);

  testWidgets('Profile tab shows guest content', (tester) async {
    await pumpAppToHome(tester);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(find.text('YordamBor’ga xush kelibsiz'), findsOneWidget);
    expect(find.text('Kirish'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(YbSurfaceCard), findsWidgets);
  });
}
