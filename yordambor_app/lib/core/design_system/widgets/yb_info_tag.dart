import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

/// What a fact on a listing is about, told by colour as well as by its icon,
/// so a glance finds it: the trade (teal on a service, apricot on a
/// request), the city (violet, always with a pin), the money (green) and a
/// first provider's badge (gold). Plain facts such as a date stay neutral.
enum YbInfoTone { service, request, place, money, founding, neutral }

/// One fact on a listing: an icon and a short label in a soft pill.
class YbInfoTag extends StatelessWidget {
  const YbInfoTag({
    super.key,
    required this.icon,
    required this.label,
    this.tone = YbInfoTone.neutral,
    this.strong = false,
  });

  final IconData icon;
  final String label;
  final YbInfoTone tone;

  /// The budget people act on reads a step stronger.
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final (fill, ink, iconColor) = switch (tone) {
      YbInfoTone.service => (colors.tealSoft, colors.tealInk, colors.teal),
      YbInfoTone.request => (
          colors.apricotSoft,
          colors.apricotInk,
          colors.apricotInk,
        ),
      YbInfoTone.place => (colors.placeSoft, colors.placeInk, colors.place),
      YbInfoTone.money => (colors.successSoft, colors.ink, colors.success),
      YbInfoTone.founding => (
          Color.alphaBlend(colors.star.withValues(alpha: 0.2), colors.card),
          colors.ink,
          colors.star,
        ),
      YbInfoTone.neutral => (colors.surface2, colors.ink, colors.ink2),
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tabular(
                AppTypography.label.copyWith(
                  color: ink,
                  fontSize: strong ? 14 : 13,
                  fontWeight: strong ? FontWeight.w700 : FontWeight.w600,
                  height: 18 / 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
