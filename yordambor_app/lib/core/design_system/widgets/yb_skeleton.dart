import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

class YbSkeletonBox extends StatefulWidget {
  const YbSkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.card,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<YbSkeletonBox> createState() => _YbSkeletonBoxState();
}

class _YbSkeletonBoxState extends State<YbSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _still = false;

  @override
  void initState() {
    super.initState();
    // A soft shimmer sweep, 1.3 s per pass (manual Part 8A).
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // With reduced motion the skeleton stays still.
    _still = AppMotion.reduced(context);
    if (_still) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = colors.surface2;
    final highlight = isDark ? colors.surface3 : colors.card;
    final radius = BorderRadius.circular(widget.borderRadius);

    if (_still) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(color: base, borderRadius: radius),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // A highlight band travels from just before the left edge to just
        // past the right edge.
        final centre = -0.3 + 1.6 * Curves.easeInOut.transform(_controller.value);
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              colors: [base, highlight, base],
              stops: [
                (centre - 0.3).clamp(0.0, 1.0),
                centre.clamp(0.0, 1.0),
                (centre + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class YbSkeletonCard extends StatelessWidget {
  const YbSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.ybColors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppElevation.card(context),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              YbSkeletonBox(width: double.infinity, height: 200, borderRadius: 0),
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YbSkeletonBox(width: 180, height: 18),
                    SizedBox(height: AppSpacing.sm),
                    YbSkeletonBox(width: 120, height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YbSkeletonList extends StatelessWidget {
  const YbSkeletonList({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => const YbSkeletonCard(),
    );
  }
}
