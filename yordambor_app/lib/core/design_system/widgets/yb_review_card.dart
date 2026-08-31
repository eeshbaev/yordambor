import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/review.dart';

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
        : _formatRelativeDate(review.createdAt!, locale);
    final hasReply = review.providerReply != null &&
        review.providerReply!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.sheet),
        border: Border.all(color: colors.borderSubtle),
        boxShadow: AppElevation.card(context),
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
                _ReviewerAvatar(name: name),
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _RatingBadge(rating: review.rating),
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
    );
  }
}

class YbReviewsSummaryChip extends StatelessWidget {
  const YbReviewsSummaryChip({
    super.key,
    required this.reviews,
  });

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();

    final colors = context.ybColors;
    final average =
        reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
          const SizedBox(width: 4),
          Text(
            average.toStringAsFixed(1),
            style: AppTypography.caption.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            width: 1,
            height: 14,
            color: colors.border,
          ),
          Text(
            '${reviews.length}',
            style: AppTypography.caption.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewerAvatar extends StatelessWidget {
  const _ReviewerAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final palette = _avatarPalette(name);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: palette.last.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 15,
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

  static List<Color> _avatarPalette(String name) {
    const palettes = [
      [Color(0xFF0D9488), Color(0xFF14B8A6)],
      [Color(0xFF6366F1), Color(0xFF818CF8)],
      [Color(0xFFEC4899), Color(0xFFF472B6)],
      [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      [Color(0xFF0891B2), Color(0xFF22D3EE)],
    ];
    final index = name.codeUnits.fold<int>(0, (sum, c) => sum + c) %
        palettes.length;
    return palettes[index];
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

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
        color: AppColors.star.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(
          color: AppColors.star.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 15, color: AppColors.star),
          const SizedBox(width: 3),
          Text(
            '$rating',
            style: AppTypography.caption.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
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
        color: colors.primaryMuted,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppRadius.card),
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
                          Icons.reply_rounded,
                          size: 16,
                          color: AppColors.primary.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            label,
                            style: AppTypography.label.copyWith(
                              color: AppColors.primaryDark,
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

String _formatRelativeDate(DateTime date, Locale locale) {
  final now = DateTime.now();
  final local = date.toLocal();
  final diff = now.difference(local);
  final days = diff.inDays;
  final lang = locale.languageCode;

  if (days <= 0) {
    return switch (lang) {
      'ru' => 'Сегодня',
      'uz' => 'Bugun',
      _ => 'Today',
    };
  }
  if (days == 1) {
    return switch (lang) {
      'ru' => 'Вчера',
      'uz' => 'Kecha',
      _ => 'Yesterday',
    };
  }
  if (days < 7) {
    return switch (lang) {
      'ru' => '$days дн. назад',
      'uz' => '$days kun oldin',
      _ => '$days days ago',
    };
  }
  if (days < 30) {
    final weeks = days ~/ 7;
    return switch (lang) {
      'ru' => weeks == 1 ? '1 нед. назад' : '$weeks нед. назад',
      'uz' => weeks == 1 ? '1 hafta oldin' : '$weeks hafta oldin',
      _ => weeks == 1 ? '1 week ago' : '$weeks weeks ago',
    };
  }

  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = local.year;
  return '$day.$month.$year';
}
