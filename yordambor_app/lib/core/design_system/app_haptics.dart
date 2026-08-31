import 'package:flutter/services.dart';

/// Intentional haptics — success and confirmation only, not every tap.
abstract final class AppHaptics {
  static void selection() => HapticFeedback.selectionClick();

  static void light() => HapticFeedback.lightImpact();

  static void medium() => HapticFeedback.mediumImpact();

  static void success() => HapticFeedback.mediumImpact();

  static void toggle(bool enabled) {
    if (enabled) {
      light();
    } else {
      selection();
    }
  }

  static void favorite(bool added) {
    if (added) {
      light();
    } else {
      selection();
    }
  }
}
