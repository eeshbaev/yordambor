import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/presentation/shell/floating_tab_bar.dart';
import 'package:yordambor/presentation/xizmat/xizmat_profile_screen.dart';

import 'helpers/app_harness.dart';

/// Frames instead of pumpAndSettle: a skeleton's shimmer never settles.
Future<void> _pumpFrames(WidgetTester tester, [int count = 10]) async {
  for (var i = 0; i < count; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Sets the window to [width] × [height] dp and the text size to [scale].
void _setWindow(
  WidgetTester tester, {
  required double width,
  required double height,
  double scale = 1,
}) {
  tester.view.physicalSize = Size(width * 3, height * 3);
  tester.view.devicePixelRatio = 3;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

const _tabs = ['Saqlangan', 'Kalendar', 'Biznes', 'Profil', 'Asosiy'];

Future<void> _visitTabs(WidgetTester tester) async {
  for (final tab in _tabs) {
    await tester.tap(
      find.descendant(
        of: find.byType(FloatingTabBar),
        matching: find.text(tab),
      ),
    );
    await _pumpFrames(tester);
    expect(tester.takeException(), isNull, reason: 'tab $tab');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setUpPluginFakes);
  setUp(mockReturningGuestPrefs);

  // A small phone (360 dp wide) at the default text size and at 200 %
  // (manual T-01/T-02). An overflow anywhere fails the test and names the
  // widget that overflowed.
  for (final scale in [1.0, 2.0]) {
    testWidgets('Main tabs fit a small phone at ${(scale * 100).round()} % text',
        (tester) async {
      _setWindow(tester, width: 360, height: 780, scale: scale);
      await pumpAppToHome(tester);
      expect(find.byType(FloatingTabBar), findsOneWidget);

      // Down the feed and back, so the cards are laid out too.
      await tester.drag(
        find.byType(CustomScrollView).first,
        const Offset(0, -900),
      );
      await _pumpFrames(tester, 5);
      await tester.drag(
        find.byType(CustomScrollView).first,
        const Offset(0, 900),
      );
      await _pumpFrames(tester, 5);
      expect(tester.takeException(), isNull);

      await _visitTabs(tester);
    });
  }

  testWidgets('Tablet: a rail, and cards open beside the feed',
      (tester) async {
    _setWindow(tester, width: 1280, height: 800);
    await pumpAppToHome(tester);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(FloatingTabBar), findsNothing);
    // Nothing open yet.
    expect(find.text('Kartani tanlang'), findsOneWidget);

    final card = find.byKey(const ValueKey('xizmat-card-demo-sanjar-plumber'));
    await tester.ensureVisible(card);
    await _pumpFrames(tester, 3);
    await tester.tap(card);
    await _pumpFrames(tester);

    expect(find.byType(XizmatProfileScreen), findsOneWidget);
    expect(find.text('Kartani tanlang'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
