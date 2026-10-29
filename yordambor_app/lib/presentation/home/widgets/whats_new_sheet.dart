import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

/// One sheet after an update, never on a fresh install (manual WL-03):
/// three short notes and a single button. Shown once per release.
Future<void> showWhatsNewSheet(BuildContext context, AppStrings strings) {
  return showModalBottomSheet<void>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => _WhatsNewSheet(strings: strings),
  );
}

class _WhatsNewSheet extends StatelessWidget {
  const _WhatsNewSheet({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final notes = [
      (YbIcons.autoAwesome, strings.whatsNewLookTitle, strings.whatsNewLookBody),
      (
        YbIcons.pendingActions,
        strings.whatsNewNextStepTitle,
        strings.whatsNewNextStepBody,
      ),
      (YbIcons.editNote, strings.whatsNewDraftsTitle, strings.whatsNewDraftsBody),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            strings.whatsNewTitle,
            style: AppTypography.title.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final (icon, title, body) in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: MergeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.tealSoft,
                        borderRadius: BorderRadius.circular(AppRadius.tile),
                      ),
                      child: SizedBox.square(
                        dimension: 44,
                        child: Icon(icon, size: 22, color: colors.tealInk),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.headline.copyWith(
                              color: colors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            body,
                            style: AppTypography.body.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          YbPrimaryButton(
            label: strings.whatsNewDone,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
