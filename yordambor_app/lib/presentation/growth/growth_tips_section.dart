import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/growth/growth_program.dart';
import 'package:yordambor/application/growth/growth_program_providers.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/presentation/growth/growth_actions.dart';

/// "Grow your business" as one row among the notifications: where the
/// person is in their 30 days and today's tip title. Tapping it opens the
/// tip in full, with its one button and the earlier tips.
class GrowthTipsSection extends ConsumerWidget {
  const GrowthTipsSection({super.key, this.onCertificates});

  /// Opens the certificates, for the tip that asks for documents.
  final VoidCallback? onCertificates;

  /// Whether the row will show: the program is on and has a tip.
  static bool hasTip(WidgetRef ref) =>
      ref.watch(growthProgramProvider).valueOrNull?.latest != null;

  void _open(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      sheetAnimationStyle: AppMotion.sheetOf(context),
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: _GrowthTipsPanel(onCertificates: onCertificates),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(growthProgramProvider).valueOrNull;
    final latest = state?.latest;
    if (state == null || latest == null) return const SizedBox.shrink();
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final unread = state.unread > 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      onTap: () => _open(context),
      leading: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.teal, colors.tealInk],
          ),
        ),
        child: const SizedBox.square(
          dimension: 40,
          child: Icon(
            YbIcons.rocketLaunchFilled,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      title: Text(
        GrowthProgram.title(strings, latest.tip.id),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.body.copyWith(
          color: colors.textPrimary,
          fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${strings.growthProgramTitle} · '
        '${strings.growthProgramDay(state.day.clamp(1, GrowthProgram.days))}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.caption.copyWith(color: colors.textSecondary),
      ),
      trailing: unread
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colors.teal,
                shape: BoxShape.circle,
              ),
            )
          : Icon(YbIcons.chevronRight, color: colors.ink3),
    );
  }
}

/// The program in full, in its sheet: progress, the newest tip with its
/// button, and the earlier ones below. Opening it counts as reading them.
class _GrowthTipsPanel extends ConsumerStatefulWidget {
  const _GrowthTipsPanel({this.onCertificates});

  final VoidCallback? onCertificates;

  @override
  ConsumerState<_GrowthTipsPanel> createState() => _GrowthTipsPanelState();
}

class _GrowthTipsPanelState extends ConsumerState<_GrowthTipsPanel> {
  bool _showEarlier = false;
  bool _markedRead = false;

  void _markRead(GrowthProgramState state) {
    if (_markedRead || state.unread == 0) return;
    _markedRead = true;
    final userId = ref.read(sessionProvider).user?.id;
    if (userId == null) return;
    final ids = [for (final view in state.delivered) view.tip.id];
    // The row under the sheet must update even after the sheet is closed.
    final container = ProviderScope.containerOf(context, listen: false);
    // After the sheet has shown them as new once.
    unawaited(
      Future<void>.delayed(const Duration(seconds: 2), () async {
        await GrowthProgramStore.markRead(userId, ids);
        container.invalidate(growthProgramProvider);
      }),
    );
  }

  /// [action] after closing the sheet, so the screen it opens is in view.
  VoidCallback? _closeThen(VoidCallback? action) {
    if (action == null) return null;
    return () {
      Navigator.of(context).pop();
      action();
    };
  }

  Future<void> _turnOff(AppStrings strings) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await ref.read(growthTipsEnabledProvider.notifier).set(false);
    if (navigator.canPop()) navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(strings.growthTipsOffDone)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(growthProgramProvider).valueOrNull;
    final latest = state?.latest;
    if (state == null || latest == null) return const SizedBox.shrink();
    _markRead(state);

    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final earlier = state.delivered.skip(1).toList();
    final progress = (state.day / GrowthProgram.days).clamp(0.0, 1.0);
    const onHero = Colors.white;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(colors.teal, Colors.white, 0.08)!,
              colors.teal,
              colors.tealInk,
            ],
          ),
          boxShadow: AppElevation.card(context),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Stack(
            children: [
              PositionedDirectional(
                end: -24,
                top: -30,
                child: ExcludeSemantics(
                  child: Icon(
                    YbIcons.rocketLaunchFilled,
                    size: 140,
                    color: onHero.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md + 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          YbIcons.tipsAndUpdatesFilled,
                          color: onHero,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Semantics(
                            header: true,
                            child: Text(
                              strings.growthProgramTitle,
                              style: AppTypography.headline.copyWith(
                                color: onHero,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuButton<int>(
                          tooltip: strings.actionMore,
                          icon: Icon(
                            YbIcons.moreVertFilled,
                            color: onHero.withValues(alpha: 0.9),
                          ),
                          onSelected: (_) => _turnOff(strings),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 0,
                              child: Text(strings.growthTipsOff),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      strings.growthProgramDay(
                        state.day.clamp(1, GrowthProgram.days),
                      ),
                      style: AppTypography.caption.copyWith(
                        color: onHero.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration:
                          AppMotion.of(context, AppMotion.emphasised * 2),
                      curve: AppMotion.standard,
                      builder: (context, value, _) => ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          backgroundColor: onHero.withValues(alpha: 0.2),
                          color: colors.star,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AnimatedSwitcher(
                      duration: AppMotion.of(context, AppMotion.standardDuration),
                      child: _TipCard(
                        key: ValueKey(latest.tip.id),
                        view: latest,
                        strings: strings,
                        onAction: () => runGrowthAction(
                          context,
                          ref,
                          latest.tip.action,
                          state.services,
                          onCertificates: _closeThen(widget.onCertificates),
                        ),
                      ),
                    ),
                    if (earlier.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: onHero,
                          alignment: AlignmentDirectional.centerStart,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () =>
                            setState(() => _showEarlier = !_showEarlier),
                        icon: AnimatedRotation(
                          turns: _showEarlier ? 0.5 : 0,
                          duration: AppMotion.of(context, AppMotion.quick),
                          child: const Icon(YbIcons.expandMore, size: 20),
                        ),
                        label: Text(
                          '${strings.growthEarlierTips} · ${earlier.length}',
                        ),
                      ),
                      AnimatedSize(
                        duration:
                            AppMotion.of(context, AppMotion.standardDuration),
                        curve: AppMotion.standard,
                        alignment: Alignment.topCenter,
                        child: !_showEarlier
                            ? const SizedBox(width: double.infinity)
                            : Column(
                                children: [
                                  for (final view in earlier)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.sm,
                                      ),
                                      child: _TipCard(
                                        view: view,
                                        strings: strings,
                                        compact: true,
                                        onAction: () => runGrowthAction(
                                          context,
                                          ref,
                                          view.tip.action,
                                          state.services,
                                          onCertificates: _closeThen(
                                            widget.onCertificates,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One tip on white: its picture, words and button, or a tick when done.
class _TipCard extends StatelessWidget {
  const _TipCard({
    super.key,
    required this.view,
    required this.strings,
    required this.onAction,
    this.compact = false,
  });

  final GrowthTipView view;
  final AppStrings strings;
  final VoidCallback onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final tip = view.tip;
    final accent = tip.promo ? colors.apricot : colors.teal;
    final accentSoft = tip.promo ? colors.apricotSoft : colors.tealSoft;
    final action = GrowthProgram.actionLabel(strings, tip.action);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card - 4),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.md + 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TipArt(icon: tip.icon, accent: accent, soft: accentSoft),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GrowthProgram.title(strings, tip.id),
                        style: AppTypography.body.copyWith(
                          color: colors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        GrowthProgram.body(strings, tip.id),
                        maxLines: compact ? 3 : null,
                        overflow: compact ? TextOverflow.ellipsis : null,
                        style: AppTypography.caption.copyWith(
                          color: colors.ink2,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (view.done || action != null) ...[
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: view.done
                    ? _DoneChip(label: strings.growthTipDone)
                    : FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          backgroundColor: accentSoft,
                          foregroundColor:
                              tip.promo ? colors.apricotInk : colors.tealInk,
                          minimumSize: const Size(0, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                        ),
                        onPressed: onAction,
                        icon: const Icon(YbIcons.arrowForward, size: 18),
                        label: Text(action!),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The tip's picture: its icon on a soft tile with two sparks.
class _TipArt extends StatelessWidget {
  const _TipArt({
    required this.icon,
    required this.accent,
    required this.soft,
  });

  final IconData icon;
  final Color accent;
  final Color soft;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: 48,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [soft, Color.lerp(soft, accent, 0.18)!],
                  ),
                ),
              ),
            ),
            Center(child: Icon(icon, color: accent, size: 26)),
            Positioned(
              right: -3,
              top: -3,
              child: Icon(
                YbIcons.autoAwesomeFilled,
                size: 14,
                color: context.ybColors.star,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneChip extends StatelessWidget {
  const _DoneChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.successSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(YbIcons.checkCircleFilled, size: 16, color: colors.success),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.label.copyWith(
                color: colors.success,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
