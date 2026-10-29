import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_dotted_line.dart';
import 'package:yordambor/core/design_system/widgets/yb_section_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/domain/entities/review.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

/// The three things a client looks for first, side by side in one frame:
/// how the service is rated, how many jobs it has done, what it costs. Each
/// is a figure with a word under it, so it is read at a glance.
class XizmatKeyStats extends StatelessWidget {
  const XizmatKeyStats({
    super.key,
    required this.item,
    required this.strings,
    required this.summary,
    this.onRatingTap,
  });

  final XizmatFeedItem item;
  final AppStrings strings;

  /// All of the service's ratings; null while they load.
  final RatingSummary? summary;

  /// Goes to the reviews.
  final VoidCallback? onRatingTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final language = strings.languageCode;
    final summary = this.summary;

    // From all reviews once they are in; until then, the stored rating.
    final average = summary?.average ?? item.rating;
    final rated = summary == null ? item.rating > 0 : summary.total > 0;
    final ratingValue = rated
        ? formatRating(average, language)
        : item.completedCount > 0
        ? '—'
        : strings.xizmatCardNew;
    final ratingLabel = summary == null
        ? strings.statRating
        : summary.total > 0
        ? strings.reviewsCount(summary.total)
        : strings.xizmatStatNoReviews;
    final price = xizmatPriceParts(item, strings);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: dark ? Border.all(color: colors.borderSubtle) : null,
        boxShadow: AppElevation.card(context),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Stat(
                  icon: rated ? YbIcons.starFilled : YbIcons.star,
                  iconColor: colors.star,
                  value: ratingValue,
                  label: ratingLabel,
                  onTap: rated ? onRatingTap : null,
                ),
              ),
              _Rule(color: colors.line),
              Expanded(
                child: _Stat(
                  icon: YbIcons.taskAltFilled,
                  iconColor: colors.success,
                  value: groupThousands(
                    item.completedCount,
                    languageCode: language,
                  ),
                  label: strings.statJobsDone(item.completedCount),
                ),
              ),
              _Rule(color: colors.line),
              Expanded(
                child: _Stat(
                  icon: YbIcons.paymentsFilled,
                  iconColor: colors.teal,
                  value: price.value,
                  label: price.unit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: SizedBox(width: 1, child: ColoredBox(color: color)),
    );
  }
}

/// A figure with its icon, and a word under it.
class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Long figures ("1 500 000 soʻm") shrink rather than wrap.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 19, color: iconColor),
                const SizedBox(width: 5),
                Text(
                  value,
                  maxLines: 1,
                  style: AppTypography.tabular(
                    AppTypography.headline.copyWith(
                      color: colors.ink,
                      fontSize: 18,
                      height: 24 / 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.label.copyWith(color: colors.ink2),
          ),
        ],
      ),
    );

    return MergeSemantics(
      child: Semantics(
        button: onTap != null,
        child: onTap == null
            ? content
            : Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: content,
                ),
              ),
      ),
    );
  }
}

/// The description, cut to a few lines with "Batafsil" to open the rest:
/// the short version for scanning, the whole text for those who want it.
class XizmatAboutSection extends StatefulWidget {
  const XizmatAboutSection({
    super.key,
    required this.text,
    required this.strings,
    this.collapsedLines = 4,
  });

  final String text;
  final AppStrings strings;
  final int collapsedLines;

  @override
  State<XizmatAboutSection> createState() => _XizmatAboutSectionState();
}

class _XizmatAboutSectionState extends State<XizmatAboutSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final style = AppTypography.bodyRegular.copyWith(color: colors.ink);

    return YbSectionCard(
      icon: YbIcons.descriptionFilled,
      title: widget.strings.xizmatAboutTitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Whether the text runs past the cut at this width and text size.
          final painter = TextPainter(
            text: TextSpan(text: widget.text, style: style),
            maxLines: widget.collapsedLines,
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout(maxWidth: constraints.maxWidth);
          final long = painter.didExceedMaxLines;
          painter.dispose();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: Text(
                  widget.text,
                  style: style,
                  maxLines: _open || !long ? null : widget.collapsedLines,
                  overflow: _open || !long ? null : TextOverflow.ellipsis,
                ),
              ),
              if (long)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: TextButton.icon(
                    onPressed: () => setState(() => _open = !_open),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      foregroundColor: colors.teal,
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: Icon(
                      _open ? YbIcons.expandLess : YbIcons.expandMore,
                      size: 20,
                    ),
                    label: Text(
                      _open
                          ? widget.strings.actionReadLess
                          : widget.strings.actionReadMore,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// What happens after the button, in three pictures: send a request, talk
/// in the app, agree. Numbered circles on a dotted line, two words each.
class XizmatHowItWorks extends StatelessWidget {
  const XizmatHowItWorks({super.key, required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final steps = [
      (
        YbIcons.campaignFilled,
        colors.apricotSoft,
        colors.apricotInk,
        strings.xizmatHowAsk,
      ),
      (
        YbIcons.forumFilled,
        colors.tealSoft,
        colors.teal,
        strings.xizmatHowChat,
      ),
      (
        YbIcons.handshakeFilled,
        colors.successSoft,
        colors.success,
        strings.xizmatHowAgree,
      ),
    ];

    return YbSectionCard(
      icon: YbIcons.handshakeFilled,
      title: strings.xizmatHowTitle,
      child: Stack(
        children: [
          // The dotted line runs between the first and the last circle.
          Positioned(
            top: 23,
            left: 0,
            right: 0,
            child: FractionallySizedBox(
              widthFactor: 2 / 3,
              child: YbDottedLine(color: colors.line, thickness: 2, gap: 5),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (index, (icon, fill, ink, label)) in steps.indexed)
                Expanded(
                  child: Semantics(
                    label: '${index + 1}. $label',
                    excludeSemantics: true,
                    child: Column(
                      children: [
                        _StepCircle(
                          number: index + 1,
                          icon: icon,
                          fill: fill,
                          ink: ink,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: AppTypography.label.copyWith(
                              color: colors.ink,
                              fontSize: 13,
                              height: 17 / 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.number,
    required this.icon,
    required this.fill,
    required this.ink,
  });

  final int number;
  final IconData icon;
  final Color fill;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return SizedBox(
      width: 56,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
            child: Icon(icon, size: 24, color: ink),
          ),
          PositionedDirectional(
            top: -4,
            end: 0,
            child: SizedBox.square(
              dimension: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.ink,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.card, width: 2),
                ),
                child: Center(
                  child: MediaQuery.withNoTextScaling(
                    child: Text(
                      '$number',
                      style: AppTypography.label.copyWith(
                        color: colors.card,
                        fontSize: 10,
                        height: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
