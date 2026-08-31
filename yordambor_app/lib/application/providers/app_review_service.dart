import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/data/growth/growth_prefs_stores.dart';
import 'package:yordambor/domain/growth/app_review_prompt.dart';
import 'package:yordambor/presentation/growth/milestone_celebration_sheet.dart';
import 'package:yordambor/presentation/support/app_review_sheet.dart';
import 'package:yordambor/presentation/support/feedback_sheet.dart';

final inAppReviewProvider = Provider<InAppReview>((ref) => InAppReview.instance);

Future<void> recordKelishuvCompletedForReview(WidgetRef ref) async {
  await ref.read(appReviewPrefsStoreProvider).recordCompletedKelishuv();
}

Future<void> maybePromptAppReview(
  BuildContext context,
  WidgetRef ref, {
  required AppReviewTrigger trigger,
}) async {
  if (!context.mounted) return;

  final store = ref.read(appReviewPrefsStoreProvider);
  final prefs = await store.load();
  final eligibility = checkAppReviewEligibility(
    prefs: prefs,
    trigger: trigger,
    now: DateTime.now(),
  );

  if (!eligibility.canPrompt || !context.mounted) return;

  final result = await showAppReviewSheet(context, ref.read(appStringsProvider));
  if (!context.mounted || result == null) return;

  final now = DateTime.now();
  switch (result) {
    case AppReviewSheetResult.lovingIt:
      await store.recordPromptShown(now);
      final review = ref.read(inAppReviewProvider);
      if (await review.isAvailable()) {
        await review.requestReview();
      }
    case AppReviewSheetResult.notReally:
      await store.recordPromptShown(now);
      if (context.mounted) {
        await showFeedbackSheet(context);
      }
    case AppReviewSheetResult.notNow:
      await store.snooze(now.add(const Duration(days: 60)));
  }
}

Future<void> showNewAchievementCelebrations(
  BuildContext context,
  WidgetRef ref,
  List<String> newlyUnlockedIds,
) async {
  if (newlyUnlockedIds.isEmpty || !context.mounted) return;

  final store = ref.read(achievementCelebrationStoreProvider);
  final celebrated = await store.loadCelebrated();
  final strings = ref.read(appStringsProvider);

  for (final id in newlyUnlockedIds) {
    if (celebrated.contains(id) || !context.mounted) continue;
    await showAchievementCelebrationSheet(
      context,
      achievementId: id,
      strings: strings,
    );
    await store.markCelebrated(id);
  }
}

Future<void> showPendingAchievementCelebrations(
  BuildContext context,
  WidgetRef ref,
  List<String> unlockedIds,
) async {
  if (!context.mounted || unlockedIds.isEmpty) return;

  final celebrated =
      await ref.read(achievementCelebrationStoreProvider).loadCelebrated();
  final pending =
      unlockedIds.where((id) => !celebrated.contains(id)).toList();
  if (!context.mounted) return;

  await showNewAchievementCelebrations(context, ref, pending);
}
