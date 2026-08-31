import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/presentation/kelishuv/repeat_booking_flow.dart';

class KelishuvListTile extends ConsumerWidget {
  const KelishuvListTile({
    super.key,
    required this.item,
    this.subtitle,
    this.showRepeatBook = false,
  });

  final KelishuvSummary item;
  final String? subtitle;
  final bool showRepeatBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: YbScaleTap(
        onTap: () => context.push('/kelishuv/${item.id}'),
        child: YbSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.otherPartyName,
                          style: AppTypography.headline.copyWith(
                            color: colors.textPrimary,
                          ),
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
                  if (showRepeatBook && item.canRepeatBook)
                    IconButton(
                      icon: const Icon(Icons.replay_rounded),
                      tooltip: strings.repeatBook,
                      onPressed: () {
                        AppHaptics.selection();
                        openRepeatBookFromSummary(
                          context,
                          ref,
                          summary: item,
                        );
                      },
                    ),
                  Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
                ],
              ),
              if (item.message != null && item.message!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.message!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyRegular.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  YbStatusBadge(
                    label: strings.kelishuvStatusLabel(item.status),
                    tone: _tone(item.status),
                  ),
                  if (item.needsMyAccept)
                    YbStatusBadge(
                      label: strings.kelishuvNeedsResponse,
                      tone: YbStatusTone.warning,
                    ),
                  if (item.needsMyComplete)
                    YbStatusBadge(
                      label: strings.kelishuvNeedsConfirm,
                      tone: YbStatusTone.primary,
                    ),
                  if (item.priceLabel.isNotEmpty)
                    Text(
                      item.priceLabel,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  YbStatusTone _tone(KelishuvStatus status) => switch (status) {
        KelishuvStatus.jarayonda => YbStatusTone.success,
        KelishuvStatus.muzokarada => YbStatusTone.primary,
        KelishuvStatus.bajarildi => YbStatusTone.primary,
        _ => YbStatusTone.neutral,
      };
}
