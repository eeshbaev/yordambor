import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:yordambor/data/growth/growth_prefs_stores.dart';
import 'package:yordambor/domain/growth/app_review_prompt.dart';

final inAppReviewProvider = Provider<InAppReview>((ref) => InAppReview.instance);

Future<void> recordKelishuvCompletedForReview(WidgetRef ref) async {
  await ref.read(appReviewPrefsStoreProvider).recordCompletedKelishuv();
}

/// Asks the store for a rating after a success (manual FB-05): the official
/// in-app review only, never behind a "Do you like the app?" question and
/// never from a "Rate us" button. The store decides whether it appears.
Future<void> maybePromptAppReview(
  BuildContext context,
  WidgetRef ref, {
  required AppReviewTrigger trigger,
}) async {
  if (!context.mounted) return;

  // Read before any await: a sheet that asks may already be closing.
  final store = ref.read(appReviewPrefsStoreProvider);
  final review = ref.read(inAppReviewProvider);
  final prefs = await store.load();
  final now = DateTime.now();
  final eligibility = checkAppReviewEligibility(
    prefs: prefs,
    trigger: trigger,
    now: now,
  );
  if (!eligibility.canPrompt) return;
  if (!await review.isAvailable()) return;
  await store.recordPromptShown(now);
  await review.requestReview();
}
