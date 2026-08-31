class AchievementDefinition {
  const AchievementDefinition({
    required this.id,
    required this.iconName,
  });

  final String id;
  final String iconName;
}

class AchievementUnlock {
  const AchievementUnlock({
    required this.id,
    required this.unlockedAt,
  });

  final String id;
  final DateTime unlockedAt;
}

class AchievementContext {
  const AchievementContext({
    required this.xizmatCount,
    required this.completedJobs,
    required this.hasCertificate,
    required this.hasFiveStarReview,
    required this.maxRepeatClients,
    required this.unansweredReviewCount,
    required this.xizmatWithoutAvailability,
    required this.xizmatWithoutPricing,
    required this.minPortfolioPhotos,
  });

  final int xizmatCount;
  final int completedJobs;
  final bool hasCertificate;
  final bool hasFiveStarReview;
  final int maxRepeatClients;
  final int unansweredReviewCount;
  final int xizmatWithoutAvailability;
  final int xizmatWithoutPricing;
  final int minPortfolioPhotos;
}

abstract final class AchievementCatalog {
  static const firstXizmat = AchievementDefinition(
    id: 'first_xizmat',
    iconName: 'handyman',
  );
  static const firstDeal = AchievementDefinition(
    id: 'first_deal',
    iconName: 'handshake',
  );
  static const jobs5 = AchievementDefinition(id: 'jobs_5', iconName: 'star');
  static const jobs10 = AchievementDefinition(id: 'jobs_10', iconName: 'stars');
  static const jobs25 = AchievementDefinition(id: 'jobs_25', iconName: 'emoji_events');
  static const firstFiveStar = AchievementDefinition(
    id: 'first_five_star',
    iconName: 'grade',
  );
  static const certificateAdded = AchievementDefinition(
    id: 'certificate_added',
    iconName: 'workspace_premium',
  );
  static const repeatClient3 = AchievementDefinition(
    id: 'repeat_client_3',
    iconName: 'favorite',
  );

  static const all = [
    firstXizmat,
    firstDeal,
    jobs5,
    jobs10,
    jobs25,
    firstFiveStar,
    certificateAdded,
    repeatClient3,
  ];
}

List<String> computeUnlockedAchievementIds(AchievementContext ctx) {
  final ids = <String>[];

  if (ctx.xizmatCount >= 1) ids.add(AchievementCatalog.firstXizmat.id);
  if (ctx.completedJobs >= 1) ids.add(AchievementCatalog.firstDeal.id);
  if (ctx.completedJobs >= 5) ids.add(AchievementCatalog.jobs5.id);
  if (ctx.completedJobs >= 10) ids.add(AchievementCatalog.jobs10.id);
  if (ctx.completedJobs >= 25) ids.add(AchievementCatalog.jobs25.id);
  if (ctx.hasFiveStarReview) ids.add(AchievementCatalog.firstFiveStar.id);
  if (ctx.hasCertificate) ids.add(AchievementCatalog.certificateAdded.id);
  if (ctx.maxRepeatClients >= 3) ids.add(AchievementCatalog.repeatClient3.id);

  return ids;
}

class ProgressTip {
  const ProgressTip({
    required this.id,
    required this.guideSlug,
  });

  final String id;
  final String? guideSlug;
}

List<ProgressTip> computeProgressTips(AchievementContext ctx) {
  final tips = <ProgressTip>[];

  if (!ctx.hasCertificate) {
    tips.add(const ProgressTip(
      id: 'add_certificate',
      guideSlug: 'certificates-trust',
    ));
  }
  if (ctx.xizmatWithoutAvailability > 0) {
    tips.add(const ProgressTip(id: 'set_availability', guideSlug: null));
  }
  if (ctx.unansweredReviewCount > 0) {
    tips.add(const ProgressTip(
      id: 'reply_reviews',
      guideSlug: 'review-replies',
    ));
  }
  if (ctx.minPortfolioPhotos < 2) {
    tips.add(const ProgressTip(
      id: 'add_portfolio',
      guideSlug: 'xizmat-that-converts',
    ));
  }
  if (ctx.xizmatWithoutPricing > 0) {
    tips.add(const ProgressTip(
      id: 'set_pricing',
      guideSlug: 'pricing-models',
    ));
  }
  if (ctx.completedJobs >= 1 && ctx.maxRepeatClients < 2) {
    tips.add(const ProgressTip(
      id: 'get_repeat_clients',
      guideSlug: 'repeat-clients',
    ));
  }

  return tips.take(5).toList();
}
