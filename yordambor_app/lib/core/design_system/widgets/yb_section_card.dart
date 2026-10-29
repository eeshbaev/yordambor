import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

/// What a section is about, by colour: teal for the service and its
/// provider, gold for ratings, apricot for asking, violet for places,
/// green for things done.
enum YbSectionTone { teal, star, apricot, place, success }

/// Soft fill and ink for a [YbSectionTone], in either theme.
({Color fill, Color ink}) ybSectionToneColors(
  BuildContext context,
  YbSectionTone tone,
) {
  final c = context.ybColors;
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch (tone) {
    YbSectionTone.teal => (fill: c.tealSoft, ink: c.teal),
    YbSectionTone.star =>
      dark
          ? (fill: c.star.withValues(alpha: 0.16), ink: c.star)
          : (fill: const Color(0xFFFDF3DA), ink: const Color(0xFF9A6700)),
    YbSectionTone.apricot => (fill: c.apricotSoft, ink: c.apricotInk),
    YbSectionTone.place => (fill: c.placeSoft, ink: c.place),
    YbSectionTone.success => (fill: c.successSoft, ink: c.success),
  };
}

/// The small rounded square that marks a section: an icon on a soft tint.
class YbSectionMark extends StatelessWidget {
  const YbSectionMark({
    super.key,
    required this.icon,
    this.tone = YbSectionTone.teal,
    this.size = 32,
  });

  final IconData icon;
  final YbSectionTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tint = ybSectionToneColors(context, tone);

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tint.fill,
          borderRadius: BorderRadius.circular(size * 0.31),
        ),
        child: Icon(icon, size: size * 0.6, color: tint.ink),
      ),
    );
  }
}

/// One part of a page in its own frame: a coloured mark and a plain title
/// on top, so a scanning eye finds it, then the content. Light cards lift
/// with a soft shadow; dark ones get a hairline.
class YbSectionCard extends StatelessWidget {
  const YbSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.tone = YbSectionTone.teal,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final YbSectionTone tone;

  /// Sits at the end of the title row: a count, a small action.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: dark ? Border.all(color: colors.borderSubtle) : null,
        boxShadow: AppElevation.card(context),
      ),
      // Taps inside show their ripple on the card, not under it.
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  YbSectionMark(icon: icon, tone: tone),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: AppTypography.headline.copyWith(
                          color: colors.ink,
                        ),
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    trailing!,
                  ],
                ],
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
