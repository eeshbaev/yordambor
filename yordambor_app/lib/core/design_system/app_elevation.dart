import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

/// Depth, used only to show what floats above what (manual C-07, C-09,
/// PR-06).
///
/// Light theme: two-layer shadows, a tight one for contact and a wide one
/// for ambience, at 4–12% ink. Dark theme: no shadows; lighter surfaces show
/// elevation instead.
///
/// 0 · flat: lists and settings, no shadow.
/// 1 · cards.
/// 2 · floating: the tab bar and the FAB.
/// 3 · sheets and dialogs.
abstract final class AppElevation {
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static List<BoxShadow> card(BuildContext context) {
    if (_isDark(context)) return const [];
    final shadow = context.ybColors.shadow;
    return [
      BoxShadow(
        color: shadow.withValues(alpha: 0.06),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
      BoxShadow(
        color: shadow.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: -6,
      ),
    ];
  }

  static List<BoxShadow> cardPressed(BuildContext context) {
    if (_isDark(context)) return const [];
    final shadow = context.ybColors.shadow;
    return [
      BoxShadow(
        color: shadow.withValues(alpha: 0.06),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
      BoxShadow(
        color: shadow.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
        spreadRadius: -4,
      ),
    ];
  }

  static List<BoxShadow> navBar(BuildContext context) {
    if (_isDark(context)) return const [];
    final shadow = context.ybColors.shadow;
    return [
      BoxShadow(
        color: shadow.withValues(alpha: 0.06),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
      BoxShadow(
        color: shadow.withValues(alpha: 0.12),
        blurRadius: 24,
        offset: const Offset(0, 8),
        spreadRadius: -6,
      ),
    ];
  }

  /// Floating action button. [tint] colours the ambient layer.
  static List<BoxShadow> fab(BuildContext context, {Color? tint}) {
    if (_isDark(context)) return const [];
    final shadow = context.ybColors.shadow;
    return [
      BoxShadow(
        color: shadow.withValues(alpha: 0.08),
        blurRadius: 3,
        offset: const Offset(0, 1),
      ),
      BoxShadow(
        color: (tint ?? shadow).withValues(alpha: 0.12),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: -4,
      ),
    ];
  }

  static List<BoxShadow> sheet(BuildContext context) {
    if (_isDark(context)) return const [];
    final shadow = context.ybColors.shadow;
    return [
      BoxShadow(
        color: shadow.withValues(alpha: 0.10),
        blurRadius: 24,
        offset: const Offset(0, -8),
        spreadRadius: -8,
      ),
    ];
  }
}
