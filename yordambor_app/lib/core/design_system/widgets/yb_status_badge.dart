import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

/// Status tones. In deals: warning is "Muzokarada" (negotiating, apricot),
/// primary is "Jarayonda" (in progress, teal), success is "Bajarildi"
/// (done, green), neutral is cancelled or inactive.
enum YbStatusTone { warning, success, neutral, primary }

/// Soft background and ink foreground for a [YbStatusTone].
({Color background, Color foreground}) ybStatusColors(
  BuildContext context,
  YbStatusTone tone,
) {
  final c = context.ybColors;
  return switch (tone) {
    YbStatusTone.warning => (background: c.apricotSoft, foreground: c.apricotInk),
    YbStatusTone.success => (background: c.successSoft, foreground: c.success),
    YbStatusTone.primary => (background: c.tealSoft, foreground: c.tealInk),
    YbStatusTone.neutral => (background: c.surface2, foreground: c.ink2),
  };
}

/// A 28 dp status pill with a dot, so status never relies on colour alone.
class YbStatusBadge extends StatelessWidget {
  const YbStatusBadge({
    super.key,
    required this.label,
    this.tone = YbStatusTone.neutral,
  });

  final String label;
  final YbStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = ybStatusColors(context, tone);

    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: ShapeDecoration(
        color: colors.background,
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: colors.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: AppFonts.ui(
              size: 12.5,
              weight: FontWeight.w600,
              height: 16 / 12.5,
              color: colors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
