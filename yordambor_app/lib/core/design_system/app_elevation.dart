import 'package:flutter/material.dart';

/// Soft, warm elevation tokens for cards, nav bars, and FABs.
abstract final class AppElevation {
  static List<BoxShadow> card(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark
        ? Colors.black.withValues(alpha: 0.35)
        : const Color(0xFF0F172A).withValues(alpha: 0.06);

    return [
      BoxShadow(
        color: color,
        blurRadius: isDark ? 16 : 20,
        offset: const Offset(0, 4),
        spreadRadius: isDark ? 0 : -2,
      ),
    ];
  }

  static List<BoxShadow> cardPressed(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark
        ? Colors.black.withValues(alpha: 0.25)
        : const Color(0xFF0F172A).withValues(alpha: 0.04);

    return [
      BoxShadow(
        color: color,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> navBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : const Color(0xFF0F172A).withValues(alpha: 0.08);

    return [
      BoxShadow(
        color: color,
        blurRadius: 24,
        offset: const Offset(0, -4),
        spreadRadius: -4,
      ),
    ];
  }

  static List<BoxShadow> fab(BuildContext context) {
    return [
      BoxShadow(
        color: const Color(0xFF0D9488).withValues(alpha: 0.35),
        blurRadius: 16,
        offset: const Offset(0, 6),
        spreadRadius: -2,
      ),
    ];
  }
}
