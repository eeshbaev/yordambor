import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/domain/growth/achievement.dart';
import 'package:yordambor/domain/growth/app_review_prompt.dart';
import 'package:yordambor/domain/growth/provider_tier.dart';

void main() {
  group('computeProviderTier', () {
    test('new provider with no jobs', () {
      expect(
        computeProviderTier(
          completedJobs: 0,
          averageRating: 0,
          reviewCount: 0,
        ),
        ProviderTier.newProvider,
      );
    });

    test('active after first job', () {
      expect(
        computeProviderTier(
          completedJobs: 1,
          averageRating: 0,
          reviewCount: 0,
        ),
        ProviderTier.active,
      );
    });

    test('trusted at 5 jobs with 4+ rating', () {
      expect(
        computeProviderTier(
          completedJobs: 5,
          averageRating: 4.2,
          reviewCount: 3,
        ),
        ProviderTier.trusted,
      );
    });

    test('top at 20 jobs with 4.5+ rating', () {
      expect(
        computeProviderTier(
          completedJobs: 20,
          averageRating: 4.6,
          reviewCount: 10,
        ),
        ProviderTier.top,
      );
    });
  });

  group('computeUnlockedAchievementIds', () {
    test('unlocks first xizmat and first deal', () {
      const ctx = AchievementContext(
        xizmatCount: 1,
        completedJobs: 1,
        hasCertificate: false,
        hasFiveStarReview: false,
        maxRepeatClients: 0,
        unansweredReviewCount: 0,
        xizmatWithoutAvailability: 0,
        xizmatWithoutPricing: 0,
        minPortfolioPhotos: 0,
      );
      final ids = computeUnlockedAchievementIds(ctx);
      expect(ids, contains('first_xizmat'));
      expect(ids, contains('first_deal'));
    });
  });

  group('checkAppReviewEligibility', () {
    test('snoozed blocks prompt', () {
      final result = checkAppReviewEligibility(
        prefs: AppReviewPrefs(
          snoozeUntil: DateTime.now().add(const Duration(days: 30)),
        ),
        trigger: AppReviewTrigger.fiveStarReview,
        now: DateTime.now(),
      );
      expect(result.canPrompt, isFalse);
      expect(result.reason, 'snoozed');
    });

    test('needs 3 deals for completedDeal trigger', () {
      final result = checkAppReviewEligibility(
        prefs: const AppReviewPrefs(completedKelishuvCount: 2),
        trigger: AppReviewTrigger.completedDeal,
        now: DateTime.now(),
      );
      expect(result.canPrompt, isFalse);
    });

    test('allows after 3 deals', () {
      final result = checkAppReviewEligibility(
        prefs: const AppReviewPrefs(completedKelishuvCount: 3),
        trigger: AppReviewTrigger.completedDeal,
        now: DateTime.now(),
      );
      expect(result.canPrompt, isTrue);
    });
  });
}
