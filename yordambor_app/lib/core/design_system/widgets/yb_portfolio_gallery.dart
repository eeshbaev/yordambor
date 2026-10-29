import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/design_system/widgets/yb_photo_hero.dart';
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
    this.placeholderColor,
    this.placeholderIconColor,
    this.heroTag,
    this.indicatorInset = AppSpacing.lg,
  });

  final List<String> imageUrls;
  final double height;
  final IconData placeholderIcon;

  /// The frame photos fade into: the category tint the cards use.
  final Color? placeholderColor;
  final Color? placeholderIconColor;

  /// The first photo lands here from its card (manual M-02).
  final Object? heroTag;

  /// How far above the bottom the page dots sit, so content that overlaps
  /// the gallery's edge does not hide them.
  final double indicatorInset;

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
      final placeholder = SizedBox(
        height: widget.height,
        child: ColoredBox(
          color: widget.placeholderColor ?? colors.primaryMuted,
          child: Icon(
            widget.placeholderIcon,
            size: 48,
            color: widget.placeholderIconColor ??
                context.ybColors.teal.withValues(alpha: 0.5),
          ),
        ),
      );
      final tag = widget.heroTag;
      return tag == null ? placeholder : YbPhotoHero(tag: tag, child: placeholder);
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
              final image = YbNetworkImage(
                url: widget.imageUrls[index],
                placeholderIcon: widget.placeholderIcon,
                errorIcon: widget.placeholderIcon,
                placeholderColor: widget.placeholderColor,
                placeholderIconColor: widget.placeholderIconColor,
              );
              final tag = widget.heroTag;
              if (index != 0 || tag == null) return image;
              return YbPhotoHero(tag: tag, child: image);
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
              bottom: widget.indicatorInset,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (index) {
                  final active = index == _index;
                  // The active dot stretches; with reduced motion it
                  // simply changes.
                  return AnimatedContainer(
                    duration: AppMotion.of(context, AppMotion.fast),
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
