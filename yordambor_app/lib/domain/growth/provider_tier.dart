enum ProviderTier {
  newProvider,
  active,
  trusted,
  top,
}

class ProviderStats {
  const ProviderStats({
    required this.completedJobs,
    required this.averageRating,
    required this.reviewCount,
    required this.tier,
    this.nextTier,
    this.jobsUntilNextTier,
  });

  final int completedJobs;
  final double averageRating;
  final int reviewCount;
  final ProviderTier tier;
  final ProviderTier? nextTier;
  final int? jobsUntilNextTier;

  bool get hasRating => reviewCount > 0;
}

ProviderTier computeProviderTier({
  required int completedJobs,
  required double averageRating,
  required int reviewCount,
}) {
  if (completedJobs >= 20 &&
      reviewCount > 0 &&
      averageRating >= 4.5) {
    return ProviderTier.top;
  }
  if (completedJobs >= 5 && reviewCount > 0 && averageRating >= 4.0) {
    return ProviderTier.trusted;
  }
  if (completedJobs >= 1) {
    return ProviderTier.active;
  }
  return ProviderTier.newProvider;
}

ProviderTier? nextTierFor(ProviderTier tier) => switch (tier) {
      ProviderTier.newProvider => ProviderTier.active,
      ProviderTier.active => ProviderTier.trusted,
      ProviderTier.trusted => ProviderTier.top,
      ProviderTier.top => null,
    };

int? jobsUntilNextTier({
  required ProviderTier tier,
  required int completedJobs,
  required double averageRating,
  required int reviewCount,
}) {
  return switch (tier) {
    ProviderTier.newProvider => 1 - completedJobs,
    ProviderTier.active => (5 - completedJobs).clamp(1, 5),
    ProviderTier.trusted => () {
        final jobsNeeded = 20 - completedJobs;
        if (jobsNeeded > 0) return jobsNeeded;
        if (reviewCount == 0 || averageRating < 4.5) return 1;
        return null;
      }(),
    ProviderTier.top => null,
  };
}

ProviderStats buildProviderStats({
  required int completedJobs,
  required double averageRating,
  required int reviewCount,
}) {
  final tier = computeProviderTier(
    completedJobs: completedJobs,
    averageRating: averageRating,
    reviewCount: reviewCount,
  );
  final next = nextTierFor(tier);
  return ProviderStats(
    completedJobs: completedJobs,
    averageRating: averageRating,
    reviewCount: reviewCount,
    tier: tier,
    nextTier: next,
    jobsUntilNextTier: jobsUntilNextTier(
      tier: tier,
      completedJobs: completedJobs,
      averageRating: averageRating,
      reviewCount: reviewCount,
    ),
  );
}
