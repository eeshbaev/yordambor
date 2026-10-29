import 'package:flutter/widgets.dart';
import 'package:yordambor/core/design_system/app_motion.dart';

/// Gives its child a small bounce when it appears: a selected tab icon fills
/// and settles (manual 8A). Still when motion is reduced or [enabled] is
/// false.
class YbBounceIn extends StatefulWidget {
  const YbBounceIn({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<YbBounceIn> createState() => _YbBounceInState();
}

class _YbBounceInState extends State<YbBounceIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.emphasised,
    value: 1,
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.12), weight: 45),
    TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 55),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (widget.enabled && !AppMotion.reduced(context)) {
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
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
