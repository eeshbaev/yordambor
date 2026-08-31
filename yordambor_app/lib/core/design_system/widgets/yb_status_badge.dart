import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

enum YbStatusTone { warning, success, neutral, primary }

class YbStatusBadge extends StatelessWidget {
  const YbStatusBadge({
    super.key,
    required this.label,
    this.tone = YbStatusTone.neutral,
  });

  final String label;
  final YbStatusTone tone;

  Color get _color => switch (tone) {
        YbStatusTone.warning => AppColors.warning,
        YbStatusTone.success => AppColors.success,
        YbStatusTone.primary => AppColors.primary,
        YbStatusTone.neutral => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(color: _color),
      ),
    );
  }
}
