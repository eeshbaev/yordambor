import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:yordambor/core/design_system/app_motion.dart';

/// Rows of a freshly shown list rise into place one after another
/// (manual 8A): each fades up 10 pt over 250 ms, 35 ms after the row above,
/// for the first eight rows only. Rows built later by scrolling appear as
/// they are, and nothing moves with reduced motion or under the launch
/// hand-off.
class YbStaggerIn extends StatefulWidget {
  const YbStaggerIn({
    super.key,
    required this.index,
    required this.listShownAt,
    required this.child,
  });

  /// Position in the list.
  final int index;

  /// When the list's current content first appeared.
  final DateTime listShownAt;
  final Widget child;

  static const _maxRows = 8;
  static const _stagger = 35;
  static const _rise = 250;

  /// Rows built this long after the list appeared are not animated.
  static const _freshFor = Duration(milliseconds: 400);

  @override
  State<YbStaggerIn> createState() => _YbStaggerInState();
}

class _YbStaggerInState extends State<YbStaggerIn>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _progress;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    final fresh =
        DateTime.now().difference(widget.listShownAt) < YbStaggerIn._freshFor;
    if (!fresh || widget.index >= YbStaggerIn._maxRows) return;

    final delay = YbStaggerIn._stagger * widget.index;
    final total = delay + YbStaggerIn._rise;
    final controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: total),
    );
    _controller = controller;
    _progress = CurvedAnimation(
      parent: controller,
      curve: Interval(delay / total, 1, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = _controller;
    if (controller == null || _started) return;
    _started = true;
    if (AppMotion.reduced(context)) {
      controller.value = 1;
    } else if (LaunchHandoff.active.value) {
      LaunchHandoff.active.addListener(_onHandoffChanged);
    } else {
      controller.forward();
    }
  }

  void _onHandoffChanged() {
    if (LaunchHandoff.active.value) return;
    LaunchHandoff.active.removeListener(_onHandoffChanged);
    if (mounted) _controller?.forward();
  }

  @override
  void dispose() {
    LaunchHandoff.active.removeListener(_onHandoffChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    if (progress == null) return widget.child;
    return FadeTransition(
      opacity: progress,
      child: AnimatedBuilder(
        animation: progress,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, 10 * (1 - math.min(progress.value, 1))),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
