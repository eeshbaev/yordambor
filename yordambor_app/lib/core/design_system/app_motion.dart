import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Motion tokens (manual Part 8).
///
/// | Token      | Timing                         | Use                                  |
/// | ---------- | ------------------------------ | ------------------------------------ |
/// | instant    | 100 ms, ease-out               | Pressed state, toggle thumb          |
/// | quick      | 180 ms, ease-out               | Fades, colour changes, snackbar in   |
/// | standard   | 300 ms, spring (0.35 s, 0.8)   | Screen push, sheet, card expand      |
/// | emphasised | 440 ms, spring, slight overshoot | Shared element, celebration        |
/// | exit       | 70% of the enter duration      | Anything leaving the screen          |
///
/// Everything that moves runs on a spring so it can be interrupted. With
/// reduced motion on ([reduced]), movement becomes a cross-fade of at most
/// 200 ms and nothing loops.
abstract final class AppMotion {
  static const instant = Duration(milliseconds: 100);
  static const quick = Duration(milliseconds: 180);
  static const standardDuration = Duration(milliseconds: 300);
  static const emphasised = Duration(milliseconds: 440);

  /// Cross-fade used instead of movement when motion is reduced.
  static const reducedFade = Duration(milliseconds: 150);

  /// Exits are quicker than entrances: 70% of the enter duration.
  static Duration exit(Duration enter) => enter * 0.7;

  static const Curve instantCurve = Curves.easeOut;
  static const Curve quickCurve = Curves.easeOutCubic;

  /// The standard spring as a curve.
  static const Curve standard = YbSpringCurve.standard;

  /// Press release.
  static const Curve snap = YbSpringCurve.snap;

  /// Slight overshoot, for the few moments that celebrate.
  static const Curve spring = YbSpringCurve.emphasised;

  // Older names, kept for existing call sites.
  static const fast = quick;
  static const normal = standardDuration;
  static const slow = emphasised;
  static const celebrate = emphasised;
  static const Curve glide = YbSpringCurve.standard;

  /// Press scale for tappable cards and buttons.
  static const double pressScale = 0.96;

  /// True when the person turned on "Remove animations" (Android) or Reduce
  /// Motion (iOS).
  static bool reduced(BuildContext context) =>
      (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
      WidgetsBinding
          .instance.platformDispatcher.accessibilityFeatures.reduceMotion;

  /// [duration], or zero when motion is reduced.
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;

  /// Sheets rise in 320 ms on a spring that does not overshoot, and leave
  /// in 220 ms (manual M-03). A drag follows the finger and a flick keeps
  /// its speed; the sheet itself handles both.
  static const sheet = AnimationStyle(
    duration: Duration(milliseconds: 320),
    reverseDuration: Duration(milliseconds: 220),
    curve: YbSpringCurve(322, 1),
    reverseCurve: Curves.easeInCubic,
  );

  /// With reduced motion a sheet arrives in a short plain rise, no spring.
  static const reducedSheet = AnimationStyle(
    duration: reducedFade,
    reverseDuration: reducedFade,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  /// The sheet style for this context: [sheet], or [reducedSheet] when
  /// motion is reduced. Pass it as `sheetAnimationStyle`.
  static AnimationStyle sheetOf(BuildContext context) =>
      reduced(context) ? reducedSheet : sheet;
}

/// True while the launch mark zooms through into the first screen. Entrance
/// animations on that screen wait for it, so nothing moves under the
/// hand-off (manual WL-05).
abstract final class LaunchHandoff {
  static final active = ValueNotifier<bool>(false);
}

/// Spring descriptions (mass 1) for controllers driven by physics, so
/// release velocity carries into the motion:
/// `controller.animateWith(SpringSimulation(YbSpring.standard, from, to, v))`.
abstract final class YbSpring {
  /// Press release.
  static final snap =
      SpringDescription.withDampingRatio(mass: 1, stiffness: 1400, ratio: 0.9);

  /// Response 0.35 s, damping 0.8: screen push, sheet, card expand.
  static final standard =
      SpringDescription.withDampingRatio(mass: 1, stiffness: 322, ratio: 0.8);

  /// Response 0.45 s, damping 0.7: shared elements and celebrations.
  static final emphasised =
      SpringDescription.withDampingRatio(mass: 1, stiffness: 195, ratio: 0.7);
}

/// A spring as a [Curve], so implicit animations (AnimatedContainer,
/// AnimatedScale…) move with the same physics.
///
/// The curve spans the time the spring needs to come visibly to rest (within
/// 2%), and ends exactly on 1. Pair it with the matching duration above.
class YbSpringCurve extends Curve {
  const YbSpringCurve(this.stiffness, this.ratio);

  /// Stiffness for a mass of 1.
  final double stiffness;

  /// Damping ratio: 1 has no bounce, below 1 overshoots slightly.
  final double ratio;

  static const snap = YbSpringCurve(1400, 0.9);
  static const standard = YbSpringCurve(322, 0.8);
  static const emphasised = YbSpringCurve(195, 0.7);

  static const double _tolerance = 0.02;

  /// Seconds until the spring stays within 2% of its target.
  double get settleSeconds {
    final w0 = math.sqrt(stiffness);
    if (ratio >= 1) {
      // Critically damped: solve e^-x (1 + x) = tolerance.
      var x = 4.0;
      for (var i = 0; i < 12; i++) {
        final f = math.exp(-x) * (1 + x) - _tolerance;
        final df = -math.exp(-x) * x;
        x -= f / df;
      }
      return x / w0;
    }
    final envelope = 1 / math.sqrt(1 - ratio * ratio);
    return math.log(envelope / _tolerance) / (ratio * w0);
  }

  double _position(double seconds) {
    final w0 = math.sqrt(stiffness);
    if (ratio >= 1) {
      return 1 - math.exp(-w0 * seconds) * (1 + w0 * seconds);
    }
    final wd = w0 * math.sqrt(1 - ratio * ratio);
    final decay = math.exp(-ratio * w0 * seconds);
    return 1 -
        decay *
            (math.cos(wd * seconds) +
                (ratio * w0 / wd) * math.sin(wd * seconds));
  }

  @override
  double transformInternal(double t) {
    final total = settleSeconds;
    // Normalise so the curve ends exactly on 1.
    return _position(t * total) / _position(total);
  }
}
