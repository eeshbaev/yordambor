import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/network/yb_image_cache.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

class YbXizmatCard extends StatefulWidget {
  const YbXizmatCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.providerTypeLabel,
    required this.sectorLine,
    required this.completedLabel,
    this.priceLabel,
    this.availabilityLabel,
    this.availabilityTone,
    this.servicePromise,
    this.onOwnerTap,
    this.onShare,
    this.shareTooltip,
  });

  final XizmatFeedItem item;
  final bool isFavorite;
  final VoidCallback onTap;
  final Future<bool> Function() onFavoriteToggle;
  final String providerTypeLabel;
  final String sectorLine;
  final String completedLabel;
  final String? priceLabel;
  final String? availabilityLabel;
  final YbStatusTone? availabilityTone;
  final String? servicePromise;
  final VoidCallback? onOwnerTap;
  final VoidCallback? onShare;
  final String? shareTooltip;

  @override
  State<YbXizmatCard> createState() => _YbXizmatCardState();
}

class _YbXizmatCardState extends State<YbXizmatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartController;
  late final Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: AppMotion.normal,
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _heartController,
      curve: AppMotion.standard,
    ));
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    final wasFavorite = widget.isFavorite;
    final isFavorite = await widget.onFavoriteToggle();
    if (!mounted || isFavorite == wasFavorite) return;
    AppHaptics.favorite(isFavorite);
    _heartController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final colors = context.ybColors;
    final categoryIcon = CategoryIcons.forService(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: YbScaleTap(
        onTap: widget.onTap,
        hitTestBehavior: HitTestBehavior.deferToChild,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colors.borderSubtle),
            boxShadow: AppElevation.card(context),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      YbNetworkImage(
                        key: ValueKey(
                          'xizmat-hero-${item.id}-${item.heroImageUrl}',
                        ),
                        url: item.heroImageUrl,
                        width:
                            MediaQuery.sizeOf(context).width - AppSpacing.lg * 2,
                        placeholderIcon: categoryIcon,
                        errorIcon: categoryIcon,
                      ),
                      if (widget.availabilityLabel != null &&
                          widget.availabilityTone != null)
                        Positioned(
                          left: AppSpacing.md,
                          bottom: AppSpacing.md,
                          child: _HeroAvailabilityBadge(
                            label: widget.availabilityLabel!,
                            tone: widget.availabilityTone!,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.showsOwnerProfile) ...[
                        InkWell(
                          onTap: widget.onOwnerTap,
                          borderRadius: BorderRadius.circular(24),
                          child: _OwnerAvatar(
                            name: item.displayOwnerName,
                            avatarUrl: item.ownerAvatarUrl,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.feedCardTitle,
                              style: AppTypography.headline.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            if (item.showsOwnerNameLine) ...[
                              const SizedBox(height: AppSpacing.xs),
                              InkWell(
                                onTap: widget.onOwnerTap,
                                child: Text(
                                  item.displayOwnerName,
                                  style: AppTypography.caption.copyWith(
                                    color: widget.onOwnerTap != null
                                        ? AppColors.primary
                                        : colors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              widget.sectorLine,
                              style: AppTypography.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            if (item.hasServiceCity) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: colors.textSecondary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Expanded(
                                    child: Text(
                                      item.serviceCity!.trim(),
                                      style: AppTypography.caption.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primaryMuted,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.chip),
                              ),
                              child: Text(
                                widget.providerTypeLabel,
                                style: AppTypography.label.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            if (widget.priceLabel != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                widget.priceLabel!,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                            if (widget.servicePromise != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                '"${widget.servicePromise!}"',
                                style: AppTypography.caption.copyWith(
                                  color: colors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 18,
                                  color: AppColors.star,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  item.rating.toStringAsFixed(1),
                                  style: AppTypography.caption.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  '· ${widget.completedLabel}',
                                  style: AppTypography.caption.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.onShare != null)
                            IconButton(
                              icon: Icon(
                                Icons.share_outlined,
                                color: colors.textSecondary,
                              ),
                              tooltip: widget.shareTooltip,
                              onPressed: widget.onShare,
                            ),
                          ScaleTransition(
                            scale: _heartScale,
                            child: IconButton(
                              icon: Icon(
                                widget.isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: widget.isFavorite
                                    ? AppColors.error
                                    : colors.textSecondary,
                              ),
                              onPressed: _toggleFavorite,
                              tooltip: 'Saqlash',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroAvailabilityBadge extends StatelessWidget {
  const _HeroAvailabilityBadge({
    required this.label,
    required this.tone,
  });

  final String label;
  final YbStatusTone tone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconForTone(tone),
              size: 14,
              color: _accentForTone(tone),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.label.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForTone(YbStatusTone tone) => switch (tone) {
        YbStatusTone.success => Icons.check_circle_rounded,
        YbStatusTone.warning => Icons.schedule_rounded,
        YbStatusTone.primary => Icons.phone_in_talk_rounded,
        YbStatusTone.neutral => Icons.info_outline_rounded,
      };

  Color _accentForTone(YbStatusTone tone) => switch (tone) {
        YbStatusTone.success => AppColors.success,
        YbStatusTone.warning => AppColors.warning,
        YbStatusTone.primary => AppColors.primary,
        YbStatusTone.neutral => Colors.white70,
      };
}

class _OwnerAvatar extends StatelessWidget {
  const _OwnerAvatar({
    required this.name,
    this.avatarUrl,
  });

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final initial =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    final url = avatarUrl?.trim();

    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      backgroundImage: url != null && url.isNotEmpty
          ? CachedNetworkImageProvider(
              url,
              cacheManager: YbImageCache.manager,
            )
          : null,
      child: url == null || url.isEmpty
          ? Text(
              initial,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}
