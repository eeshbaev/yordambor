enum AppReviewTrigger {
  completedDeal,
  fiveStarReview,
  repeatBooking,
}

class AppReviewPrefs {
  const AppReviewPrefs({
    this.lastPromptAt,
    this.snoozeUntil,
    this.completedKelishuvCount = 0,
    this.firstOpenAt,
  });

  final DateTime? lastPromptAt;
  final DateTime? snoozeUntil;
  final int completedKelishuvCount;

  /// The first launch on this phone, when known.
  final DateTime? firstOpenAt;
}

class AppReviewEligibility {
  const AppReviewEligibility({
    required this.canPrompt,
    required this.reason,
  });

  final bool canPrompt;
  final String reason;
}

AppReviewEligibility checkAppReviewEligibility({
  required AppReviewPrefs prefs,
  required AppReviewTrigger trigger,
  required DateTime now,
}) {
  if (prefs.snoozeUntil != null && now.isBefore(prefs.snoozeUntil!)) {
    return const AppReviewEligibility(
      canPrompt: false,
      reason: 'snoozed',
    );
  }

  if (prefs.lastPromptAt != null &&
      now.difference(prefs.lastPromptAt!).inDays < 90) {
    return const AppReviewEligibility(
      canPrompt: false,
      reason: 'recent_prompt',
    );
  }

  // Manual FB-05: at least 7 days and 3 finished deals after install.
  if (prefs.firstOpenAt != null &&
      now.difference(prefs.firstOpenAt!).inDays < 7) {
    return const AppReviewEligibility(
      canPrompt: false,
      reason: 'too_soon',
    );
  }

  // Every trigger is already a good moment; three finished deals make it a
  // habit rather than a fluke.
  final triggerOk = prefs.completedKelishuvCount >= 3;

  return AppReviewEligibility(
    canPrompt: triggerOk,
    reason: triggerOk ? 'eligible' : 'need_more_deals',
  );
}
