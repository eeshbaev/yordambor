import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/application/providers/analytics_providers.dart';
import 'package:yordambor/core/theme/app_theme.dart';
import 'package:yordambor/data/analytics/analytics_repository.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';
import 'package:yordambor/presentation/business/widgets/business_service_card.dart';

import 'helpers/app_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(setUpPluginFakes);
  setUp(mockReturningGuestPrefs);

  for (final scale in [1.0, 2.0]) {
    testWidgets('a service card shows its stats at ${scale * 100} % text',
        (tester) async {
      tester.view.physicalSize = const Size(360 * 3, 780 * 3);
      tester.view.devicePixelRatio = 3;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            xizmatAnalyticsProvider.overrideWith(
              (ref, id) async => const XizmatAnalytics(
                viewCount: 128,
                favoriteCount: 9,
                incomingDeals: 3,
                completedDeals: 14,
              ),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: BusinessServiceCard(
                  item: XizmatFeedItem(
                    id: 'x1',
                    name: 'Uy tozalash',
                    categoryLabel: 'Uy',
                    subcategoryLabel: 'Tozalash',
                    categoryId: 'home_repair',
                    subcategoryId: 'cleaning',
                    heroImageUrl: '',
                    rating: 4.8,
                    completedCount: 14,
                    pricingModel: XizmatPricingModel.daily,
                    basePrice: 300000,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('128'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
    });
  }
}
