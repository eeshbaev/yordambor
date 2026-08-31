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
  });

  final DateTime? lastPromptAt;
  final DateTime? snoozeUntil;
  final int completedKelishuvCount;
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

  final triggerOk = switch (trigger) {
    AppReviewTrigger.completedDeal => prefs.completedKelishuvCount >= 3,
    AppReviewTrigger.fiveStarReview => true,
    AppReviewTrigger.repeatBooking => true,
  };

  return AppReviewEligibility(
    canPrompt: triggerOk,
    reason: triggerOk ? 'eligible' : 'need_more_deals',
  );
}
