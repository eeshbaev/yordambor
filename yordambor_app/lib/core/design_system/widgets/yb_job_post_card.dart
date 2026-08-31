import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

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
    this.callLabel,
    this.phoneHiddenLabel,
    this.onShare,
    this.shareTooltip,
    this.compact = false,
  });

  final YordamKerakFeedItem item;
  final VoidCallback onTap;
  final String sectorLine;
  final String yordamBorLabel;
  final String Function(int minutes)? durationLabel;
  final VoidCallback? onYordamBor;
  final VoidCallback? onAuthorTap;
  final String? callLabel;
  final String? phoneHiddenLabel;
  final VoidCallback? onShare;
  final String? shareTooltip;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: YbScaleTap(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colors.borderSubtle),
            boxShadow: AppElevation.card(context),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: onAuthorTap,
                        borderRadius: BorderRadius.circular(24),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: colors.primaryMuted,
                          child: Text(
                            item.authorName.isNotEmpty
                                ? item.authorName[0].toUpperCase()
                                : '?',
                            style: AppTypography.headline.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: AppTypography.headline.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            InkWell(
                              onTap: onAuthorTap,
                              child: Text(
                                item.authorName,
                                style: AppTypography.caption.copyWith(
                                  color: onAuthorTap != null
                                      ? AppColors.primary
                                      : colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              sectorLine,
                              style: AppTypography.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onShare != null)
                        IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                            color: colors.textSecondary,
                          ),
                          tooltip: shareTooltip,
                          onPressed: () {
                            AppHaptics.selection();
                            onShare!();
                          },
                        ),
                    ],
                  ),
                  if (item.message != null && item.message!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      item.message!,
                      maxLines: compact ? 3 : 6,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyRegular.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                  if (item.contactPhone != null &&
                      item.contactPhone!.trim().isNotEmpty &&
                      phoneHiddenLabel != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      phoneHiddenLabel!,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  if (item.priceLabel != null || item.startDate != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (item.priceLabel != null)
                          _MetaChip(
                            icon: Icons.payments_outlined,
                            label: item.priceLabel!,
                          ),
                        if (item.startDate != null)
                          _MetaChip(
                            icon: Icons.calendar_today_outlined,
                            label: _formatDate(item.startDate!),
                          ),
                        if (item.durationMinutes != null)
                          _MetaChip(
                            icon: Icons.schedule_outlined,
                            label: durationLabel != null
                                ? durationLabel!(item.durationMinutes!)
                                : '${item.durationMinutes} min',
                          ),
                      ],
                    ),
                  ],
                  if (onYordamBor != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    YbPrimaryButton(
                      label: yordamBorLabel,
                      icon: Icons.handshake_outlined,
                      onPressed: onYordamBor,
                    ),
                  ],
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
