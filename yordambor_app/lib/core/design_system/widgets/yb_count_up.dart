import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

/// A hero number that counts up to its value (manual V-04): 700 ms, ease-out,
/// tabular figures so the width never jitters. When the value changes it
/// counts from the old one. Screen readers hear only the final value, and
/// with reduced motion it simply appears.
class YbCountUp extends StatelessWidget {
  const YbCountUp({
    super.key,
    required this.value,
    required this.format,
    this.style,
    this.duration = const Duration(milliseconds: 700),
  });

  final double value;
  final String Function(double value) format;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.tabular(style ?? AppTypography.largeTitle);
    final finalText = format(value);

    return Semantics(
      label: finalText,
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value),
        duration: AppMotion.of(context, duration),
        curve: Curves.easeOutCubic,
        builder: (context, current, _) => Text(
          // The last frame shows the exact value, not a rounded neighbour.
          current == value ? finalText : format(current),
          style: textStyle,
          maxLines: 1,
        ),
      ),
    );
  }
}
