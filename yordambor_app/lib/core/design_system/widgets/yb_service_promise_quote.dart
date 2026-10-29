import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

/// What a provider promises ("The first consultation is free."), in their
/// own words: a quote mark, the promise, and a short line saying whose
/// words they are. The full note (YordamBor gives no guarantee) opens with
/// a tap on the card and is read by screen readers, so it is there without
/// being read every time.
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

    final card = Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg - 2,
        AppSpacing.md + 2,
        AppSpacing.lg,
        AppSpacing.md + 2,
      ),
      decoration: BoxDecoration(
        color: colors.tealSoft,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.card,
                shape: BoxShape.circle,
              ),
              child: Icon(
                YbIcons.formatQuoteFilled,
                size: 20,
                color: colors.teal,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  promise,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headline.copyWith(
                    color: colors.ink,
                    fontSize: 16,
                    height: 22 / 16,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        strings.xizmatPromiseOwnWords,
                        style: AppTypography.label.copyWith(color: colors.ink2),
                      ),
                    ),
                    if (showDisclaimer) ...[
                      const SizedBox(width: 4),
                      ExcludeSemantics(
                        child: Icon(YbIcons.info, size: 16, color: colors.ink3),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!showDisclaimer) return card;
    return Tooltip(
      message: strings.xizmatPromiseDisclaimer,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 5),
      child: card,
    );
  }
}
