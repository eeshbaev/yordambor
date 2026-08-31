import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';

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
    final foreground = selected ? Colors.white : AppColors.primaryDark;
    final background = selected ? AppColors.primary : colors.card;
    final borderColor = selected
        ? AppColors.primaryDark
        : colors.border;

    return YbScaleTap(
      onTap: () {
        AppHaptics.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: borderColor,
            width: selected ? 1 : 1,
          ),
          boxShadow: selected ? AppElevation.cardPressed(context) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTypography.label.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (showDropdown) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.expand_more_rounded, size: 20, color: foreground),
            ],
          ],
        ),
      ),
    );
  }
}
