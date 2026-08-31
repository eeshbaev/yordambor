import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/public_profile_providers.dart';
import 'package:yordambor/application/providers/review_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/data/safety/report_repository.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_portfolio_gallery.dart';
import 'package:yordambor/core/design_system/widgets/yb_review_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_service_promise_quote.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/share/xizmat_share.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/kelishuv/taklif_sheet.dart';
import 'package:yordambor/presentation/profile/widgets/profile_avatar.dart';
import 'package:yordambor/presentation/safety/safety_actions_sheet.dart';
import 'package:yordambor/presentation/xizmat/widgets/xizmat_view_tracker.dart';

class XizmatProfileScreen extends ConsumerWidget {
  const XizmatProfileScreen({super.key, required this.xizmatId});

  final String xizmatId;

  static const _stickyBarHeight = 88.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final detailAsync = ref.watch(xizmatDetailProvider(xizmatId));

    return detailAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const YbSkeletonList(count: 1),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: YbEmptyState(
          icon: Icons.error_outline_rounded,
          title: strings.appName,
          subtitle: '$error',
        ),
      ),
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: YbEmptyState(
              icon: Icons.design_services_outlined,
              title: strings.homeEmptyTitle,
              subtitle: strings.homeEmptySubtitle,
            ),
          );
        }

        final currentUserId = session.user?.id;
        final isOwnXizmat =
            currentUserId != null && item.ownerId == currentUserId;
        final effectiveOwnerId = item.ownerId ?? currentUserId;
        final availability = xizmatAvailabilityDisplay(item, strings);
        final colors = context.ybColors;
        final favorites = ref.watch(favoritesProvider);
        final isFavorite = favorites.contains(item.id);

        return XizmatViewTracker(
          xizmatId: item.id,
          child: Scaffold(
            bottomNavigationBar: _ActionBar(
              isOwnXizmat: isOwnXizmat,
              effectiveOwnerId: effectiveOwnerId,
              itemName: item.name,
              itemId: item.id,
              strings: strings,
            ),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  stretch: true,
                  actions: [
                    if (!isOwnXizmat)
                      IconButton(
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? AppColors.error
                              : colors.textPrimary,
                        ),
                        tooltip: strings.tabFavorites,
                        onPressed: () =>
                            ref.read(favoritesProvider.notifier).toggle(item.id),
                      ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      tooltip: strings.shareXizmat,
                      onPressed: () => XizmatShare.share(
                        strings: strings,
                        xizmatId: item.id,
                        xizmatName: item.name,
                      ),
                    ),
                    if (item.ownerId != null &&
                        item.ownerId != session.user?.id)
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded),
                        onPressed: () => showSafetyActionsSheet(
                          context,
                          ref,
                          targetUserId: item.ownerId!,
                          targetUserName: item.name,
                          reportType: ReportTargetType.xizmat,
                          reportTargetId: item.id,
                        ),
                      ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: YbPortfolioGallery(
                      imageUrls: item.galleryUrls,
                      placeholderIcon: CategoryIcons.forService(
                        categoryId: item.categoryId,
                        subcategoryId: item.subcategoryId,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg + _stickyBarHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (availability != null) ...[
                          YbStatusBadge(
                            label: availability.label,
                            tone: availability.tone,
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        Text(
                          item.serviceDisplayName,
                          style: AppTypography.title.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          item.subcategoryLabel,
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
                                size: 16,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                item.serviceCity!.trim(),
                                style: AppTypography.caption.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          xizmatPricingLabel(item, strings),
                          style: AppTypography.body.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        if (item.visibleServicePromise != null) ...[
                          const SizedBox(height: AppSpacing.lg),
                          YbServicePromiseQuote(
                            promise: item.visibleServicePromise!,
                            strings: strings,
                          ),
                        ],
                        if (effectiveOwnerId != null) ...[
                          const SizedBox(height: AppSpacing.lg),
                          _ProviderSection(
                            ownerId: effectiveOwnerId,
                            strings: strings,
                            isSelf: isOwnXizmat,
                            fallbackName: isOwnXizmat
                                ? session.profile?.fullName
                                : null,
                            fallbackAvatarUrl: isOwnXizmat
                                ? session.profile?.avatarUrl
                                : null,
                          ),
                          _OtherServicesSection(
                            ownerId: effectiveOwnerId,
                            currentXizmatId: item.id,
                            strings: strings,
                          ),
                        ],
                        if (item.contactPhone != null &&
                            item.contactPhone!.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            strings.userProfilePhoneHidden,
                            style: AppTypography.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.star,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${item.rating.toStringAsFixed(1)} · ${strings.xizmatCompletedCount(item.completedCount)}',
                              style: AppTypography.body.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        if (item.description != null) ...[
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            item.description!,
                            style: AppTypography.bodyRegular.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xl),
                        _ReviewsSection(xizmatId: item.id),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionBar extends ConsumerWidget {
  const _ActionBar({
    required this.isOwnXizmat,
    required this.effectiveOwnerId,
    required this.itemName,
    required this.itemId,
    required this.strings,
  });

  final bool isOwnXizmat;
  final String? effectiveOwnerId;
  final String itemName;
  final String itemId;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isOwnXizmat) {
      return YbStickyActionBar(
        children: [
          if (effectiveOwnerId != null)
            YbSecondaryButton(
              label: strings.profileViewPublic,
              icon: Icons.visibility_outlined,
              onPressed: () => context.push('/user/$effectiveOwnerId'),
            ),
          if (effectiveOwnerId != null)
            const SizedBox(height: AppSpacing.sm),
          YbPrimaryButton(
            label: strings.xizmatEditTitle,
            icon: Icons.edit_outlined,
            onPressed: () => context.push('/xizmat/$itemId/manage'),
          ),
        ],
      );
    }

    return YbStickyActionBar(
      children: [
        YbPrimaryButton(
          label: strings.filterYordamKerak,
          icon: Icons.campaign_outlined,
          onPressed: () async {
            final allowed = await requireVerifiedAuth(
              context,
              ref,
              authContext: AuthContextType.yordamKerak,
            );
            if (!allowed || !context.mounted) return;
            await openTaklifFlow(
              context,
              ref,
              target: TaklifTarget.xizmat(xizmatId: itemId),
              title: strings.taklifFlowTitleYordamKerak(itemName),
            );
          },
        ),
      ],
    );
  }
}

class _ProviderSection extends ConsumerWidget {
  const _ProviderSection({
    required this.ownerId,
    required this.strings,
    this.isSelf = false,
    this.fallbackName,
    this.fallbackAvatarUrl,
  });

  final String ownerId;
  final AppStrings strings;
  final bool isSelf;
  final String? fallbackName;
  final String? fallbackAvatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicUserProfileProvider(ownerId));
    final colors = context.ybColors;

    return YbSurfaceCard(
      onTap: () => context.push('/user/$ownerId'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.xizmatProviderSection,
            style: AppTypography.label.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.md),
          profileAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => _ProviderRow(
              fullName: fallbackName ?? strings.genericUser,
              avatarUrl: fallbackAvatarUrl,
              subtitle: strings.userProfileViewProfile,
            ),
            data: (profile) => _ProviderRow(
              fullName: profile?.fullName.isNotEmpty == true
                  ? profile!.fullName
                  : (fallbackName ?? strings.genericUser),
              avatarUrl: profile?.avatarUrl ?? fallbackAvatarUrl,
              subtitle: isSelf
                  ? strings.profileViewPublic
                  : strings.userProfileViewProfile,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderRow extends StatelessWidget {
  const _ProviderRow({
    required this.fullName,
    required this.subtitle,
    this.avatarUrl,
  });

  final String fullName;
  final String subtitle;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Row(
      children: [
        ProfileAvatar(
          fullName: fullName,
          avatarUrl: avatarUrl,
          radius: 24,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: AppTypography.headline.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
      ],
    );
  }
}

class _OtherServicesSection extends ConsumerWidget {
  const _OtherServicesSection({
    required this.ownerId,
    required this.currentXizmatId,
    required this.strings,
  });

  final String ownerId;
  final String currentXizmatId;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xizmatlarAsync = ref.watch(publicUserXizmatlarProvider(ownerId));

    return xizmatlarAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        final others =
            items.where((item) => item.id != currentXizmatId).take(3).toList();
        if (others.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    strings.xizmatOtherServices,
                    style: AppTypography.headline.copyWith(
                      color: context.ybColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/user/$ownerId'),
                  child: Text(strings.xizmatViewAllServices),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...others.map(
              (item) => YbCompactListTile(
                title: item.serviceDisplayName,
                subtitle: item.subcategoryLabel,
                onTap: () => context.push('/xizmat/${item.id}'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.xizmatId});

  final String xizmatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final reviewsAsync = ref.watch(xizmatReviewsProvider(xizmatId));
    final colors = context.ybColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        reviewsAsync.when(
          loading: () => Text(
            strings.reviewsTitle,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          error: (_, _) => Text(
            strings.reviewsTitle,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          data: (reviews) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  strings.reviewsTitle,
                  style:
                      AppTypography.headline.copyWith(color: colors.textPrimary),
                ),
              ),
              if (reviews.isNotEmpty) YbReviewsSummaryChip(reviews: reviews),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        reviewsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => Text(
            '$error',
            style: AppTypography.caption.copyWith(color: AppColors.error),
          ),
          data: (reviews) {
            if (reviews.isEmpty) {
              return Text(
                strings.reviewsEmpty,
                style: AppTypography.caption.copyWith(
                  color: colors.textSecondary,
                ),
              );
            }

            return Column(
              children: reviews
                  .map(
                    (review) => YbReviewCard(
                      review: review,
                      strings: strings,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
