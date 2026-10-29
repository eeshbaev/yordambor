import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:yordambor/core/design_system/app_motion.dart';

/// Shakes its child sideways when [trigger] changes: three swings of ±8 pt
/// that die away over 360 ms (manual S-03). Only the field that needs fixing
/// moves; with reduced motion nothing does, and the red border and the
/// message under the field still say what to fix.
class YbShake extends StatefulWidget {
  const YbShake({super.key, required this.trigger, required this.child});

  /// Change this (for example, count failed attempts) to shake once.
  final int trigger;
  final Widget child;

  @override
  State<YbShake> createState() => _YbShakeState();
}

class _YbShakeState extends State<YbShake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
  );

  @override
  void didUpdateWidget(YbShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger && !AppMotion.reduced(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final dx = 8 * math.sin(t * 3 * 2 * math.pi) * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: widget.child,
    );
  }
}
