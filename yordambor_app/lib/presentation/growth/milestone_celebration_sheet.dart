import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/growth/achievement.dart';

Future<void> showAchievementCelebrationSheet(
  BuildContext context, {
  required String achievementId,
  required AppStrings strings,
}) {
  AppHaptics.success();
  return showModalBottomSheet<void>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
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
                  color: context.ybColors.teal,
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
        'handyman' => YbIcons.handyman,
        'handshake' => YbIcons.handshake,
        'star' => YbIcons.star,
        'stars' => YbIcons.stars,
        'emoji_events' => YbIcons.emojiEvents,
        'grade' => YbIcons.grade,
        'workspace_premium' => YbIcons.workspacePremium,
        'favorite' => YbIcons.favorite,
        _ => YbIcons.celebration,
      };
    }
  }
  return YbIcons.celebration;
}
