import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

enum YordamBorLogoVariant {
  /// Light surfaces — soft card shadow.
  standard,

  /// Teal splash — subtle light halo so the mark lifts off the background.
  onPrimary,
}

const _logoAssetPath =
    'assets/logo/yordambor-logo-v6-angled-perspective.png';

/// Compact logo for app bars and inline brand rows.
class YordamBorLogoMark extends StatelessWidget {
  const YordamBorLogoMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.22);

    return ClipRRect(
      borderRadius: radius,
      child: Image.asset(
        _logoAssetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

/// App name with logo: Yordam (dark) + Bor (brand teal).
class YbAppBrandTitle extends StatelessWidget {
  const YbAppBrandTitle({
    super.key,
    this.style,
    this.logoSize = 32,
    this.subtitle,
  });

  final TextStyle? style;
  final double logoSize;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final textStyle =
        style ?? AppTypography.title.copyWith(color: colors.textPrimary);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: subtitle != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        YordamBorLogoMark(size: logoSize),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Yordam',
                  style: textStyle,
                  children: [
                    TextSpan(
                      text: 'Bor',
                      style: textStyle.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                subtitle!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class YordamBorLogo extends StatelessWidget {
  const YordamBorLogo({
    super.key,
    this.size = 120,
    this.variant = YordamBorLogoVariant.standard,
  });

  final double size;
  final YordamBorLogoVariant variant;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.22);

    final image = ClipRRect(
      borderRadius: radius,
      child: Image.asset(
        _logoAssetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );

    final shadows = switch (variant) {
      YordamBorLogoVariant.onPrimary => [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.28),
          blurRadius: size * 0.28,
          spreadRadius: size * 0.02,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: size * 0.12,
          offset: Offset(0, size * 0.04),
        ),
      ],
      YordamBorLogoVariant.standard => AppElevation.card(context),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: shadows,
      ),
      child: image,
    );
  }
}
