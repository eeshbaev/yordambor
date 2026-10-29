import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_semantics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/review.dart';

/// One review: who, the stars, when, what they said and the reply. A
/// screen reader says it as one sentence (manual A-02).
class YbReviewCard extends StatelessWidget {
  const YbReviewCard({
    super.key,
    required this.review,
    required this.strings,
    this.clientFallbackName,
  });

  final Review review;
  final AppStrings strings;
  final String? clientFallbackName;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final locale = Localizations.localeOf(context);
    final name =
        review.reviewerName ?? clientFallbackName ?? strings.xizmatClientLabel;
    final dateLabel = review.createdAt == null
        ? null
        : formatReviewDate(review.createdAt!, locale);
    final hasReply = review.providerReply != null &&
        review.providerReply!.trim().isNotEmpty;
    final sentence = ybSentence([
      name,
      strings.a11yStarRating(review.rating),
      dateLabel,
      review.comment,
      if (hasReply)
        '${strings.reviewProviderReplyLabel}: ${review.providerReply!.trim()}',
    ]);

    return Semantics(
      container: true,
      label: sentence,
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Theme.of(context).brightness == Brightness.dark
              ? Border.all(color: colors.borderSubtle)
              : null,
          boxShadow: Theme.of(context).brightness == Brightness.dark
              ? null
              : AppElevation.card(context),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YbReviewerAvatar(name: name),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTypography.body.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (dateLabel != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            dateLabel,
                            style: AppTypography.caption.copyWith(
                              color: colors.textTertiary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  YbRatingBadge(rating: review.rating),
                ],
              ),
            ),
            if (review.comment != null && review.comment!.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  hasReply ? AppSpacing.md : AppSpacing.lg,
                ),
                child: Text(
                  review.comment!,
                  style: AppTypography.bodyRegular.copyWith(
                    color: colors.textPrimary,
                    height: 1.55,
                  ),
                ),
              ),
            if (hasReply)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: _ProviderReplyBlock(
                  label: strings.reviewProviderReplyLabel,
                  reply: review.providerReply!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The reviewer's initials on an apricot circle.
class YbReviewerAvatar extends StatelessWidget {
  const YbReviewerAvatar({super.key, required this.name, this.size = 44});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    // Reviews come from the people who asked for help: the apricot voice.
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.apricotSoft,
          shape: BoxShape.circle,
        ),
        // Like CircleAvatar: initials stay inside the circle at any text
        // size.
        child: Center(
          child: MediaQuery.withNoTextScaling(
            child: Text(
              _initials(name),
              style: AppTypography.caption.copyWith(
                color: colors.apricotInk,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.34,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

/// One review's stars: a gold star and the number.
class YbRatingBadge extends StatelessWidget {
  const YbRatingBadge({super.key, required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: context.ybColors.star.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(
          color: context.ybColors.star.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(YbIcons.starFilled, size: 15, color: context.ybColors.star),
          const SizedBox(width: 3),
          Text(
            '$rating',
            style: AppTypography.caption.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderReplyBlock extends StatelessWidget {
  const _ProviderReplyBlock({
    required this.label,
    required this.reply,
  });

  final String label;
  final String reply;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.tealSoft,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: context.ybColors.teal,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppRadius.field),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          YbIcons.replyFilled,
                          size: 16,
                          color: context.ybColors.teal.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            label,
                            style: AppTypography.label.copyWith(
                              color: context.ybColors.tealInk,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      reply,
                      style: AppTypography.bodyRegular.copyWith(
                        color: colors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Today", "3 days ago", "2 weeks ago", then the date.
String formatReviewDate(DateTime date, Locale locale) {
  final now = DateTime.now();
  final local = date.toLocal();
  final diff = now.difference(local);
  final days = diff.inDays;
  final lang = locale.languageCode;

  if (days <= 0) {
    return switch (lang) {
      'ru' => 'Сегодня',
      'uz' => 'Bugun',
      'zh' => '今天',
      _ => 'Today',
    };
  }
  if (days == 1) {
    return switch (lang) {
      'ru' => 'Вчера',
      'uz' => 'Kecha',
      'zh' => '昨天',
      _ => 'Yesterday',
    };
  }
  if (days < 7) {
    return switch (lang) {
      'ru' => '$days дн. назад',
      'uz' => '$days kun oldin',
      'zh' => '$days 天前',
      _ => '$days days ago',
    };
  }
  if (days < 30) {
    final weeks = days ~/ 7;
    return switch (lang) {
      'ru' => weeks == 1 ? '1 нед. назад' : '$weeks нед. назад',
      'uz' => weeks == 1 ? '1 hafta oldin' : '$weeks hafta oldin',
      'zh' => '$weeks 周前',
      _ => weeks == 1 ? '1 week ago' : '$weeks weeks ago',
    };
  }

  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = local.year;
  return '$day.$month.$year';
}
