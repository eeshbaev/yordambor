import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// The end of a feed says so (design direction 10B), and offers the next
/// move instead of an empty scroll.
class HomeFeedEnd extends StatelessWidget {
  const HomeFeedEnd({
    super.key,
    required this.title,
    this.prompt,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? prompt;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: colors.line, height: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Icon(YbIcons.doneAll, size: 20, color: colors.teal),
              ),
              Expanded(child: Divider(color: colors.line, height: 1)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.headline.copyWith(color: colors.ink),
          ),
          if (prompt != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              prompt!,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.md),
            YbPrimaryButton(
              label: actionLabel!,
              icon: YbIcons.campaign,
              tone: YbButtonTone.askTonal,
              height: AppTouch.buttonHeightMedium,
              expand: false,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
