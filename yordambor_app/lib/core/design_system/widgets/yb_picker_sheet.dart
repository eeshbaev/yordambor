import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// Shared chrome for modal picker bottom sheets.
Future<T?> showYbPickerSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
}) {
  final colors = context.ybColors;

  return showModalBottomSheet<T>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    backgroundColor: colors.surfaceElevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
    ),
    builder: (context) => child,
  );
}

class YbPickerSheetHeader extends StatelessWidget {
  const YbPickerSheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.ybColors.tealSoft,
                borderRadius: BorderRadius.circular(AppRadius.tile),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm + 2),
                child: Icon(icon, size: 22, color: context.ybColors.teal),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.title.copyWith(color: colors.textPrimary),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YbPickerOptionTile extends StatelessWidget {
  const YbPickerOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.emoji,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: YbScaleTap(
        onTap: () {
          AppHaptics.selection();
          onTap();
        },
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          constraints: const BoxConstraints(minHeight: AppTouch.minTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.tealSoft : colors.card,
            borderRadius: BorderRadius.circular(AppRadius.field),
            border: Border.all(
              color: selected ? colors.teal : colors.line,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (icon != null || emoji != null) ...[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: selected ? colors.card : colors.surface2,
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: emoji != null
                          ? Text(emoji!, style: const TextStyle(fontSize: 22))
                          : Icon(
                              icon,
                              size: 22,
                              color: selected ? colors.teal : colors.ink2,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: AppTypography.headline.copyWith(
                        color: selected ? colors.tealInk : colors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedContainer(
                duration: AppMotion.fast,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? colors.teal : Colors.transparent,
                  border: selected
                      ? null
                      : Border.all(color: colors.outline, width: 1.5),
                ),
                child: selected
                    ? Icon(YbIcons.checkFilled, size: 16, color: colors.onTeal)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YbCompactPickerSheet extends StatelessWidget {
  const YbCompactPickerSheet({
    super.key,
    required this.title,
    this.subtitle,
    this.headerIcon,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final String title;
  final String? subtitle;
  final IconData? headerIcon;
  final List<YbPickerOption> options;
  final String? selectedId;
  final ValueChanged<YbPickerOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final maxListHeight = MediaQuery.sizeOf(context).height * 0.55;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YbPickerSheetHeader(
          title: title,
          subtitle: subtitle,
          icon: headerIcon,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxListHeight),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg + bottomSafe,
            ),
            children: [
              for (final option in options)
                YbPickerOptionTile(
                  label: option.label,
                  subtitle: option.subtitle,
                  icon: option.icon,
                  emoji: option.emoji,
                  selected: selectedId == option.id,
                  onTap: () => onSelected(option),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class YbPickerOption {
  const YbPickerOption({
    required this.id,
    required this.label,
    this.subtitle,
    this.icon,
    this.emoji,
  });

  final String id;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final String? emoji;
}
