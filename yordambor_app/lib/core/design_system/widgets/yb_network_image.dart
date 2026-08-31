import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/network/yb_image_cache.dart';

class YbNetworkImage extends StatelessWidget {
  const YbNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholderIcon = Icons.image_outlined,
    this.errorIcon = Icons.broken_image_outlined,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final IconData placeholderIcon;
  final IconData errorIcon;

  static bool isAssetUrl(String url) => url.startsWith('assets/');

  static int memCacheSize(BuildContext context, double logicalSize) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return (logicalSize * dpr).round().clamp(48, 1200);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final trimmed = url.trim();

    if (trimmed.isEmpty) {
      return _Placeholder(colors: colors, icon: placeholderIcon);
    }

    if (isAssetUrl(trimmed)) {
      return Image.asset(
        trimmed,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) =>
            _Placeholder(colors: colors, icon: errorIcon),
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
      fadeInDuration: const Duration(milliseconds: 180),
      fadeOutDuration: const Duration(milliseconds: 80),
      placeholder: (_, _) => _Placeholder(
        colors: colors,
        icon: placeholderIcon,
      ),
      errorWidget: (_, _, _) => _Placeholder(
        colors: colors,
        icon: errorIcon,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.colors,
    required this.icon,
  });

  final YbThemeColors colors;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colors.primaryMuted,
      child: Center(
        child: Icon(
          icon,
          size: 48,
          color: AppColors.primary.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
