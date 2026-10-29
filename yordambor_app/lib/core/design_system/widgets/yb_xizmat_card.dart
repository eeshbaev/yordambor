import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_semantics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_info_tag.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/design_system/widgets/yb_photo_hero.dart';
import 'package:yordambor/core/design_system/widgets/yb_provider_type_mark.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/network/yb_image_cache.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/utils/money_format.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

/// A service in a feed: one story per card (manual K-03). The photo with the
/// heart on it; the trade and the city as two coloured tags; what the
/// service is, who gives it, the proof and the price, each with its own
/// mark.
/// The whole card opens the listing; sharing lives on the listing.
///
/// A screen reader says the card as one sentence (manual A-02), then the
/// provider link and the heart as their own controls.
class YbXizmatCard extends StatefulWidget {
  const YbXizmatCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.categoryLabel,
    required this.completedLabel,
    required this.newLabel,
    required this.saveTooltip,
    required this.unsaveTooltip,
    this.priceLabel,
    this.availabilityLabel,
    this.availabilityTone,
    this.providerLine,
    this.onOwnerTap,
    this.ratingSemantics,
    this.newSemantics,
    this.selected = false,
    this.providerTypeLabel,
    this.cityLabel,
    this.sampleLabel,
    this.foundingLabel,
    this.askLabel,
    this.onAsk,
  });

  final XizmatFeedItem item;
  final bool isFavorite;
  final VoidCallback onTap;
  final Future<bool> Function() onFavoriteToggle;

  /// The trade, on a teal tag with its icon: "Santexnik".
  final String categoryLabel;

  /// Where the service is given, on its own violet tag with a pin.
  final String? cityLabel;

  /// "Sample": a bundled example, not a real provider. Its own tag, after
  /// the trade and city.
  final String? sampleLabel;

  /// "First on YordamBor": a real service from the founding months, on a
  /// gold tag after the city.
  final String? foundingLabel;

  /// "Yordam kerak": ask this provider for help straight from the card, in
  /// the apricot of asking. Hidden on the person's own services.
  final String? askLabel;
  final VoidCallback? onAsk;

  /// "23 ta ish".
  final String completedLabel;

  /// Shown instead of a rating while the provider has none.
  final String newLabel;
  final String saveTooltip;
  final String unsaveTooltip;
  final String? priceLabel;
  final String? availabilityLabel;
  final YbStatusTone? availabilityTone;

  /// The person or company behind the service, when it is not the title.
  final String? providerLine;
  final VoidCallback? onOwnerTap;

  /// The rating in words for screen readers: "rated 4.8".
  final String Function(String rating)? ratingSemantics;

  /// [newLabel] in words for screen readers: "new on YordamBor".
  final String? newSemantics;

  /// Open in the detail pane beside the list (wide windows): a teal ring.
  final bool selected;

  /// "Tashkilot" or "Jismoniy shaxs": shown as a mark on the photo (a
  /// building or a person), so who gives the service reads at a glance.
  final String? providerTypeLabel;

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
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 60),
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
    if (!AppMotion.reduced(context)) _heartController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final colors = context.ybColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryIcon = CategoryIcons.forService(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
    );
    final tint = CategoryIcons.tint(context, item.categoryId);
    final languageCode = Localizations.localeOf(context).languageCode;
    final rating =
        item.rating > 0 ? formatRating(item.rating, languageCode) : null;
    final ownerIsLink =
        widget.providerLine != null && widget.onOwnerTap != null;
    final showsAvailability =
        widget.availabilityLabel != null && widget.availabilityTone != null;
    final isInstitution = item.providerType == 'institution';
    final sentence = ybSentence([
      item.feedCardTitle,
      widget.categoryLabel,
      widget.cityLabel,
      widget.foundingLabel,
      widget.sampleLabel,
      widget.providerTypeLabel,
      if (!ownerIsLink) widget.providerLine,
      if (rating != null) widget.ratingSemantics?.call(rating) ?? rating,
      if (item.completedCount > 0) widget.completedLabel,
      if (rating == null && item.completedCount <= 0)
        widget.newSemantics ?? widget.newLabel,
      widget.priceLabel,
      if (showsAvailability) widget.availabilityLabel,
    ]);

    final photo = AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ExcludeSemantics(
            child: YbPhotoHero(
              tag: xizmatPhotoHeroTag(item.id),
              child: YbNetworkImage(
                key: ValueKey('xizmat-hero-${item.id}-${item.heroImageUrl}'),
                url: item.heroImageUrl,
                width: MediaQuery.sizeOf(context).width - AppSpacing.lg * 2,
                placeholderIcon: categoryIcon,
                errorIcon: categoryIcon,
                placeholderColor: tint.fill,
                placeholderIconColor: tint.ink,
              ),
            ),
          ),
          if (showsAvailability)
            Positioned(
              left: AppSpacing.md,
              top: AppSpacing.md,
              child: ExcludeSemantics(
                child: _HeroAvailabilityBadge(
                  label: widget.availabilityLabel!,
                  tone: widget.availabilityTone!,
                ),
              ),
            ),
          if (widget.providerTypeLabel != null)
            PositionedDirectional(
              start: AppSpacing.md,
              bottom: AppSpacing.md,
              child: ExcludeSemantics(
                child: YbProviderTypeMark(
                  isInstitution: isInstitution,
                  label: widget.providerTypeLabel!,
                ),
              ),
            ),
          PositionedDirectional(
            end: AppSpacing.xs,
            top: AppSpacing.xs,
            child: ScaleTransition(
              scale: _heartScale,
              child: _PhotoHeart(
                saved: widget.isFavorite,
                tooltip: widget.isFavorite
                    ? widget.unsaveTooltip
                    : widget.saveTooltip,
                onPressed: _toggleFavorite,
              ),
            ),
          ),
        ],
      ),
    );

    final body = Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // What and where, each on its own tag: the trade in teal, the
          // city in violet with a pin.
          ExcludeSemantics(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                YbInfoTag(
                  icon: categoryIcon,
                  label: widget.categoryLabel,
                  tone: YbInfoTone.service,
                ),
                if (widget.cityLabel != null)
                  YbInfoTag(
                    icon: YbIcons.locationOnFilled,
                    label: widget.cityLabel!,
                    tone: YbInfoTone.place,
                  ),
                if (widget.foundingLabel != null)
                  YbInfoTag(
                    icon: YbIcons.militaryTechFilled,
                    label: widget.foundingLabel!,
                    tone: YbInfoTone.founding,
                  ),
                if (widget.sampleLabel != null)
                  YbInfoTag(
                    icon: YbIcons.info,
                    label: widget.sampleLabel!,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ExcludeSemantics(
            child: Text(
              item.feedCardTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headline.copyWith(color: colors.ink),
            ),
          ),
          if (widget.providerLine != null) ...[
            const SizedBox(height: AppSpacing.sm),
            ExcludeSemantics(
              // A link of its own; otherwise part of the sentence.
              excluding: !ownerIsLink,
              child: _ProviderRow(
                name: widget.providerLine!,
                avatarUrl: item.ownerAvatarUrl,
                isInstitution: isInstitution,
                onTap: widget.onOwnerTap,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          // Proof on the left, the price on the right; a long price (such
          // as "by agreement") moves to its own line instead of being cut.
          ExcludeSemantics(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                _Proof(
                  rating: item.rating,
                  completedCount: item.completedCount,
                  completedLabel: widget.completedLabel,
                  newLabel: widget.newLabel,
                ),
                if (widget.priceLabel != null)
                  _Price(label: widget.priceLabel!),
              ],
            ),
          ),
          if (widget.askLabel != null && widget.onAsk != null) ...[
            const SizedBox(height: AppSpacing.md),
            // Tonal, not filled: a feed shows many cards, and a screen gets
            // one filled button.
            YbPrimaryButton(
              label: widget.askLabel!,
              icon: YbIcons.campaign,
              tone: YbButtonTone.askTonal,
              height: AppTouch.buttonHeightSmall,
              onPressed: widget.onAsk,
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      // The card is one node with one tap; the heart and the provider link
      // are its children.
      child: Semantics(
        container: true,
        button: true,
        selected: widget.selected,
        label: sentence,
        onTap: widget.onTap,
        child: YbScaleTap(
          onTap: widget.onTap,
          excludeFromSemantics: true,
          hitTestBehavior: HitTestBehavior.deferToChild,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: isDark ? Border.all(color: colors.borderSubtle) : null,
              boxShadow: isDark ? null : AppElevation.card(context),
            ),
            // The selected ring is drawn over the photo, so it reads all
            // round.
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: widget.selected
                    ? Border.all(color: colors.teal, width: 2)
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [photo, body],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The heart sits on the photo, on a light disc that reads on any image.
class _PhotoHeart extends StatelessWidget {
  const _PhotoHeart({
    required this.saved,
    required this.tooltip,
    required this.onPressed,
  });

  final bool saved;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.onPhotoPill,
        minimumSize: const Size.square(40),
        fixedSize: const Size.square(40),
        padding: EdgeInsets.zero,
      ),
      icon: Icon(
        saved ? YbIcons.favoriteFilled : YbIcons.favorite,
        size: 22,
        color: saved ? colors.heart : AppColors.onPhotoInk,
      ),
    );
  }
}

class _ProviderRow extends StatelessWidget {
  const _ProviderRow({
    required this.name,
    this.avatarUrl,
    this.isInstitution = false,
    this.onTap,
  });

  final String name;
  final String? avatarUrl;
  final bool isInstitution;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _OwnerAvatar(
          name: name,
          avatarUrl: avatarUrl,
          isInstitution: isInstitution,
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
    if (onTap == null) return row;
    return Semantics(
      container: true,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: row,
        ),
      ),
    );
  }
}

/// Rating and finished jobs; a quiet "New" before there is any proof, never
/// a 0,0.
class _Proof extends StatelessWidget {
  const _Proof({
    required this.rating,
    required this.completedCount,
    required this.completedLabel,
    required this.newLabel,
  });

  final double rating;
  final int completedCount;
  final String completedLabel;
  final String newLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final languageCode = Localizations.localeOf(context).languageCode;
    final meta = AppTypography.caption.copyWith(color: colors.textSecondary);

    if (rating <= 0 && completedCount <= 0) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.tealSoft,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 3,
          ),
          child: Text(
            newLabel,
            style: AppTypography.label.copyWith(color: colors.tealInk),
          ),
        ),
      );
    }

    // The rating with its gold star, then the finished jobs with a green
    // tick: two facts, two colours.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (rating > 0) ...[
          Icon(YbIcons.starFilled, size: 18, color: colors.star),
          const SizedBox(width: 3),
          Text(
            formatRating(rating, languageCode),
            style: AppTypography.tabular(
              AppTypography.caption.copyWith(
                color: colors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        if (rating > 0 && completedCount > 0)
          const SizedBox(width: AppSpacing.md),
        if (completedCount > 0) ...[
          Icon(YbIcons.checkCircleFilled, size: 16, color: colors.success),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              completedLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: meta,
            ),
          ),
        ],
      ],
    );
  }
}

/// The price in ink with a green money mark; it wraps rather than cuts.
class _Price extends StatelessWidget {
  const _Price({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(YbIcons.paymentsFilled, size: 18, color: colors.success),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.price.copyWith(color: colors.ink),
          ),
        ),
      ],
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

  // The badge sits on a photo, so it is a light pill with ink text in
  // both themes.
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.onPhotoPill,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _dotForTone(tone),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppFonts.ui(
                size: 12.5,
                weight: FontWeight.w600,
                height: 16 / 12.5,
                color: AppColors.onPhotoInk,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _dotForTone(YbStatusTone tone) => switch (tone) {
        YbStatusTone.success => AppColors.available,
        YbStatusTone.warning => AppColors.apricot,
        YbStatusTone.primary => AppColors.brand,
        YbStatusTone.neutral => AppColors.neutralDot,
      };
}

class _OwnerAvatar extends StatelessWidget {
  const _OwnerAvatar({
    required this.name,
    this.avatarUrl,
    this.isInstitution = false,
  });

  final String name;
  final String? avatarUrl;

  /// Without a photo, an organisation shows a building in a rounded square
  /// (like its mark on the photo); a person shows their initial.
  final bool isInstitution;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final initial =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    final trimmed = avatarUrl?.trim();
    final photo = trimmed != null && trimmed.isNotEmpty ? trimmed : null;

    if (photo == null && isInstitution) {
      return Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.tealSoft,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(YbIcons.apartmentFilled, size: 15, color: colors.tealInk),
      );
    }

    return CircleAvatar(
      radius: 13,
      backgroundColor: colors.tealSoft,
      backgroundImage: photo != null
          ? CachedNetworkImageProvider(
              photo,
              cacheManager: YbImageCache.manager,
            )
          : null,
      child: photo != null
          ? null
          : Text(
              initial,
              style: AppFonts.ui(
                size: 12,
                weight: FontWeight.w700,
                height: 1,
                color: colors.tealInk,
              ),
            ),
    );
  }
}
