import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// Where a deal stands, as its bond shows it.
enum YbBondState {
  /// Talking terms: a dashed apricot line.
  negotiating,

  /// Both agreed: the line turns solid teal and a knot ties in the middle.
  agreed,

  /// Done: a green ring closes round the knot and stars rise from it.
  done,

  /// Cancelled or declined: a quiet dashed line.
  closed,
}

/// The deal's signature (design direction AN-04): the two people as
/// avatars and the line between them. Negotiating is a dashed apricot line;
/// agreeing pulls it solid teal and the knot pops with a success haptic;
/// finishing closes a green ring round the knot and lets three stars rise.
/// Changes animate only while the screen is open; with reduced motion the
/// bond just shows its state.
class YbDealBond extends StatefulWidget {
  const YbDealBond({
    super.key,
    required this.state,
    required this.myLabel,
    required this.otherInitial,
    this.onCelebrationDone,
  });

  final YbBondState state;

  /// Shown in the person's own avatar: "Siz".
  final String myLabel;

  /// The other person's initial.
  final String otherInitial;

  /// Called once the "done" ring and stars finish, so the review can follow.
  final VoidCallback? onCelebrationDone;

  @override
  State<YbDealBond> createState() => _YbDealBondState();
}

class _BondLook {
  const _BondLook({
    required this.solid,
    required this.knot,
    required this.ring,
  });

  final double solid;
  final double knot;
  final double ring;

  static _BondLook of(YbBondState state) => switch (state) {
        YbBondState.negotiating => const _BondLook(solid: 0, knot: 0, ring: 0),
        YbBondState.agreed => const _BondLook(solid: 1, knot: 1, ring: 0),
        YbBondState.done => const _BondLook(solid: 1, knot: 1, ring: 1),
        YbBondState.closed => const _BondLook(solid: 0, knot: 0, ring: 0),
      };
}

class _YbDealBondState extends State<YbDealBond>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
    value: 1,
  )..addListener(_onTick);

  YbBondState? _from;
  bool _hapticFired = true;

  @override
  void didUpdateWidget(YbDealBond oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state == widget.state) return;
    final celebrates = widget.state == YbBondState.agreed ||
        widget.state == YbBondState.done;
    if (AppMotion.reduced(context)) {
      _from = null;
      _controller.value = 1;
      if (celebrates) AppHaptics.success();
      if (widget.state == YbBondState.done) {
        // Not during this build: the callback may rebuild the screen.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) widget.onCelebrationDone?.call();
        });
      }
      return;
    }
    _from = oldWidget.state;
    _hapticFired = !celebrates;
    _controller.forward(from: 0).then((_) {
      if (mounted && widget.state == YbBondState.done) {
        widget.onCelebrationDone?.call();
      }
    });
  }

  /// The success haptic lands on the peak of the knot's pop, or as the ring
  /// closes (manual HC-01).
  void _onTick() {
    if (_hapticFired) return;
    final peak = widget.state == YbBondState.done ? 0.45 : 0.3;
    if (_controller.value >= peak) {
      _hapticFired = true;
      AppHaptics.success();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _lineColor(YbThemeColors colors, YbBondState state) => switch (state) {
        YbBondState.negotiating => colors.apricot,
        YbBondState.agreed => colors.teal,
        YbBondState.done => colors.success,
        YbBondState.closed => colors.outline,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return ExcludeSemantics(
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            _Avatar(
              label: widget.myLabel,
              background: colors.tealSoft,
              foreground: colors.tealInk,
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  final to = _BondLook.of(widget.state);
                  final from = _from == null ? to : _BondLook.of(_from!);
                  // Line first (0–30%), then the knot or the ring.
                  final lineT = Curves.easeInOut.transform(
                    (t / 0.3).clamp(0.0, 1.0),
                  );
                  final popT = ((t - 0.2) / 0.4).clamp(0.0, 1.0);
                  final ringT = Curves.easeInOutCubic.transform(
                    ((t - 0.2) / 0.45).clamp(0.0, 1.0),
                  );
                  final starsT = ((t - 0.55) / 0.45).clamp(0.0, 1.0);
                  final knotTarget = to.knot;
                  final knotFrom = from.knot;
                  final knot = knotFrom == knotTarget
                      ? knotTarget
                      : _pop(popT, knotFrom, knotTarget);
                  return CustomPaint(
                    painter: _BondPainter(
                      color: Color.lerp(
                        _lineColor(colors, _from ?? widget.state),
                        _lineColor(colors, widget.state),
                        lineT,
                      )!,
                      knotColor: _lineColor(colors, widget.state),
                      ringColor: colors.success,
                      holeColor: colors.card,
                      starColor: colors.star,
                      solid: _lerp(from.solid, to.solid, lineT),
                      knot: knot,
                      ring: from.ring == to.ring
                          ? to.ring
                          : _lerp(from.ring, to.ring, ringT),
                      stars: _from != null && widget.state == YbBondState.done
                          ? starsT
                          : 0,
                      faded: widget.state == YbBondState.closed,
                    ),
                  );
                },
              ),
            ),
            _Avatar(
              label: widget.otherInitial,
              background: colors.apricotSoft,
              foreground: colors.apricotInk,
            ),
          ],
        ),
      ),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// Grows past full size and settles: the knot "pops".
  static double _pop(double t, double from, double to) {
    if (to < from) return _lerp(from, to, t);
    if (t < 0.6) return Curves.easeOut.transform(t / 0.6) * 1.25;
    return 1.25 - 0.25 * Curves.easeInOut.transform((t - 0.6) / 0.4);
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        // Like CircleAvatar: the initial stays inside its circle at any
        // text size. The turn line under the bond says the same in words.
        child: Center(
          child: MediaQuery.withNoTextScaling(
            child: Text(
              label,
              maxLines: 1,
              style: AppTypography.label.copyWith(
                color: foreground,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BondPainter extends CustomPainter {
  _BondPainter({
    required this.color,
    required this.knotColor,
    required this.ringColor,
    required this.holeColor,
    required this.starColor,
    required this.solid,
    required this.knot,
    required this.ring,
    required this.stars,
    required this.faded,
  });

  final Color color;
  final Color knotColor;
  final Color ringColor;
  final Color holeColor;
  final Color starColor;

  /// 0 dashed, 1 solid.
  final double solid;

  /// Scale of the knot, 0 to about 1.25.
  final double knot;

  /// Sweep of the ring, 0 to 1.
  final double ring;

  /// Progress of the rising stars, 0 to 1.
  final double stars;
  final bool faded;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    const inset = 6.0;
    final line = Paint()
      ..color = faded ? color.withValues(alpha: 0.5) : color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Dashes close up as the deal is agreed.
    const dash = 7.0;
    final gap = 7.0 * (1 - solid);
    if (gap < 0.5) {
      canvas.drawLine(Offset(inset, y), Offset(size.width - inset, y), line);
    } else {
      var x = inset;
      while (x < size.width - inset) {
        final end = math.min(x + dash, size.width - inset);
        canvas.drawLine(Offset(x, y), Offset(end, y), line);
        x = end + gap;
      }
    }

    final center = Offset(size.width / 2, y);
    if (ring > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: 15),
        -math.pi / 2,
        2 * math.pi * ring,
        false,
        Paint()
          ..color = ringColor
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
    }
    if (knot > 0) {
      canvas.drawCircle(center, 9 * knot, Paint()..color = holeColor);
      canvas.drawCircle(center, 7 * knot, Paint()..color = knotColor);
    }
    if (stars > 0 && stars < 1) {
      final glyph = String.fromCharCode(YbIcons.starFilled.codePoint);
      for (var i = 0; i < 3; i++) {
        final t = (stars - i * 0.12).clamp(0.0, 1.0);
        if (t <= 0) continue;
        final dx = (i - 1) * 14.0;
        final rise = 26 * Curves.easeOut.transform(t);
        final opacity = (1 - t).clamp(0.0, 1.0);
        final painter = TextPainter(
          text: TextSpan(
            text: glyph,
            style: TextStyle(
              fontFamily: YbIcons.starFilled.fontFamily,
              fontSize: 12 + 2.0 * (1 - (i - 1).abs()),
              color: starColor.withValues(alpha: opacity),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        painter.paint(
          canvas,
          center +
              Offset(dx - painter.width / 2, -rise - 12 - painter.height / 2),
        );
        painter.dispose();
      }
    }
  }

  @override
  bool shouldRepaint(_BondPainter old) =>
      old.color != color ||
      old.solid != solid ||
      old.knot != knot ||
      old.ring != ring ||
      old.stars != stars ||
      old.faded != faded ||
      old.knotColor != knotColor ||
      old.ringColor != ringColor ||
      old.holeColor != holeColor ||
      old.starColor != starColor;
}
