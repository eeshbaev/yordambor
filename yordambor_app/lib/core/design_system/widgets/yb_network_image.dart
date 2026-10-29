import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/network/yb_image_cache.dart';

class YbNetworkImage extends StatelessWidget {
  const YbNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholderIcon = YbIcons.image,
    this.errorIcon = YbIcons.brokenImage,
    this.placeholderColor,
    this.placeholderIconColor,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final IconData placeholderIcon;
  final IconData errorIcon;

  /// The frame the photo fades into; a category tint on cards.
  final Color? placeholderColor;
  final Color? placeholderIconColor;

  static bool isAssetUrl(String url) => url.startsWith('assets/');

  static int memCacheSize(BuildContext context, double logicalSize) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return (logicalSize * dpr).round().clamp(48, 1200);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final trimmed = url.trim();
    final fill = placeholderColor ?? colors.primaryMuted;
    final ink = placeholderIconColor ?? colors.teal.withValues(alpha: 0.45);
    final still = AppMotion.reduced(context);

    if (trimmed.isEmpty) {
      return _Placeholder(fill: fill, ink: ink, icon: placeholderIcon);
    }

    if (isAssetUrl(trimmed)) {
      return Image.asset(
        trimmed,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) =>
            _Placeholder(fill: fill, ink: ink, icon: errorIcon),
      );
    }

    final memWidth = width != null
        ? memCacheSize(context, width!)
        : memCacheSize(context, MediaQuery.sizeOf(context).width);

    return CachedNetworkImage(
      imageUrl: trimmed,
      fit: fit,
      width: width,
      height: height,
      cacheManager: YbImageCache.manager,
      memCacheWidth: memWidth,
      // The photo fades into its fixed frame; no jump, no grey flash.
      fadeInDuration:
          still ? Duration.zero : const Duration(milliseconds: 250),
      fadeOutDuration:
          still ? Duration.zero : const Duration(milliseconds: 150),
      placeholder: (_, _) => _Placeholder(
        fill: fill,
        ink: ink,
        icon: placeholderIcon,
      ),
      errorWidget: (_, _, _) => _Placeholder(
        fill: fill,
        ink: ink,
        icon: errorIcon,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.fill,
    required this.ink,
    required this.icon,
  });

  final Color fill;
  final Color ink;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: fill,
      child: Center(
        child: Icon(icon, size: 44, color: ink),
      ),
    );
  }
}
