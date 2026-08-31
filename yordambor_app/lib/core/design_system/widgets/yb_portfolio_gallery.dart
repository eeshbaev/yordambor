import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

class YbPortfolioGallery extends StatefulWidget {
  const YbPortfolioGallery({
    super.key,
    required this.imageUrls,
    this.height = 280,
    this.placeholderIcon = CategoryIcons.defaultIcon,
  });

  final List<String> imageUrls;
  final double height;
  final IconData placeholderIcon;

  @override
  State<YbPortfolioGallery> createState() => _YbPortfolioGalleryState();
}

class _YbPortfolioGalleryState extends State<YbPortfolioGallery> {
  late final PageController _controller;
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    if (widget.imageUrls.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: ColoredBox(
          color: colors.primaryMuted,
          child: Icon(
            widget.placeholderIcon,
            size: 48,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, index) {
              return YbNetworkImage(
                url: widget.imageUrls[index],
                placeholderIcon: widget.placeholderIcon,
                errorIcon: widget.placeholderIcon,
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: AppSpacing.lg,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (index) {
                  final active = index == _index;
                  return AnimatedContainer(
                    duration: AppMotion.fast,
                    curve: AppMotion.standard,
                    width: active ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
