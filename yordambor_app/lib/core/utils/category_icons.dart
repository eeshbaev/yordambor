import 'package:flutter/material.dart';

/// Maps service categories to Material icons for placeholders when no photo exists.
abstract final class CategoryIcons {
  static const defaultIcon = Icons.design_services_outlined;

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
    'home_repair': Icons.handyman_outlined,
    'cleaning': Icons.cleaning_services_outlined,
    'education': Icons.school_outlined,
    'tech': Icons.computer_outlined,
    'transport': Icons.local_shipping_outlined,
    'beauty': Icons.spa_outlined,
    'health': Icons.medical_services_outlined,
    'auto': Icons.car_repair_outlined,
    'family': Icons.family_restroom_outlined,
    'food_culinary': Icons.restaurant_outlined,
    'marketing_growth': Icons.campaign_outlined,
    'creative_digital': Icons.brush_outlined,
    'fashion_tailoring': Icons.checkroom_outlined,
    'consultancy': Icons.business_center_outlined,
    'personal_services': Icons.support_agent_outlined,
    'arts_performers': Icons.theater_comedy_outlined,
    'legal': Icons.gavel_outlined,
    'real_estate': Icons.home_work_outlined,
    'veterinary': Icons.pets_outlined,
    'sports_fitness': Icons.fitness_center_outlined,
    'remote_freelance': Icons.laptop_mac_outlined,
  };

  /// Finer icons for well-known subcategories inside broad categories.
  static const _subcategoryIcons = <String, IconData>{
    'web_studio': Icons.code_outlined,
    'freelance_developer': Icons.code_outlined,
    'freelance_designer': Icons.design_services_outlined,
    'english_tutor': Icons.translate_outlined,
    'math_tutor': Icons.calculate_outlined,
    'plumber': Icons.plumbing_outlined,
    'electrician': Icons.electrical_services_outlined,
    'fitness_club': Icons.fitness_center_outlined,
    'personal_trainer': Icons.sports_martial_arts_outlined,
    'swimming_pool': Icons.pool_outlined,
    'restaurant': Icons.restaurant_menu_outlined,
    'catering': Icons.lunch_dining_outlined,
    'blogger': Icons.videocam_outlined,
    'advertising_agency': Icons.campaign_outlined,
    'production_house': Icons.movie_creation_outlined,
    'dental_clinic': Icons.medication_outlined,
    'home_nurse': Icons.health_and_safety_outlined,
  };
}
