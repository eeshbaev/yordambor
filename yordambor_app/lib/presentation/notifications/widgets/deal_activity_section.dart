import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';

/// Live deals at the top of notifications, so where each one stands is
/// always in sight: the person's turn first (apricot), work under way
/// (teal), offers sent and waiting (grey), done and waiting for the other
/// side (green). Each opens its deal. Nothing when there are no live deals.
class DealActivitySection extends ConsumerWidget {
  const DealActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final activity = ref.watch(dealActivityProvider);
    if (activity.isEmpty) return const SizedBox.shrink();
    final colors = context.ybColors;
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              strings.dealsSectionTitle,
              style: AppTypography.headline.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (index, item) in activity.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            _DealActivityTile(
              key: ValueKey('deal-activity-${item.deal.id}'),
              item: item,
              strings: strings,
              now: now,
            ),
          ],
        ],
      ),
    );
  }
}

class _DealActivityTile extends StatelessWidget {
  const _DealActivityTile({
    super.key,
    required this.item,
    required this.strings,
    required this.now,
  });

  final DealActivity item;
  final AppStrings strings;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deal = item.deal;
    final (soft, ink, icon, state, hint) = switch (item.kind) {
      DealActivityKind.yourTurn => (
          colors.apricotSoft,
          colors.apricotInk,
          YbIcons.handshake,
          strings.dealStateYourTurn,
          strings.continueReplyToDeal,
        ),
      DealActivityKind.inProgress => (
          colors.tealSoft,
          colors.tealInk,
          YbIcons.taskAlt,
          strings.dealStateInProgress,
          strings.continueMarkDone,
        ),
      DealActivityKind.sent => (
          colors.surface2,
          colors.ink2,
          YbIcons.hourglassTop,
          strings.dealStateSent,
          _sentHint(deal),
        ),
      DealActivityKind.awaitingConfirmation => (
          colors.successSoft,
          colors.success,
          YbIcons.checkCircleFilled,
          strings.dealStateAwaitingConfirm,
          null,
        ),
    };
    final title = _title(deal);
    final other = deal.otherPartyName.trim();
    final subtitle = [
      if (other.isNotEmpty) other,
      ?hint,
    ].join(' · ');
    void open() => context.push('/kelishuv/${deal.id}');

    // One sentence for screen readers (manual A-02).
    return Semantics(
      button: true,
      label: '$state. $title. $subtitle',
      onTap: open,
      excludeSemantics: true,
      child: YbScaleTap(
        onTap: open,
        hitTestBehavior: HitTestBehavior.deferToChild,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: isDark ? Border.all(color: colors.borderSubtle) : null,
            boxShadow: isDark ? null : AppElevation.card(context),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: soft,
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                  child: SizedBox.square(
                    dimension: 44,
                    child: Icon(icon, size: 22, color: ink),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label.copyWith(color: ink),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headline.copyWith(
                          color: colors.ink,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(YbIcons.chevronRight, color: colors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The request's title when it answers one, else the service.
  String _title(KelishuvSummary deal) {
    final post = deal.postTitle?.trim();
    return post != null && post.isNotEmpty ? post : deal.xizmatName;
  }

  /// How long the other side still has to answer.
  String? _sentHint(KelishuvSummary deal) {
    final days = deal.daysLeftToRespond(now);
    return days == null ? null : strings.dealOfferAutoCancel(days);
  }
}
