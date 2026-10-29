import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Platform-aware haptics: one meaning per pattern, so people learn them
/// (manual Part 8 haptic map). Fire them at the animation's key frame, never
/// on scroll, screen open or tab switch, and never more than ~2 per second.
///
/// Android keeps only the clear system effects (tick, confirm, reject),
/// because cheap vibration motors turn impacts into a buzz. iOS also gets the
/// light and medium impacts and the warning.
///
/// | Event                                        | Call            |
/// | -------------------------------------------- | --------------- |
/// | Picker, segment, chip, star, code digit      | [select]        |
/// | Toggle on/off                                | [toggle]        |
/// | Primary button press, save a provider        | [tap]           |
/// | Long press opens a menu, delete, drag lift   | [commit]        |
/// | Saved, deal agreed, job done, code verified  | [success]       |
/// | Terms changed                                | [warning]       |
/// | Destructive action confirmed                 | [destructive]   |
/// | Failed send, invalid code                    | [error]         |
abstract final class AppHaptics {
  /// Settings → "Tebranish". When false, nothing vibrates.
  static bool enabled = true;

  static bool get _ios => defaultTargetPlatform == TargetPlatform.iOS;

  static void select() {
    if (enabled) HapticFeedback.selectionClick();
  }

  static void tap() {
    if (enabled && _ios) HapticFeedback.lightImpact();
  }

  static void commit() {
    if (enabled && _ios) HapticFeedback.mediumImpact();
  }

  static void success() {
    if (enabled) HapticFeedback.successNotification();
  }

  static void warning() {
    if (enabled && _ios) HapticFeedback.warningNotification();
  }

  static void error() {
    if (enabled) HapticFeedback.errorNotification();
  }

  static void destructive() {
    if (!enabled) return;
    if (_ios) {
      HapticFeedback.warningNotification();
    } else {
      HapticFeedback.errorNotification();
    }
  }

  // Older names, kept for existing call sites.
  static void selection() => select();

  static void light() => tap();

  static void medium() => commit();

  static void toggle(bool on) {
    if (!enabled) return;
    if (_ios) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }

  static void favorite(bool added) {
    if (added) {
      tap();
    } else {
      select();
    }
  }
}
