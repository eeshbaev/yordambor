import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/experience_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/domain/entities/request_draft.dart';

/// The one next step on home (manual H-03): a deal waiting for the person's
/// reply, else their unfinished request, else a deal under way. Nothing
/// when there is no next step.
class HomeContinueCard extends ConsumerWidget {
  const HomeContinueCard({super.key, required this.onContinueDraft});

  /// Opens the request sheet, which restores the draft itself.
  final VoidCallback onContinueDraft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final deals = ref.watch(homeDealsProvider);
    final userId = ref.watch(sessionProvider.select((s) => s.user?.id));
    final draft = ref.watch(requestDraftProvider);
    final ownDraft = draft != null && draft.belongsTo(userId) ? draft : null;

    final Widget? card;
    if (deals.awaitingReply.isNotEmpty) {
      final deal = deals.awaitingReply.first;
      card = _ContinueTile(
        key: ValueKey('reply-${deal.id}'),
        tone: _Tone.need,
        icon: YbIcons.handshake,
        overline: strings.continueYourTurn,
        title: _dealTitle(deal),
        subtitle: _dealLine(deal, strings.continueReplyToDeal),
        onTap: () => context.push('/kelishuv/${deal.id}'),
      );
    } else if (ownDraft != null) {
      card = _ContinueTile(
        key: const ValueKey('draft'),
        tone: _Tone.need,
        icon: YbIcons.editNote,
        overline: strings.continueDraftTitle,
        title: ownDraft.title.trim().isEmpty
            ? strings.continueDraftUntitled
            : ownDraft.title.trim(),
        subtitle: strings.continueDraftHint,
        onTap: onContinueDraft,
        trailing: IconButton(
          tooltip: strings.draftDelete,
          icon: const Icon(YbIcons.close),
          onPressed: () => _deleteDraft(context, ref, strings, ownDraft),
        ),
      );
    } else if (deals.inProgress.isNotEmpty) {
      final deal = deals.inProgress.first;
      card = _ContinueTile(
        key: ValueKey('progress-${deal.id}'),
        tone: _Tone.help,
        icon: YbIcons.handshake,
        overline: strings.continueInProgress,
        title: _dealTitle(deal),
        subtitle: _dealLine(deal, strings.continueMarkDone),
        onTap: () => context.push('/kelishuv/${deal.id}'),
      );
    } else {
      card = null;
    }

    return AnimatedSize(
      duration: AppMotion.of(context, AppMotion.standardDuration),
      curve: AppMotion.standard,
      alignment: Alignment.topCenter,
      child: card == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: card,
            ),
    );
  }

  String _dealTitle(KelishuvSummary deal) {
    final post = deal.postTitle?.trim();
    return post != null && post.isNotEmpty ? post : deal.xizmatName;
  }

  String _dealLine(KelishuvSummary deal, String hint) {
    final other = deal.otherPartyName.trim();
    return other.isEmpty ? hint : '$other · $hint';
  }

  /// Delete now, offer an undo (manual S-04) instead of asking first.
  void _deleteDraft(
    BuildContext context,
    WidgetRef ref,
    AppStrings strings,
    RequestDraft draft,
  ) {
    final drafts = ref.read(requestDraftProvider.notifier);
    AppHaptics.destructive();
    drafts.clear();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(strings.draftDeleted),
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: strings.actionUndo,
            onPressed: () => drafts.save(draft),
          ),
        ),
      );
  }
}

enum _Tone { need, help }

class _ContinueTile extends StatelessWidget {
  const _ContinueTile({
    super.key,
    required this.tone,
    required this.icon,
    required this.overline,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final _Tone tone;
  final IconData icon;
  final String overline;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // The need and negotiating speak in apricot; agreed work in teal.
    final (soft, ink) = switch (tone) {
      _Tone.need => (colors.apricotSoft, colors.apricotInk),
      _Tone.help => (colors.tealSoft, colors.tealInk),
    };

    final tile = YbScaleTap(
      onTap: onTap,
      hitTestBehavior: HitTestBehavior.deferToChild,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: isDark ? Border.all(color: colors.borderSubtle) : null,
          boxShadow: isDark ? null : AppElevation.card(context),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            trailing == null ? AppSpacing.md : AppSpacing.xs,
            AppSpacing.md,
          ),
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
                      overline,
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
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              trailing ??
                  Icon(
                    YbIcons.chevronRight,
                    color: colors.textTertiary,
                  ),
            ],
          ),
        ),
      ),
    );

    // Without its own button, the card reads as one sentence (manual A-02).
    if (trailing != null) return tile;
    return Semantics(
      button: true,
      label: '$overline. $title. $subtitle',
      onTap: onTap,
      excludeSemantics: true,
      child: tile,
    );
  }
}
