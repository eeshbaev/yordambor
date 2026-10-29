import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_motion.dart';

/// The tab pages, stacked (manual 8A): a new tab fades in over the old one
/// and settles from a few pixels below, in 220 ms. Every page is opaque, so
/// the old one never shows through and nothing pops when the fade ends.
/// Hidden tabs keep their state but stop ticking, take no taps and keep
/// their heroes out of page transitions.
class ShellBranchContainer extends StatefulWidget {
  const ShellBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<ShellBranchContainer> createState() => _ShellBranchContainerState();
}

class _ShellBranchContainerState extends State<ShellBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    value: 1,
  )..addStatusListener(_onFadeStatus);

  late final CurvedAnimation _opacity = CurvedAnimation(
    parent: _fade,
    curve: Curves.easeOut,
  );

  late final CurvedAnimation _settle = CurvedAnimation(
    parent: _fade,
    curve: Curves.easeOutCubic,
  );

  /// The new page settles from about ten pixels below.
  late final Animation<Offset> _rise = Tween<Offset>(
    begin: const Offset(0, 0.012),
    end: Offset.zero,
  ).animate(_settle);

  /// The tab fading out under the new one, while the fade runs.
  int? _leaving;

  void _onFadeStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _leaving != null && mounted) {
      setState(() => _leaving = null);
    }
  }

  @override
  void didUpdateWidget(ShellBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex == widget.currentIndex) return;
    if (AppMotion.reduced(context)) {
      _leaving = null;
      _fade.value = 1;
      return;
    }
    _leaving = oldWidget.currentIndex;
    _fade.forward(from: 0);
  }

  @override
  void dispose() {
    _opacity.dispose();
    _settle.dispose();
    _fade.dispose();
    super.dispose();
  }

  /// A page that does not move.
  static const _still = AlwaysStoppedAnimation<Offset>(Offset.zero);

  @override
  Widget build(BuildContext context) {
    final current = widget.currentIndex;
    final leaving = _leaving;
    // Paint order: hidden tabs, the tab leaving, then the new one on top.
    final order = [
      for (var i = 0; i < widget.children.length; i++)
        if (i != current && i != leaving) i,
      if (leaving != null && leaving != current) leaving,
      current,
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        for (final index in order)
          KeyedSubtree(
            key: ValueKey<int>(index),
            child: _branch(index, current, leaving),
          ),
      ],
    );
  }

  Widget _branch(int index, int current, int? leaving) {
    final active = index == current;
    final fading = active && leaving != null;
    final background = Theme.of(context).scaffoldBackgroundColor;
    // The same widgets in every state, so no page ever loses its state.
    return Offstage(
      offstage: !active && index != leaving,
      child: IgnorePointer(
        ignoring: !active,
        child: HeroMode(
          enabled: active,
          child: TickerMode(
            enabled: active,
            child: FadeTransition(
              opacity: fading ? _opacity : kAlwaysCompleteAnimation,
              child: SlideTransition(
                position: fading ? _rise : _still,
                child: ColoredBox(
                  color: background,
                  child: widget.children[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
