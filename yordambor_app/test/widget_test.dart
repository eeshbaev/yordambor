import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/app_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setUpPluginFakes);
  setUp(mockReturningGuestPrefs);

  testWidgets('App reaches home after splash', (tester) async {
    await pumpAppToHome(tester);

    expect(find.text('YordamBor'), findsOneWidget);
    expect(find.text('Asosiy'), findsOneWidget);
    // One way to start floats over each feed: over the services, offering
    // one.
    expect(find.text('Xizmat qoʻshish'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('xizmat-card-demo-sanjar-plumber')),
      findsOneWidget,
    );
  });
}
