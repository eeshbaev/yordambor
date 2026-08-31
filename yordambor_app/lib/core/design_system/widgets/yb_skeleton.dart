import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Color.lerp(
              colors.skeleton,
              colors.surfaceElevated,
              _controller.value,
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
          border: Border.all(color: context.ybColors.borderSubtle),
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
