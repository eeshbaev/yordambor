import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_info_tag.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/design_system/widgets/yb_provider_type_mark.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/utils/founding_providers.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/calendar/widgets/service_availability_sheet.dart';
import 'package:yordambor/presentation/growth/provider_progress_section.dart';

/// Owner-facing service listing card on Business → Services.
class BusinessServiceCard extends ConsumerWidget {
  const BusinessServiceCard({
    super.key,
    required this.item,
    this.showProviderProgress = false,
  });

  final XizmatFeedItem item;
  final bool showProviderProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final availability = xizmatAvailabilityDisplay(item, strings);
    final priceLabel = xizmatPricingLabel(item, strings);
    final imageUrl = item.galleryUrls.isNotEmpty ? item.galleryUrls.first : '';
    final categoryIcon = CategoryIcons.forService(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
    );
    final cityLabel = item.hasServiceCity
        ? strings.serviceCityLabel(item.serviceCity!)
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colors.borderSubtle),
          boxShadow: AppElevation.card(context),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Hero(
                  imageUrl: imageUrl,
                  categoryIcon: categoryIcon,
                  onManage: () => context.push('/xizmat/${item.id}/manage'),
                  manageTooltip: strings.xizmatEditTitle,
                  isInstitution: item.providerType == 'institution',
                  providerTypeLabel: strings.providerTypeLabel(
                    item.providerType,
                  ),
                ),
                InkWell(
                  onTap: () => context.push('/xizmat/${item.id}'),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The same tags clients see: trade in teal, city
                        // in violet with a pin; then who gives it.
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            YbInfoTag(
                              icon: categoryIcon,
                              label: item.subcategoryLabel,
                              tone: YbInfoTone.service,
                            ),
                            if (cityLabel != null)
                              YbInfoTag(
                                icon: YbIcons.locationOnFilled,
                                label: cityLabel,
                                tone: YbInfoTone.place,
                              ),
                            YbInfoTag(
                              icon: item.providerType == 'institution'
                                  ? YbIcons.apartmentFilled
                                  : YbIcons.personFilled,
                              label: strings.providerTypeLabel(
                                item.providerType,
                              ),
                            ),
                            if (FoundingProviders.isFounding(item))
                              YbInfoTag(
                                icon: YbIcons.militaryTechFilled,
                                label: strings.foundingBadge,
                                tone: YbInfoTone.founding,
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          item.serviceDisplayName,
                          style: AppTypography.title.copyWith(
                            color: colors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          strings.sectorLine(
                            item.categoryLabel,
                            item.subcategoryLabel,
                          ),
                          style: AppTypography.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Icon(
                              YbIcons.starFilled,
                              size: 18,
                              color: context.ybColors.apricotInk,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.rating.toStringAsFixed(1),
                              style: AppTypography.label.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Icon(
                              YbIcons.checkCircle,
                              size: 16,
                              color: colors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                strings.xizmatCompletedCount(item.completedCount),
                                style: AppTypography.caption.copyWith(
                                  color: colors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          priceLabel,
                          style: AppTypography.headline.copyWith(
                            color: context.ybColors.teal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (showProviderProgress) ...[
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                    color: colors.borderSubtle,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      0,
                    ),
                    child: ProviderProgressSection(
                      embedded: true,
                      showAchievements: false,
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    showProviderProgress ? AppSpacing.sm : AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: availability != null
                                ? _toneColor(
                                    context,
                                    availability.tone,
                                  )
                                : context.ybColors.teal,
                            side: BorderSide(color: colors.border),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.sm,
                            ),
                            minimumSize: const Size(0, AppTouch.minTarget),
                          ),
                          onPressed: () => showServiceAvailabilitySheet(
                            context,
                            ref,
                            item: item,
                          ),
                          icon: Icon(
                            availability != null
                                ? YbIcons.boltFilled
                                : YbIcons.scheduleFilled,
                            size: 18,
                          ),
                          label: Text(
                            availability?.label ?? strings.profileSetAvailability,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.ybColors.teal,
                          side: BorderSide(color: colors.border),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          minimumSize: const Size(0, AppTouch.minTarget),
                        ),
                        onPressed: () =>
                            context.push('/xizmat/${item.id}/manage'),
                        icon: const Icon(YbIcons.tuneFilled, size: 18),
                        label: Text(strings.xizmatEditTitle),
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

Color _toneColor(BuildContext context, YbStatusTone tone) {
  final colors = context.ybColors;
  return switch (tone) {
    YbStatusTone.success => colors.success,
    YbStatusTone.warning => colors.apricotInk,
    YbStatusTone.primary => colors.teal,
    YbStatusTone.neutral => colors.ink2,
  };
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.imageUrl,
    required this.categoryIcon,
    required this.onManage,
    required this.manageTooltip,
    required this.isInstitution,
    required this.providerTypeLabel,
  });

  final String imageUrl;
  final IconData categoryIcon;
  final VoidCallback onManage;
  final String manageTooltip;

  /// The owner sees the same mark clients see on the photo.
  final bool isInstitution;
  final String providerTypeLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return AspectRatio(
      aspectRatio: 2.15,
      child: Stack(
        fit: StackFit.expand,
        children: [
          YbNetworkImage(
            url: imageUrl,
            placeholderIcon: categoryIcon,
            errorIcon: categoryIcon,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            start: AppSpacing.md,
            bottom: AppSpacing.md,
            child: YbProviderTypeMark(
              isInstitution: isInstitution,
              label: providerTypeLabel,
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Material(
              color: colors.surfaceElevated.withValues(alpha: 0.92),
              elevation: 2,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: manageTooltip,
                icon: Icon(YbIcons.edit, color: colors.textPrimary),
                onPressed: onManage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
