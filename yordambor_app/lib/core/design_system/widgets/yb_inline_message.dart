import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

enum YbInlineMessageTone { error, warning, info, success }

class YbInlineMessage extends StatelessWidget {
  const YbInlineMessage({
    super.key,
    required this.message,
    this.tone = YbInlineMessageTone.error,
    this.icon,
  });

  final String message;
  final YbInlineMessageTone tone;
  final IconData? icon;

  Color _color() => switch (tone) {
        YbInlineMessageTone.error => AppColors.error,
        YbInlineMessageTone.warning => AppColors.warning,
        YbInlineMessageTone.info => AppColors.primary,
        YbInlineMessageTone.success => AppColors.success,
      };

  IconData _defaultIcon() => switch (tone) {
        YbInlineMessageTone.error => Icons.error_outline_rounded,
        YbInlineMessageTone.warning => Icons.info_outline_rounded,
        YbInlineMessageTone.info => Icons.info_outline_rounded,
        YbInlineMessageTone.success => Icons.check_circle_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final color = _color();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? _defaultIcon(), size: 20, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.caption.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
