import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/l10n/app_localizations_en.dart';

void main() {
  final strings = AppStrings(AppLocalizationsEn());

  test('hidden when availability is not visible', () {
    const item = XizmatFeedItem(
      id: '1',
      name: 'Test',
      categoryLabel: 'A',
      subcategoryLabel: 'B',
      categoryId: 'a',
      subcategoryId: 'b',
      heroImageUrl: 'https://example.com/a.jpg',
      rating: 5,
      completedCount: 1,
    );

    expect(xizmatAvailabilityDisplay(item, strings), isNull);
  });

  test('shows available now with until suffix', () {
    final item = XizmatFeedItem(
      id: '1',
      name: 'Test',
      categoryLabel: 'A',
      subcategoryLabel: 'B',
      categoryId: 'a',
      subcategoryId: 'b',
      heroImageUrl: 'https://example.com/a.jpg',
      rating: 5,
      completedCount: 1,
      availabilityVisible: true,
      availabilityMode: XizmatAvailabilityMode.availableNow,
      availabilityUntil: DateTime(2099, 1, 1, 18, 30),
    );

    final display = xizmatAvailabilityDisplay(
      item,
      strings,
      now: DateTime(2099, 1, 1, 12),
    );

    expect(display, isNotNull);
    expect(display!.tone, YbStatusTone.success);
    expect(display.label, contains('Available now'));
    expect(display.label, contains('18:30'));
  });

  test('hidden after until time passes', () {
    final item = XizmatFeedItem(
      id: '1',
      name: 'Test',
      categoryLabel: 'A',
      subcategoryLabel: 'B',
      categoryId: 'a',
      subcategoryId: 'b',
      heroImageUrl: 'https://example.com/a.jpg',
      rating: 5,
      completedCount: 1,
      availabilityVisible: true,
      availabilityMode: XizmatAvailabilityMode.busy,
      availabilityUntil: DateTime(2020, 1, 1, 10),
    );

    expect(
      xizmatAvailabilityDisplay(item, strings, now: DateTime(2026, 1, 1)),
      isNull,
    );
  });
}
