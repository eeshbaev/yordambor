class GuideArticle {
  const GuideArticle({required this.slug, required this.icon});

  final String slug;
  final String icon;
}

abstract final class GuidesCatalog {
  static const articles = [
    GuideArticle(slug: 'xizmat-that-converts', icon: 'design'),
    GuideArticle(slug: 'pricing-models', icon: 'payments'),
    GuideArticle(slug: 'repeat-clients', icon: 'replay'),
    GuideArticle(slug: 'certificates-trust', icon: 'verified'),
    GuideArticle(slug: 'review-replies', icon: 'rate'),
  ];
}
