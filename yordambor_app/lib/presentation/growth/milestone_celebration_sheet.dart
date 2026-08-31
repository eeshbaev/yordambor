import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/growth/achievement.dart';

Future<void> showAchievementCelebrationSheet(
  BuildContext context, {
  required String achievementId,
  required AppStrings strings,
}) {
  AppHaptics.success();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    showDragHandle: true,
    builder: (context) {
      final colors = context.ybColors;

      return YbSheetBody(
          title: strings.achievementTitle(achievementId),
          subtitle: strings.achievementBody(achievementId),
          children: [
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.primaryMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconFor(achievementId),
                  size: 44,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            YbPrimaryButton(
              label: strings.actionContinue,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
    },
  );
}

IconData _iconFor(String id) {
  for (final def in AchievementCatalog.all) {
    if (def.id == id) {
      return switch (def.iconName) {
        'handyman' => Icons.handyman_outlined,
        'handshake' => Icons.handshake_outlined,
        'star' => Icons.star_outline,
        'stars' => Icons.stars_outlined,
        'emoji_events' => Icons.emoji_events_outlined,
        'grade' => Icons.grade_outlined,
        'workspace_premium' => Icons.workspace_premium_outlined,
        'favorite' => Icons.favorite_outline,
        _ => Icons.celebration_outlined,
      };
    }
  }
  return Icons.celebration_outlined;
}
