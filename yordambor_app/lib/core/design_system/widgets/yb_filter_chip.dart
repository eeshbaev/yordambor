import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// A 40 dp filter chip ("Toshkent", "Bugun boʻsh", "Filtr") inside a 48 dp
/// touch target. It grows with large text instead of clipping the label.
///
/// Off: card fill with a hairline. On: teal-soft with teal ink and no line.
/// The label weight stays the same in both states, so nothing shifts.
class YbFilterChip extends StatelessWidget {
  const YbFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showDropdown = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showDropdown;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final foreground = selected ? colors.tealInk : colors.ink;
    final background = selected ? colors.tealSoft : colors.card;
    final borderColor = selected ? colors.tealSoft : colors.line;

    return Semantics(
      button: true,
      selected: selected,
      child: YbScaleTap(
        onTap: () {
          AppHaptics.select();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedContainer(
            duration: AppMotion.quick,
            curve: AppMotion.quickCurve,
            // 20 dp line + 9 dp above and below + the hairline = 40 dp.
            padding: EdgeInsets.fromLTRB(14, 9, showDropdown ? 10 : 14, 9),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.chip),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppFonts.ui(
                      size: 14,
                      weight: FontWeight.w600,
                      height: 20 / 14,
                      color: foreground,
                    ),
                  ),
                ),
                if (showDropdown) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    YbIcons.expandMoreFilled,
                    size: 18,
                    color: selected ? colors.tealInk : colors.ink3,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
