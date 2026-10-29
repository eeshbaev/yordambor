import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_semantics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_info_tag.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

/// A request for help: one story per card (manual K-03). What is needed,
/// the facts to scan (budget, date, length) and who asks; the reply is one
/// compact "Yordam bor" beside the asker. The need side speaks in apricot.
/// A screen reader says the request as one sentence (manual A-02).
class YbJobPostCard extends StatelessWidget {
  const YbJobPostCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.sectorLine,
    required this.yordamBorLabel,
    this.durationLabel,
    this.onYordamBor,
    this.onAuthorTap,
    this.phoneHiddenLabel,
    this.compact = true,
    this.selected = false,
    this.cityLabel,
    this.sampleLabel,
    this.priceLabel,
  });

  final YordamKerakFeedItem item;
  final VoidCallback onTap;
  final String sectorLine;
  final String yordamBorLabel;
  final String Function(int minutes)? durationLabel;
  final VoidCallback? onYordamBor;
  final VoidCallback? onAuthorTap;

  /// Shown on the full request only.
  final String? phoneHiddenLabel;

  /// In feeds the message stops at three lines; the request page shows it
  /// all.
  final bool compact;

  /// Open in the detail pane beside the list (wide windows): a teal ring.
  final bool selected;

  /// Where the help is needed, on its own violet tag with a pin.
  final String? cityLabel;

  /// "Sample": a bundled example, not a real request. Its own tag, after
  /// the trade and city.
  final String? sampleLabel;

  /// The price with its unit ("50 000 soʻm/day"); defaults to the bare
  /// amount.
  final String? priceLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final message = item.message?.trim() ?? '';
    final showsPhoneNote = !compact &&
        item.contactPhone != null &&
        item.contactPhone!.trim().isNotEmpty &&
        phoneHiddenLabel != null;
    final dateLabel =
        item.startDate == null ? null : _formatDate(item.startDate!);
    final durationText = item.durationMinutes == null
        ? null
        : durationLabel != null
            ? durationLabel!(item.durationMinutes!)
            : '${item.durationMinutes} min';
    final price = priceLabel ?? item.priceLabel;
    final authorIsLink = onAuthorTap != null;
    final sentence = ybSentence([
      sectorLine,
      cityLabel,
      sampleLabel,
      item.title,
      message,
      if (showsPhoneNote) phoneHiddenLabel,
      price,
      dateLabel,
      durationText,
      if (!authorIsLink) item.authorName,
    ]);
    // With large text the reply drops under the asker, full width.
    final stackFooter = MediaQuery.textScalerOf(context).scale(14) / 14 > 1.3;

    final trade = item.subcategoryLabel.trim().isNotEmpty
        ? item.subcategoryLabel
        : sectorLine;
    final story = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // What and where, each on its own tag: the trade in the need's
        // apricot, the city in violet with a pin.
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            YbInfoTag(
              icon: CategoryIcons.forService(
                categoryId: item.categoryId,
                subcategoryId: item.subcategoryId,
              ),
              label: trade,
              tone: YbInfoTone.request,
            ),
            if (cityLabel != null)
              YbInfoTag(
                icon: YbIcons.locationOnFilled,
                label: cityLabel!,
                tone: YbInfoTone.place,
              ),
            if (sampleLabel != null)
              YbInfoTag(icon: YbIcons.info, label: sampleLabel!),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          item.title,
          maxLines: compact ? 2 : null,
          overflow: compact ? TextOverflow.ellipsis : null,
          style: AppTypography.headline.copyWith(color: colors.ink),
        ),
        if (message.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            maxLines: compact ? 3 : null,
            overflow: compact ? TextOverflow.ellipsis : null,
            style: compact
                ? AppTypography.body.copyWith(color: colors.ink2)
                : AppTypography.bodyRegular.copyWith(color: colors.ink2),
          ),
        ],
        if (showsPhoneNote) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            phoneHiddenLabel!,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ],
        if (price != null ||
            dateLabel != null ||
            durationText != null) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (price != null)
                YbInfoTag(
                  icon: YbIcons.paymentsFilled,
                  label: price,
                  tone: YbInfoTone.money,
                  strong: true,
                ),
              if (dateLabel != null)
                YbInfoTag(icon: YbIcons.calendarToday, label: dateLabel),
              if (durationText != null)
                YbInfoTag(icon: YbIcons.schedule, label: durationText),
            ],
          ),
        ],
      ],
    );

    final asker = ExcludeSemantics(
      // A link of its own; otherwise part of the sentence.
      excluding: !authorIsLink,
      child: _Asker(name: item.authorName, onTap: onAuthorTap),
    );
    // Tonal, not filled: a feed shows many cards, and a screen gets one
    // filled accent button at most.
    final reply = onYordamBor == null
        ? null
        : YbPrimaryButton(
            label: yordamBorLabel,
            icon: YbIcons.handshake,
            tone: YbButtonTone.tonal,
            height: AppTouch.buttonHeightSmall,
            expand: stackFooter,
            onPressed: onYordamBor,
          );
    final Widget footer;
    if (reply == null) {
      footer = asker;
    } else if (stackFooter) {
      footer = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [asker, const SizedBox(height: AppSpacing.sm), reply],
      );
    } else {
      footer = Row(
        children: [
          Expanded(child: asker),
          const SizedBox(width: AppSpacing.sm),
          reply,
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      // One node that reads the request as a sentence and opens it; the
      // asker link and "Yordam bor" are its children.
      child: Semantics(
        container: true,
        button: true,
        selected: selected,
        label: sentence,
        onTap: onTap,
        child: YbScaleTap(
          onTap: onTap,
          excludeFromSemantics: true,
          hitTestBehavior: HitTestBehavior.deferToChild,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: selected
                  ? Border.all(color: colors.teal, width: 2)
                  : isDark
                      ? Border.all(color: colors.borderSubtle)
                      : null,
              boxShadow: isDark ? null : AppElevation.card(context),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ExcludeSemantics(child: story),
                  const SizedBox(height: AppSpacing.md),
                  footer,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _Asker extends StatelessWidget {
  const _Asker({required this.name, this.onTap});

  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: colors.apricotSoft,
          child: Text(
            initial,
            style: AppTypography.label.copyWith(
              color: colors.apricotInk,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              color: colors.ink2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
    if (onTap == null) {
      return Align(alignment: AlignmentDirectional.centerStart, child: row);
    }
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Semantics(
        container: true,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: row,
          ),
        ),
      ),
    );
  }
}
