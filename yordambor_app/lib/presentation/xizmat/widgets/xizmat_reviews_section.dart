import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/review_providers.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_semantics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_review_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_section_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/domain/entities/review.dart';

/// Reviews on a service page, the way people read them: the average in big
/// figures with its stars and count, how the stars split (once there are
/// enough reviews for that to mean something), the two newest reviews, and
/// all of them one tap away, where they can be narrowed by stars.
class XizmatReviewsSection extends ConsumerWidget {
  const XizmatReviewsSection({super.key, required this.xizmatId});

  final String xizmatId;

  /// Reviews shown on the page itself.
  static const _preview = 2;

  /// With fewer reviews a split by stars means little, so it is left out.
  static const _splitFrom = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final reviewsAsync = ref.watch(xizmatReviewsProvider(xizmatId));
    final stored = ref.watch(xizmatRatingSummaryProvider(xizmatId)).valueOrNull;

    final Widget body = reviewsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (_, _) => Text(
        strings.profileSectionLoadFailed,
        style: AppTypography.caption.copyWith(color: colors.error),
      ),
      data: (reviews) {
        if (reviews.isEmpty) return _NoReviews(label: strings.reviewsEmpty);

        // All ratings when they are in; else the reviews at hand.
        final summary = stored != null && stored.total > 0
            ? stored
            : RatingSummary.fromRatings(reviews.map((r) => r.rating));
        final newest = [...reviews]..sort(_newestFirst);
        final shown = newest.take(_preview).toList();
        final total = summary.total > reviews.length
            ? summary.total
            : reviews.length;

        void openAll([int? stars]) =>
            showXizmatReviewsSheet(context, xizmatId: xizmatId, stars: stars);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Summary(
              summary: summary,
              strings: strings,
              showSplit: summary.total >= _splitFrom,
              onStarsTap: openAll,
            ),
            for (final review in shown) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(height: 1, color: colors.borderSubtle),
              ),
              _ReviewPreview(review: review, strings: strings),
            ],
            if (total > shown.length) ...[
              const SizedBox(height: AppSpacing.lg),
              YbSecondaryButton(
                label: strings.reviewsSeeAll(total),
                icon: YbIcons.reviews,
                height: AppTouch.buttonHeightMedium,
                onPressed: openAll,
              ),
            ],
          ],
        );
      },
    );

    return YbSectionCard(
      icon: YbIcons.starFilled,
      tone: YbSectionTone.star,
      title: strings.reviewsTitle,
      child: body,
    );
  }
}

int _newestFirst(Review a, Review b) {
  final left = a.createdAt;
  final right = b.createdAt;
  if (left == null && right == null) return 0;
  if (left == null) return 1;
  if (right == null) return -1;
  return right.compareTo(left);
}

/// All of a service's reviews in a sheet, optionally only those with
/// [stars] stars.
Future<void> showXizmatReviewsSheet(
  BuildContext context, {
  required String xizmatId,
  int? stars,
}) {
  return showModalBottomSheet<void>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ReviewsSheet(xizmatId: xizmatId, initialStars: stars),
  );
}

class _NoReviews extends StatelessWidget {
  const _NoReviews({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final tint = ybSectionToneColors(context, YbSectionTone.star);

    return Row(
      children: [
        ExcludeSemantics(
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: tint.fill, shape: BoxShape.circle),
            child: Icon(YbIcons.rateReview, size: 22, color: tint.ink),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: colors.ink2),
          ),
        ),
      ],
    );
  }
}

/// The average large, its stars and count; with enough reviews, a bar for
/// each number of stars that opens the reviews with that many.
class _Summary extends StatelessWidget {
  const _Summary({
    required this.summary,
    required this.strings,
    required this.showSplit,
    required this.onStarsTap,
  });

  final RatingSummary summary;
  final AppStrings strings;
  final bool showSplit;
  final ValueChanged<int> onStarsTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final average = formatRating(summary.average, strings.languageCode);
    final count = strings.reviewsCount(summary.total);

    final figure = Text(
      average,
      style: AppTypography.tabular(
        AppTypography.largeTitle.copyWith(
          color: colors.ink,
          fontSize: 40,
          height: 44 / 40,
          letterSpacing: -0.6,
        ),
      ),
    );
    final stars = YbStarRow(value: summary.average, size: 16);
    final countText = Text(
      count,
      style: AppTypography.caption.copyWith(color: colors.ink2),
    );

    final headline = Semantics(
      label:
          '${strings.a11yStarRating(summary.average.round())}, $average. '
          '$count',
      excludeSemantics: true,
      child: showSplit
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                figure,
                const SizedBox(height: 2),
                stars,
                const SizedBox(height: 4),
                countText,
              ],
            )
          : Row(
              children: [
                figure,
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [stars, const SizedBox(height: 4), countText],
                ),
              ],
            ),
    );

    if (!showSplit) return headline;

    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 92),
          child: headline,
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            children: [
              for (var star = 5; star >= 1; star--)
                _StarBar(
                  stars: star,
                  count: summary.countFor(star),
                  total: summary.total,
                  label: strings.reviewsBarA11y(star, summary.countFor(star)),
                  onTap: summary.countFor(star) > 0
                      ? () => onStarsTap(star)
                      : null,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Five stars filled to [value]: whole, half or empty.
class YbStarRow extends StatelessWidget {
  const YbStarRow({super.key, required this.value, this.size = 16});

  final double value;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(
              value >= i - 0.25
                  ? YbIcons.starFilled
                  : value >= i - 0.75
                  ? YbIcons.starHalfFilled
                  : YbIcons.starFilled,
              size: size,
              color: value >= i - 0.75 ? colors.star : colors.surface3,
            ),
        ],
      ),
    );
  }
}

class _StarBar extends StatelessWidget {
  const _StarBar({
    required this.stars,
    required this.count,
    required this.total,
    required this.label,
    required this.onTap,
  });

  final int stars;
  final int count;
  final int total;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final share = total == 0 ? 0.0 : count / total;
    final figures = AppTypography.tabular(
      AppTypography.label.copyWith(color: colors.ink2),
    );

    return Semantics(
      label: label,
      button: onTap != null,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 12),
                child: Text('$stars', style: figures, textAlign: TextAlign.end),
              ),
              const SizedBox(width: 2),
              Icon(YbIcons.starFilled, size: 12, color: colors.star),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: SizedBox(
                    height: 8,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(color: colors.surface2),
                        FractionallySizedBox(
                          alignment: AlignmentDirectional.centerStart,
                          widthFactor: share,
                          child: ColoredBox(color: colors.star),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 22),
                child: Text('$count', style: figures, textAlign: TextAlign.end),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One review, short: who, when, the stars, and what they said in up to
/// four lines. The reply and the rest are in the full list.
class _ReviewPreview extends StatelessWidget {
  const _ReviewPreview({required this.review, required this.strings});

  final Review review;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final name = review.reviewerName ?? strings.xizmatClientLabel;
    final date = review.createdAt == null
        ? null
        : formatReviewDate(review.createdAt!, Localizations.localeOf(context));
    final comment = review.comment?.trim();

    return Semantics(
      container: true,
      label: ybSentence([
        name,
        strings.a11yStarRating(review.rating),
        date,
        comment,
      ]),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              YbReviewerAvatar(name: name, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body.copyWith(
                        color: colors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (date != null)
                      Text(
                        date,
                        style: AppTypography.caption.copyWith(
                          color: colors.ink3,
                          fontSize: 12,
                          height: 16 / 12,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              YbRatingBadge(rating: review.rating),
            ],
          ),
          if (comment != null && comment.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              comment,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                color: colors.ink,
                height: 22 / 15,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Every review, newest first, with chips to keep only one number of stars.
class _ReviewsSheet extends ConsumerStatefulWidget {
  const _ReviewsSheet({required this.xizmatId, this.initialStars});

  final String xizmatId;
  final int? initialStars;

  @override
  ConsumerState<_ReviewsSheet> createState() => _ReviewsSheetState();
}

class _ReviewsSheetState extends ConsumerState<_ReviewsSheet> {
  late int? _stars = widget.initialStars;

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final reviewsAsync = ref.watch(xizmatReviewsProvider(widget.xizmatId));
    final reviews = [...?reviewsAsync.valueOrNull]..sort(_newestFirst);
    final summary = RatingSummary.fromRatings(reviews.map((r) => r.rating));
    final shown = _stars == null
        ? reviews
        : reviews.where((review) => review.rating == _stars).toList();
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        strings.reviewsTitle,
                        style: AppTypography.title.copyWith(color: colors.ink),
                      ),
                    ),
                  ),
                  if (summary.total > 0) ...[
                    Icon(YbIcons.starFilled, size: 22, color: colors.star),
                    const SizedBox(width: 4),
                    Text(
                      formatRating(summary.average, strings.languageCode),
                      style: AppTypography.tabular(
                        AppTypography.title.copyWith(color: colors.ink),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '· ${summary.total}',
                      style: AppTypography.body.copyWith(color: colors.ink2),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  _StarChip(
                    label: '${strings.reviewsFilterAll} · ${summary.total}',
                    selected: _stars == null,
                    onTap: () => setState(() => _stars = null),
                  ),
                  for (var star = 5; star >= 1; star--)
                    if (summary.countFor(star) > 0 || _stars == star)
                      _StarChip(
                        star: true,
                        label: '$star · ${summary.countFor(star)}',
                        semanticsLabel: strings.reviewsBarA11y(
                          star,
                          summary.countFor(star),
                        ),
                        selected: _stars == star,
                        onTap: () => setState(() => _stars = star),
                      ),
                ],
              ),
            ),
            if (!reviewsAsync.hasValue)
              const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: !reviewsAsync.hasValue
                  ? const SizedBox.shrink()
                  : shown.isEmpty
                  ? ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      children: [
                        Text(
                          strings.reviewsFilterEmpty,
                          textAlign: TextAlign.center,
                          style: AppTypography.body.copyWith(
                            color: colors.ink2,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: controller,
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        AppSpacing.lg + bottomSafe,
                      ),
                      itemCount: shown.length,
                      itemBuilder: (context, index) =>
                          YbReviewCard(review: shown[index], strings: strings),
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// A filter chip for the reviews: "All · 7", "★ 5 · 3".
class _StarChip extends StatelessWidget {
  const _StarChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.star = false,
    this.semanticsLabel,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool star;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
      child: Semantics(
        button: true,
        selected: selected,
        label: semanticsLabel ?? label,
        excludeSemantics: true,
        child: YbScaleTap(
          onTap: () {
            AppHaptics.select();
            onTap();
          },
          child: Center(
            child: AnimatedContainer(
              duration: AppMotion.quick,
              curve: AppMotion.quickCurve,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? colors.tealSoft : colors.card,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: selected ? colors.teal : colors.line),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (star) ...[
                    Icon(YbIcons.starFilled, size: 15, color: colors.star),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    label,
                    style: AppTypography.tabular(
                      AppTypography.label.copyWith(
                        fontSize: 13,
                        height: 18 / 13,
                        color: selected ? colors.tealInk : colors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
