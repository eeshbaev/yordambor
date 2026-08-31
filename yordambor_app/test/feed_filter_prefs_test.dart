import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/data/feed/feed_filter_prefs_repository.dart';

void main() {
  group('FeedFilterPrefsRepository', () {
    late FeedFilterPrefsRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = FeedFilterPrefsRepository();
    });

    test('saves and restores filter state', () async {
      await repository.save({
        'mode': 'yordamKerak',
        'categoryId': 'marketing',
        'subcategoryId': 'blogger',
        'categoryLabel': 'Marketing',
        'subcategoryLabel': 'Blogger',
        'providerType': 'individual',
      });

      final restored = await repository.load();
      expect(restored?['mode'], 'yordamKerak');
      expect(restored?['categoryId'], 'marketing');
      expect(restored?['subcategoryId'], 'blogger');
      expect(restored?['providerType'], 'individual');
    });

    test('restore returns null when nothing saved', () async {
      expect(await repository.load(), isNull);
    });
  });

  group('FeedFilterNotifier', () {
    test('restore applies saved filters', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = FeedFilterPrefsRepository();
      await repository.save({
        'mode': 'yordamBor',
        'categoryId': 'home',
        'subcategoryId': 'plumber',
        'categoryLabel': 'Home',
        'subcategoryLabel': 'Plumber',
        'providerType': null,
      });

      final notifier = FeedFilterNotifier(repository);
      await notifier.restore();

      expect(notifier.state.mode, FeedMode.yordamBor);
      expect(notifier.state.categoryId, 'home');
      expect(notifier.state.subcategoryId, 'plumber');
    });

    test('clearFilters keeps mode and clears selections', () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = FeedFilterNotifier(FeedFilterPrefsRepository());
      notifier.setMode(FeedMode.yordamKerak);
      notifier.setCategory('marketing', label: 'Marketing');
      notifier.clearFilters();

      expect(notifier.state.mode, FeedMode.yordamKerak);
      expect(notifier.state.categoryId, isNull);
      expect(notifier.state.subcategoryId, isNull);
      expect(notifier.state.providerType, isNull);
    });
  });
}
