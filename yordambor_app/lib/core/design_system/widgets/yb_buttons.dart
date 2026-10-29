import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

/// Scales its child to [AppMotion.pressScale] while pressed, with the snap
/// spring. Stays still when the person has reduced motion on.
class YbScaleTap extends StatefulWidget {
  const YbScaleTap({
    super.key,
    required this.onTap,
    required this.child,
    this.enabled = true,
    this.haptic = false,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.excludeFromSemantics = false,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool enabled;
  final bool haptic;
  final HitTestBehavior hitTestBehavior;

  /// On when a [Semantics] around the card already carries its tap, so the
  /// screen reader finds one action, not two.
  final bool excludeFromSemantics;

  @override
  State<YbScaleTap> createState() => _YbScaleTapState();
}

class _YbScaleTapState extends State<YbScaleTap> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled || widget.onTap == null) return;
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _handleTap() {
    if (!widget.enabled || widget.onTap == null) return;
    if (widget.haptic) AppHaptics.select();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final still = AppMotion.reduced(context);
    final scale = _pressed && !still ? AppMotion.pressScale : 1.0;

    return GestureDetector(
      behavior: widget.hitTestBehavior,
      excludeFromSemantics: widget.excludeFromSemantics,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.enabled ? _handleTap : null,
      // Press in quickly, spring back on release.
      child: AnimatedScale(
        scale: scale,
        duration: _pressed ? AppMotion.instant : AppMotion.quick,
        curve: _pressed ? AppMotion.instantCurve : AppMotion.snap,
        child: widget.child,
      ),
    );
  }
}

/// Scales a button while a pointer is down, without joining the gesture
/// arena, so the button's own ink and semantics stay intact.
class _PressScale extends StatefulWidget {
  const _PressScale({required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  var _down = false;

  void _set(bool value) {
    if (!widget.enabled && value) return;
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final still = AppMotion.reduced(context);
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down && !still ? AppMotion.pressScale : 1.0,
        duration: _down ? AppMotion.instant : AppMotion.quick,
        curve: _down ? AppMotion.instantCurve : AppMotion.snap,
        child: widget.child,
      ),
    );
  }
}

/// Which voice a primary button speaks in.
enum YbButtonTone {
  /// Helping, agreeing, every "yes": teal.
  help,

  /// Asking for help: apricot with ink text.
  ask,

  /// A quieter confirm: teal-soft with teal ink.
  tonal,

  /// A quieter ask: apricot-soft with apricot ink.
  askTonal,

  /// Destructive: error-soft with error text.
  danger,
}

/// The one primary action of a screen: a 56 dp pill, full width.
///
/// Use [height] 48 inside sheets and 40 inside cards. With [expand] false
/// the pill hugs its label, for an inline action beside other content.
///
/// [isSuccess] morphs the pill into a circle that draws a checkmark, with a
/// success haptic as the check completes (manual V-02, HC-01); keep it on
/// for about half a second before leaving. A disabled button says what
/// unlocks it through [disabledHint] (manual S-07).
class YbPrimaryButton extends StatelessWidget {
  const YbPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isSuccess = false,
    this.icon,
    this.tone = YbButtonTone.help,
    this.height = AppTouch.buttonHeight,
    this.expand = true,
    this.disabledHint,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSuccess;
  final IconData? icon;
  final YbButtonTone tone;
  final double height;
  final bool expand;

  /// Shown under the button while it is disabled (not while loading).
  final String? disabledHint;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final (background, foreground) = switch (tone) {
      YbButtonTone.help => (colors.teal, colors.onTeal),
      YbButtonTone.ask => (colors.apricot, colors.onApricot),
      YbButtonTone.tonal => (colors.tealSoft, colors.tealInk),
      YbButtonTone.askTonal => (colors.apricotSoft, colors.apricotInk),
      YbButtonTone.danger => (colors.errorSoft, colors.error),
    };
    final busy = isLoading || isSuccess;
    final enabled = !busy && onPressed != null;
    final labelColor = enabled || busy ? foreground : colors.ink3;
    final hint = !enabled && !busy ? disabledHint : null;
    // Taller with large text, so the label never clips (manual T-02).
    final height = _scaledHeight(context, this.height);

    final pill = _PressScale(
      enabled: enabled,
      child: SizedBox(
        height: height,
        width: expand ? double.infinity : null,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            // While loading or done the button keeps its colour.
            disabledBackgroundColor: busy ? background : colors.surface2,
            disabledForegroundColor: busy ? foreground : colors.ink3,
            // Pressed darkens the fill a little rather than lightening it.
            overlayColor: Colors.black,
            padding: isSuccess
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: _padding(this.height)),
            minimumSize:
                expand ? Size.fromHeight(height) : Size(height, height),
            // Inline pills get a finite width so the label row can flex.
            maximumSize: Size(expand ? double.infinity : 280, height),
          ),
          onPressed: enabled
              ? () {
                  AppHaptics.tap();
                  onPressed!();
                }
              : null,
          // Loading keeps the label and the width; a spinner joins it.
          child: isSuccess
              ? _SuccessCheck(color: foreground, size: height * 0.45)
              : _ButtonLabel(
                  label: label,
                  icon: icon,
                  color: labelColor,
                  fontSize: _fontSize(this.height),
                  loading: isLoading,
                ),
        ),
      ),
    );

    // Full-width pills close into a circle when done (300 ms).
    final Widget button = expand
        ? TweenAnimationBuilder<double>(
            tween: Tween<double>(end: isSuccess ? 1.0 : 0.0),
            duration: AppMotion.of(context, const Duration(milliseconds: 300)),
            curve: AppMotion.standard,
            builder: (context, closed, child) => CustomSingleChildLayout(
              delegate: _MorphToCircle(closed: closed, height: height),
              child: child,
            ),
            child: pill,
          )
        : pill;

    if (hint == null) return button;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        button,
        const SizedBox(height: AppSpacing.xs + 2),
        Text(
          hint,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

/// Keeps the full width for the button's box while the pill inside narrows
/// to a circle, centred. Works without measuring, so the button can sit
/// anywhere, including inside intrinsic layouts.
class _MorphToCircle extends SingleChildLayoutDelegate {
  _MorphToCircle({required this.closed, required this.height});

  /// 0 is the full pill, 1 the circle.
  final double closed;
  final double height;

  double _full(BoxConstraints constraints) =>
      constraints.maxWidth.isFinite ? constraints.maxWidth : height;

  @override
  Size getSize(BoxConstraints constraints) =>
      constraints.constrain(Size(_full(constraints), height));

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final full = _full(constraints);
    final width = full + (height - full) * closed.clamp(0.0, 1.0);
    return BoxConstraints.tightFor(width: width, height: height);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      Offset((size.width - childSize.width) / 2, 0);

  @override
  bool shouldRelayout(_MorphToCircle oldDelegate) =>
      oldDelegate.closed != closed || oldDelegate.height != height;
}

/// A checkmark that draws itself in 250 ms after the pill has closed into a
/// circle; the success haptic lands as it completes.
class _SuccessCheck extends StatefulWidget {
  const _SuccessCheck({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_SuccessCheck> createState() => _SuccessCheckState();
}

class _SuccessCheckState extends State<_SuccessCheck>
    with SingleTickerProviderStateMixin {
  // 150 ms for the pill to close, then 250 ms of stroke.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<double> _stroke = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.375, 1, curve: Curves.easeOutCubic),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduced(context)) {
      _controller.value = 1;
      AppHaptics.success();
    } else {
      _controller.forward().then((_) => AppHaptics.success());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _stroke,
        builder: (context, _) => CustomPaint(
          painter: _CheckPainter(progress: _stroke.value, color: widget.color),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.76)
      ..lineTo(size.width * 0.84, size.height * 0.28);
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(_CheckPainter old) =>
      old.progress != progress || old.color != color;
}

/// A secondary action: a pill with an outline and ink text.
class YbSecondaryButton extends StatelessWidget {
  const YbSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = AppTouch.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final enabled = onPressed != null;
    final height = _scaledHeight(context, this.height);

    return _PressScale(
      enabled: enabled,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: _padding(this.height)),
            minimumSize: Size.fromHeight(height),
            maximumSize: Size(double.infinity, height),
          ),
          onPressed: onPressed,
          child: _ButtonLabel(
            label: label,
            icon: icon,
            color: enabled ? colors.ink : colors.ink3,
            fontSize: _fontSize(this.height),
          ),
        ),
      ),
    );
  }
}

/// The design height, or more when the person's text size needs it: one
/// line of label with room above and below.
double _scaledHeight(BuildContext context, double height) {
  final label = MediaQuery.textScalerOf(context).scale(_fontSize(height));
  return math.max(height, label * 1.25 + 24);
}

double _padding(double height) {
  if (height >= AppTouch.buttonHeight) return AppSpacing.xl;
  if (height >= AppTouch.buttonHeightMedium) return 20;
  return AppSpacing.lg;
}

double _fontSize(double height) {
  if (height >= AppTouch.buttonHeight) return 16;
  if (height >= AppTouch.buttonHeightMedium) return 15;
  return 14;
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({
    required this.label,
    required this.color,
    this.icon,
    this.fontSize = 16,
    this.loading = false,
  });

  final String label;
  final IconData? icon;
  final Color color;
  final double fontSize;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTypography.button.copyWith(
      color: color,
      fontSize: fontSize,
    );

    final text = Text(
      label,
      style: labelStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );

    final Widget? leading = loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: color),
          )
        : (icon == null
            ? null
            : Icon(icon, size: fontSize >= 16 ? 21 : 18, color: color));

    if (leading == null) return text;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        leading,
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: text),
      ],
    );
  }
}
