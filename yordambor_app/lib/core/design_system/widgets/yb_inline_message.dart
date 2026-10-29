import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

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

  /// Soft fill and its matching ink, per tone.
  ({Color fill, Color ink}) _colors(YbThemeColors c) => switch (tone) {
        YbInlineMessageTone.error => (fill: c.errorSoft, ink: c.error),
        YbInlineMessageTone.warning => (fill: c.apricotSoft, ink: c.apricotInk),
        YbInlineMessageTone.info => (fill: c.tealSoft, ink: c.tealInk),
        YbInlineMessageTone.success => (fill: c.successSoft, ink: c.success),
      };

  IconData _defaultIcon() => switch (tone) {
        YbInlineMessageTone.error => YbIcons.error,
        YbInlineMessageTone.warning => YbIcons.info,
        YbInlineMessageTone.info => YbIcons.info,
        YbInlineMessageTone.success => YbIcons.checkCircle,
      };

  @override
  Widget build(BuildContext context) {
    final palette = _colors(context.ybColors);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.fill,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? _defaultIcon(), size: 20, color: palette.ink),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.body.copyWith(
                color: palette.ink,
                fontSize: 14,
                height: 20 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
