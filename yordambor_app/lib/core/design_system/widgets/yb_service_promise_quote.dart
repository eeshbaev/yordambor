import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

class YbServicePromiseQuote extends StatelessWidget {
  const YbServicePromiseQuote({
    super.key,
    required this.promise,
    required this.strings,
    this.showDisclaimer = true,
    this.maxLines = 3,
  });

  final String promise;
  final AppStrings strings;
  final bool showDisclaimer;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.primaryMuted,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote_rounded,
                size: 22,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  promise,
                  style: AppTypography.body.copyWith(
                    color: colors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (showDisclaimer) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              strings.xizmatPromiseDisclaimer,
              style: AppTypography.caption.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
