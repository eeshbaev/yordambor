import 'dart:math' as math;

import 'package:flutter/gestures.dart' show kTouchSlop;
import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

enum YordamBorLogoVariant {
  /// Light surfaces — soft card shadow.
  standard,

  /// Teal splash — subtle light halo so the mark lifts off the background.
  onPrimary,
}

const _logoAssetPath =
    'assets/logo/yordambor-logo-v6-angled-perspective.png';

/// Compact logo for app bars and inline brand rows. It shakes hands once
/// per launch, and again when tapped.
class YordamBorLogoMark extends StatelessWidget {
  const YordamBorLogoMark({super.key, this.size = 32, this.shake = true});

  final double size;

  /// Off where the mark must hold still (the launch screen, a business
  /// card).
  final bool shake;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.22);
    final mark = ClipRRect(
      borderRadius: radius,
      child: Image.asset(
        _logoAssetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );

    if (!shake) return mark;
    return YbHandshakeShake(oncePerLaunch: true, child: mark);
  }
}

/// Moves its child like a handshake: three quick pumps up and down with a
/// slight tilt, settling to rest. Plays when it appears (after [delay]) and
/// again when tapped; holds still when motion is reduced.
class YbHandshakeShake extends StatefulWidget {
  const YbHandshakeShake({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 450),
    this.oncePerLaunch = false,
  });

  final Widget child;
  final Duration delay;

  /// Plays on its own only the first time in this launch (the app bar mark
  /// is built again and again); a tap still plays it.
  final bool oncePerLaunch;

  static bool _playedThisLaunch = false;

  @override
  State<YbHandshakeShake> createState() => _YbHandshakeShakeState();
}

class _YbHandshakeShakeState extends State<YbHandshakeShake>
    with SingleTickerProviderStateMixin {
  static const _shake = Duration(milliseconds: 900);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.delay + _shake,
  );
  bool _started = false;

  /// Where a finger went down, to tell a tap from a scroll. A listener
  /// rather than a gesture detector, so the mark never takes a tap from
  /// whatever it sits in.
  Offset? _downAt;

  /// Where the shake itself begins, as a share of the whole run.
  double get _lead =>
      widget.delay.inMilliseconds / _controller.duration!.inMilliseconds;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduced(context)) return;
    if (widget.oncePerLaunch) {
      if (YbHandshakeShake._playedThisLaunch) return;
      YbHandshakeShake._playedThisLaunch = true;
    }
    // The wait is part of the run, so nothing is left pending.
    _controller.forward(from: 0);
  }

  void _play() {
    if (AppMotion.reduced(context)) return;
    _controller.forward(from: _lead);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => _downAt = event.position,
      onPointerCancel: (_) => _downAt = null,
      onPointerUp: (event) {
        final down = _downAt;
        _downAt = null;
        if (down != null && (event.position - down).distance < kTouchSlop) {
          _play();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          final lead = _lead;
          final raw = _controller.value;
          if (raw <= lead || raw >= 1) return child!;
          // 0..1 through the shake, three pumps fading out.
          final t = (raw - lead) / (1 - lead);
          final fade = 1 - Curves.easeOut.transform(t);
          final wave = math.sin(t * math.pi * 6);
          return Transform.rotate(
            angle: wave * 0.07 * fade,
            child: FractionalTranslation(
              translation: Offset(0, -wave * 0.07 * fade),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// App name with logo: Yordam (dark) + Bor (brand teal).
class YbAppBrandTitle extends StatelessWidget {
  const YbAppBrandTitle({
    super.key,
    this.style,
    this.logoSize = 32,
    this.subtitle,
  });

  final TextStyle? style;
  final double logoSize;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final textStyle =
        style ?? AppTypography.title.copyWith(color: colors.textPrimary);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: subtitle != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        YordamBorLogoMark(size: logoSize),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Yordam',
                  style: textStyle,
                  children: [
                    TextSpan(
                      text: 'Bor',
                      style: textStyle.copyWith(color: context.ybColors.tealBrand),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                subtitle!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class YordamBorLogo extends StatelessWidget {
  const YordamBorLogo({
    super.key,
    this.size = 120,
    this.variant = YordamBorLogoVariant.standard,
  });

  final double size;
  final YordamBorLogoVariant variant;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.22);

    final image = ClipRRect(
      borderRadius: radius,
      child: Image.asset(
        _logoAssetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );

    final shadows = switch (variant) {
      YordamBorLogoVariant.onPrimary => [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.28),
          blurRadius: size * 0.28,
          spreadRadius: size * 0.02,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: size * 0.12,
          offset: Offset(0, size * 0.04),
        ),
      ],
      YordamBorLogoVariant.standard => AppElevation.card(context),
    };

    return YbHandshakeShake(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: shadows,
        ),
        child: image,
      ),
    );
  }
}
