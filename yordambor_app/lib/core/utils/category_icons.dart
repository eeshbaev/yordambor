import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// Maps service categories to Material icons for placeholders when no photo exists.
abstract final class CategoryIcons {
  static const defaultIcon = YbIcons.designServices;

  /// A calm frame colour per category: a photo fades in from a tint of its
  /// own kind, never from grey (manual PR-14). Light and dark variants.
  static ({Color fill, Color ink}) tint(
    BuildContext context,
    String? categoryId,
  ) {
    final hue = _hues[categoryId] ?? _brandHue;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return (
      fill: HSLColor.fromAHSL(1, hue, dark ? 0.16 : 0.34, dark ? 0.19 : 0.93)
          .toColor(),
      ink: HSLColor.fromAHSL(1, hue, dark ? 0.26 : 0.30, dark ? 0.62 : 0.52)
          .toColor(),
    );
  }

  static const double _brandHue = 184;

  /// Hues spread round the wheel, so neighbouring cards rarely match.
  static const _hues = <String, double>{
    'home_repair': 32,
    'cleaning': 165,
    'education': 210,
    'tech': 232,
    'transport': 198,
    'beauty': 338,
    'health': 176,
    'auto': 16,
    'family': 46,
    'food_culinary': 24,
    'marketing_growth': 282,
    'creative_digital': 304,
    'fashion_tailoring': 322,
    'consultancy': 218,
    'personal_services': 190,
    'arts_performers': 266,
    'legal': 40,
    'real_estate': 92,
    'veterinary': 62,
    'sports_fitness': 8,
    'remote_freelance': 246,
  };

  static IconData forService({
    String? categoryId,
    String? subcategoryId,
  }) {
    final subIcon = _subcategoryIcons[subcategoryId];
    if (subIcon != null) return subIcon;

    final categoryIcon = _categoryIcons[categoryId];
    if (categoryIcon != null) return categoryIcon;

    return defaultIcon;
  }

  static const _categoryIcons = <String, IconData>{
    'home_repair': YbIcons.handyman,
    'cleaning': YbIcons.cleaningServices,
    'education': YbIcons.school,
    'tech': YbIcons.computer,
    'transport': YbIcons.localShipping,
    'beauty': YbIcons.spa,
    'health': YbIcons.medicalServices,
    'auto': YbIcons.carRepair,
    'family': YbIcons.familyRestroom,
    'food_culinary': YbIcons.restaurant,
    'marketing_growth': YbIcons.campaign,
    'creative_digital': YbIcons.brush,
    'fashion_tailoring': YbIcons.checkroom,
    'consultancy': YbIcons.businessCenter,
    'personal_services': YbIcons.supportAgent,
    'arts_performers': YbIcons.theaterComedy,
    'legal': YbIcons.gavel,
    'real_estate': YbIcons.homeWork,
    'veterinary': YbIcons.pets,
    'sports_fitness': YbIcons.fitnessCenter,
    'remote_freelance': YbIcons.laptopMac,
  };

  /// Finer icons for well-known subcategories inside broad categories.
  static const _subcategoryIcons = <String, IconData>{
    'web_studio': YbIcons.code,
    'freelance_developer': YbIcons.code,
    'freelance_designer': YbIcons.designServices,
    'english_tutor': YbIcons.translate,
    'math_tutor': YbIcons.calculate,
    'plumber': YbIcons.plumbing,
    'electrician': YbIcons.electricalServices,
    'fitness_club': YbIcons.fitnessCenter,
    'personal_trainer': YbIcons.sportsMartialArts,
    'swimming_pool': YbIcons.pool,
    'restaurant': YbIcons.restaurantMenu,
    'catering': YbIcons.lunchDining,
    'blogger': YbIcons.videocam,
    'advertising_agency': YbIcons.campaign,
    'production_house': YbIcons.movieCreation,
    'dental_clinic': YbIcons.medication,
    'home_nurse': YbIcons.healthAndSafety,
  };
}
