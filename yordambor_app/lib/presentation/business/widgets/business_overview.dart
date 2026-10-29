import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/earnings_providers.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/constants/xizmat_limits.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_count_up.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/share/xizmat_share.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/domain/entities/earnings_row.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';

/// The month so far, as a reason to keep going: what was earned (counting
/// up), jobs done, the rating and the requests waiting for a reply.
class BusinessEarningsCard extends ConsumerWidget {
  const BusinessEarningsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final now = DateTime.now();
    final rows =
        ref.watch(earningsRowsProvider).valueOrNull ?? const <EarningsRow>[];
    final month = rows
        .where(
          (row) =>
              row.recordedAt.year == now.year &&
              row.recordedAt.month == now.month,
        )
        .fold<double>(0, (sum, row) => sum + row.amount);
    final stats = ref.watch(providerGrowthProvider).valueOrNull?.stats;
    final waiting = ref.watch(
      dealActivityProvider.select(
        (activity) => activity
            .where(
              (item) =>
                  item.kind == DealActivityKind.yourTurn && item.deal.iProvide,
            )
            .length,
      ),
    );
    final languageCode = strings.languageCode;
    const onHero = Colors.white;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.tealInk, colors.teal],
        ),
        boxShadow: AppElevation.card(context),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(YbIcons.paymentsFilled, color: onHero, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    strings.businessEarningsTitle,
                    style: AppTypography.label.copyWith(
                      color: onHero.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            // The month's total is a hero number (manual V-04).
            YbCountUp(
              value: month,
              format: (value) => formatMoney(
                value.roundToDouble(),
                'UZS',
                languageCode: languageCode,
              ),
              style: AppTypography.largeTitle.copyWith(color: onHero),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _HeroStat(
                  icon: YbIcons.taskAltFilled,
                  value: '${stats?.completedJobs ?? 0}',
                  label: strings.statJobsDone(stats?.completedJobs ?? 0),
                ),
                _HeroStat(
                  icon: YbIcons.starFilled,
                  value: stats != null && stats.hasRating
                      ? formatRating(stats.averageRating, languageCode)
                      : '—',
                  label: strings.statRating,
                ),
                _HeroStat(
                  icon: YbIcons.handshake,
                  value: '$waiting',
                  label: strings.businessStatWaitingLabel,
                  onTap: waiting > 0
                      ? () => context.push('/notifications')
                      : null,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: onHero,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => context.push('/earnings'),
                icon: const Icon(YbIcons.chevronRight, size: 18),
                label: Text(strings.businessEarningsSee),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One number on the earnings card, in a translucent pill.
class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const onHero = Colors.white;
    final pill = DecoratedBox(
      decoration: BoxDecoration(
        color: onHero.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: onHero),
            const SizedBox(width: 6),
            Text(
              value,
              style: AppTypography.tabular(
                AppTypography.headline.copyWith(color: onHero),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: onHero.withValues(alpha: 0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (onTap == null) return pill;
    return Semantics(
      button: true,
      child: GestureDetector(onTap: onTap, child: pill),
    );
  }
}

/// "Get more clients": the few things that most often bring requests, each
/// ticked off once done, each one tap from being done.
class BusinessNextSteps extends ConsumerWidget {
  const BusinessNextSteps({super.key, required this.services});

  final List<XizmatFeedItem> services;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    if (services.isEmpty) return const SizedBox.shrink();

    XizmatFeedItem? firstWhereNot(bool Function(XizmatFeedItem) ok) {
      for (final item in services) {
        if (!ok(item)) return item;
      }
      return null;
    }

    bool hasPhotos(XizmatFeedItem item) => item.galleryUrls.length >= 3;
    bool hasPrice(XizmatFeedItem item) =>
        item.pricingModel != XizmatPricingModel.negotiable &&
        (item.basePrice ?? 0) > 0;
    bool showsAvailability(XizmatFeedItem item) => item.availabilityVisible;

    final needPhotos = firstWhereNot(hasPhotos);
    final needPrice = firstWhereNot(hasPrice);
    final needAvailability = firstWhereNot(showsAvailability);
    final done = [needPhotos, needPrice, needAvailability]
        .where((item) => item == null)
        .length;
    final first = services.first;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(YbIcons.trendingUp, color: colors.teal, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    strings.businessNextStepsTitle,
                    style: AppTypography.headline.copyWith(color: colors.ink),
                  ),
                ),
                Text(
                  strings.businessNextStepsProgress(done, 3),
                  style: AppTypography.label.copyWith(color: colors.ink2),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: done / 3,
                minHeight: 6,
                backgroundColor: colors.surface2,
                color: colors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _StepRow(
              done: needPhotos == null,
              title: strings.businessStepPhotos,
              why: strings.businessStepPhotosWhy,
              onTap: needPhotos == null
                  ? null
                  : () => context.push('/xizmat/${needPhotos.id}/manage'),
            ),
            _StepRow(
              done: needPrice == null,
              title: strings.businessStepPrice,
              why: strings.businessStepPriceWhy,
              onTap: needPrice == null
                  ? null
                  : () => context.push('/xizmat/${needPrice.id}/manage'),
            ),
            _StepRow(
              done: needAvailability == null,
              title: strings.businessStepAvailability,
              why: strings.businessStepAvailabilityWhy,
              onTap: needAvailability == null
                  ? null
                  : () =>
                      context.push('/xizmat/${needAvailability.id}/manage'),
            ),
            _StepRow(
              done: false,
              action: true,
              title: strings.businessStepShare,
              why: strings.businessStepShareWhy,
              onTap: () => XizmatShare.share(
                strings: strings,
                xizmatId: first.id,
                xizmatName: first.serviceDisplayName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.done,
    required this.title,
    required this.why,
    this.onTap,
    this.action = false,
  });

  final bool done;
  final String title;
  final String why;
  final VoidCallback? onTap;

  /// Something to do any time (sharing), not a box to tick.
  final bool action;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final icon = action
        ? YbIcons.share
        : done
            ? YbIcons.checkCircleFilled
            : YbIcons.radioButtonUnchecked;
    final iconColor = done ? colors.success : colors.teal;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body.copyWith(
                      color: done ? colors.ink2 : colors.ink,
                      fontWeight: FontWeight.w600,
                      decoration: done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    why,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(YbIcons.chevronRight, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

/// No services yet: what selling here looks like, in three steps, and the
/// one button to start.
class BusinessStartSelling extends ConsumerWidget {
  const BusinessStartSelling({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.tealSoft,
                Color.lerp(colors.tealSoft, colors.teal, 0.15)!,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSpacing.sm + 2),
                        child: Icon(
                          YbIcons.handshake,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        strings.businessEmptyTitle,
                        style: AppTypography.title.copyWith(
                          color: colors.tealInk,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  strings.businessEmptyBody,
                  style: AppTypography.bodyRegular.copyWith(
                    color: colors.tealInk.withValues(alpha: 0.8),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _StartStep(
          number: 1,
          icon: YbIcons.editNote,
          label: strings.businessStartStep1,
          colors: colors,
        ),
        const SizedBox(height: AppSpacing.sm),
        _StartStep(
          number: 2,
          icon: YbIcons.addPhotoAlternate,
          label: strings.businessStartStep2,
          colors: colors,
        ),
        const SizedBox(height: AppSpacing.sm),
        _StartStep(
          number: 3,
          icon: YbIcons.handshake,
          label: strings.businessStartStep3,
          colors: colors,
        ),
        const SizedBox(height: AppSpacing.lg),
        YbPrimaryButton(
          label: strings.createXizmat,
          icon: YbIcons.addFilled,
          onPressed: onCreate,
        ),
      ],
    );
  }
}

class _StartStep extends StatelessWidget {
  const _StartStep({
    required this.number,
    required this.icon,
    required this.label,
    required this.colors,
  });

  final int number;
  final IconData icon;
  final String label;
  final YbThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
        border: Border.all(color: colors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: colors.teal,
              child: Text(
                '$number',
                style: AppTypography.label.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(icon, size: 20, color: colors.ink2),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(color: colors.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "My services · 2 of 5", with the add button while there is room.
class BusinessServicesHeader extends ConsumerWidget {
  const BusinessServicesHeader({
    super.key,
    required this.count,
    required this.onCreate,
  });

  final int count;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final full = count >= XizmatLimits.maxPerAccount;

    return Row(
      children: [
        Expanded(
          child: Text(
            strings.businessServicesCount(count, XizmatLimits.maxPerAccount),
            style: AppTypography.headline.copyWith(color: colors.ink),
          ),
        ),
        if (!full)
          TextButton.icon(
            onPressed: onCreate,
            icon: const Icon(YbIcons.addFilled, size: 18),
            label: Text(strings.actionAdd),
          ),
      ],
    );
  }
}
