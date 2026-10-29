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
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_info_tag.dart';
import 'package:yordambor/core/design_system/widgets/yb_photo_hero.dart';
import 'package:yordambor/core/design_system/widgets/yb_portfolio_gallery.dart';
import 'package:yordambor/core/design_system/widgets/yb_provider_type_mark.dart';
import 'package:yordambor/core/design_system/widgets/yb_section_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/share/xizmat_share.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/utils/founding_providers.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/kelishuv/taklif_sheet.dart';
import 'package:yordambor/presentation/safety/safety_actions_sheet.dart';
import 'package:yordambor/presentation/shared/sample_listing_actions.dart';
import 'package:yordambor/presentation/xizmat/widgets/xizmat_key_facts.dart';
import 'package:yordambor/presentation/xizmat/widgets/xizmat_provider_card.dart';
import 'package:yordambor/presentation/xizmat/widgets/xizmat_reviews_section.dart';
import 'package:yordambor/presentation/xizmat/widgets/xizmat_schedule_section.dart';
import 'package:yordambor/presentation/xizmat/widgets/xizmat_view_tracker.dart';

/// A service, laid out for scanning (NN/g: most people scan, few read):
/// the photo; the name with its trade and city; who gives it, as a small
/// business card; the three facts people decide on (rating, jobs done,
/// price) in one frame; then one framed section each for what the provider
/// wrote, the hours, the reviews and how asking works. Long parts open on
/// demand. The price and the button stay at the bottom.
class XizmatProfileScreen extends ConsumerStatefulWidget {
  const XizmatProfileScreen({super.key, required this.xizmatId});

  final String xizmatId;

  @override
  ConsumerState<XizmatProfileScreen> createState() =>
      _XizmatProfileScreenState();
}

class _XizmatProfileScreenState extends ConsumerState<XizmatProfileScreen> {
  static const _photoHeight = 300.0;

  /// The content's rounded top edge, laid over the bottom of the photo.
  static const _lip = 20.0;

  final _scroll = ScrollController();
  final _reviewsKey = GlobalKey();

  /// The name shows in the bar once the photo has scrolled away.
  final _showTitle = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _showTitle.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show =
        _scroll.hasClients &&
        _scroll.offset > _photoHeight - kToolbarHeight - _lip - 32;
    if (show != _showTitle.value) _showTitle.value = show;
  }

  void _toReviews() {
    final target = _reviewsKey.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      alignment: 0.12,
      duration: AppMotion.of(context, const Duration(milliseconds: 420)),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final detailAsync = ref.watch(xizmatDetailProvider(widget.xizmatId));

    return detailAsync.when(
      loading: () =>
          Scaffold(appBar: AppBar(), body: const YbSkeletonList(count: 1)),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: YbEmptyState(
          icon: YbIcons.cloudOff,
          title: strings.stateErrorTitle,
          subtitle: strings.stateErrorBody,
          actionLabel: strings.actionRetry,
          onAction: () => ref.invalidate(xizmatDetailProvider(widget.xizmatId)),
        ),
      ),
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: YbEmptyState(
              icon: YbIcons.designServices,
              title: strings.homeEmptyTitle,
              subtitle: strings.homeEmptySubtitle,
            ),
          );
        }

        final colors = context.ybColors;
        final currentUserId = session.user?.id;
        final isOwnXizmat =
            currentUserId != null && item.ownerId == currentUserId;
        final effectiveOwnerId = item.ownerId ?? currentUserId;
        final availability = xizmatAvailabilityDisplay(item, strings);
        final isFavorite = ref.watch(favoritesProvider).contains(item.id);
        final summary = ref
            .watch(xizmatRatingSummaryProvider(item.id))
            .valueOrNull;
        final about = item.aboutText;
        final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;

        return XizmatViewTracker(
          xizmatId: item.id,
          child: Scaffold(
            bottomNavigationBar: _ActionBar(
              isOwnXizmat: isOwnXizmat,
              effectiveOwnerId: effectiveOwnerId,
              item: item,
              strings: strings,
            ),
            body: CustomScrollView(
              controller: _scroll,
              slivers: [
                SliverAppBar(
                  expandedHeight: _photoHeight,
                  pinned: true,
                  stretch: true,
                  automaticallyImplyLeading: false,
                  leading: canPop
                      ? Center(
                          child: _PhotoAction(
                            icon: YbIcons.arrowBack,
                            tooltip: MaterialLocalizations.of(context)
                                .backButtonTooltip,
                            onPressed: () => Navigator.maybePop(context),
                          ),
                        )
                      : null,
                  title: ValueListenableBuilder<bool>(
                    valueListenable: _showTitle,
                    builder: (context, show, _) => AnimatedOpacity(
                      opacity: show ? 1 : 0,
                      duration: AppMotion.of(context, AppMotion.quick),
                      child: Text(
                        item.serviceDisplayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  actions: [
                    if (!isOwnXizmat)
                      _PhotoAction(
                        icon: isFavorite
                            ? YbIcons.favoriteFilled
                            : YbIcons.favorite,
                        color: isFavorite ? colors.error : null,
                        tooltip: strings.tabFavorites,
                        onPressed: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(item.id),
                      ),
                    _PhotoAction(
                      icon: YbIcons.share,
                      tooltip: strings.shareXizmat,
                      onPressed: () => XizmatShare.share(
                        strings: strings,
                        xizmatId: item.id,
                        xizmatName: item.name,
                      ),
                    ),
                    if (item.ownerId != null &&
                        item.ownerId != session.user?.id)
                      _PhotoAction(
                        icon: YbIcons.moreVertFilled,
                        tooltip: strings.actionMore,
                        onPressed: () => showSafetyActionsSheet(
                          context,
                          ref,
                          targetUserId: item.ownerId!,
                          targetUserName: item.name,
                          reportType: ReportTargetType.xizmat,
                          reportTargetId: item.id,
                        ),
                      ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  // The page's rounded top edge, over the photo.
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(_lip),
                    child: Container(
                      height: _lip,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(_lip),
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        YbPortfolioGallery(
                          imageUrls: item.galleryUrls,
                          heroTag: xizmatPhotoHeroTag(item.id),
                          indicatorInset: _lip + AppSpacing.md,
                          placeholderIcon: CategoryIcons.forService(
                            categoryId: item.categoryId,
                            subcategoryId: item.subcategoryId,
                          ),
                          placeholderColor: CategoryIcons.tint(
                            context,
                            item.categoryId,
                          ).fill,
                          placeholderIconColor: CategoryIcons.tint(
                            context,
                            item.categoryId,
                          ).ink,
                        ),
                        // Organisation or person, the same mark as on cards.
                        PositionedDirectional(
                          start: AppSpacing.lg,
                          bottom: _lip + AppSpacing.md,
                          child: YbProviderTypeMark(
                            isInstitution: item.providerType == 'institution',
                            label: strings.providerTypeLabel(item.providerType),
                            size: 44,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xs,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(item: item, strings: strings),
                        // Who gives it, as a small business card.
                        if (effectiveOwnerId != null) ...[
                          const SizedBox(height: AppSpacing.md + 2),
                          XizmatProviderCard(
                            ownerId: effectiveOwnerId,
                            strings: strings,
                            isInstitution: item.providerType == 'institution',
                            typeLabel: strings.providerTypeLabel(
                              item.providerType,
                            ),
                            isSelf: isOwnXizmat,
                            fallbackName: isOwnXizmat
                                ? session.profile?.fullName
                                : item.ownerName,
                            fallbackAvatarUrl: isOwnXizmat
                                ? session.profile?.avatarUrl
                                : item.ownerAvatarUrl,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        XizmatKeyStats(
                          item: item,
                          strings: strings,
                          summary: summary,
                          onRatingTap: _toReviews,
                        ),
                        // What the provider wrote, as one text.
                        if (about != null) ...[
                          const SizedBox(height: AppSpacing.lg),
                          XizmatAboutSection(text: about, strings: strings),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        XizmatScheduleSection(
                          xizmatId: item.id,
                          ownerId: item.ownerId,
                          isDemo: item.isDemo,
                          status: availability,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        KeyedSubtree(
                          key: _reviewsKey,
                          child: XizmatReviewsSection(xizmatId: item.id),
                        ),
                        if (!isOwnXizmat) ...[
                          const SizedBox(height: AppSpacing.lg),
                          XizmatHowItWorks(strings: strings),
                        ],
                        if (effectiveOwnerId != null)
                          _OtherServicesSection(
                            ownerId: effectiveOwnerId,
                            currentXizmatId: item.id,
                            strings: strings,
                          ),
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

/// A round light button on the photo: back, save, share, more. It keeps
/// its pill when the bar collapses, so the icons never jump.
class _PhotoAction extends StatelessWidget {
  const _PhotoAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.onPhotoPill,
          foregroundColor: color ?? AppColors.onPhotoInk,
          fixedSize: const Size.square(40),
          minimumSize: const Size.square(40),
          padding: EdgeInsets.zero,
          // The pill is 40 dp; the touch area stays 48 dp.
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }
}

/// The name, then the trade and the city as tags, the badge for the first
/// providers, and the sample mark on a bundled example.
class _Header extends StatelessWidget {
  const _Header({required this.item, required this.strings});

  final XizmatFeedItem item;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            item.serviceDisplayName,
            style: AppTypography.title.copyWith(
              color: colors.ink,
              fontSize: 24,
              height: 29 / 24,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            YbInfoTag(
              icon: CategoryIcons.forService(
                categoryId: item.categoryId,
                subcategoryId: item.subcategoryId,
              ),
              label: item.subcategoryLabel,
              tone: YbInfoTone.service,
            ),
            if (item.hasServiceCity)
              YbInfoTag(
                icon: YbIcons.locationOnFilled,
                label:
                    strings.serviceCityDisplayLabel(item.serviceCity) ??
                    item.serviceCity!.trim(),
                tone: YbInfoTone.place,
              ),
            if (FoundingProviders.isFounding(item))
              Tooltip(
                message: strings.foundingBadgeNote,
                triggerMode: TooltipTriggerMode.tap,
                child: YbInfoTag(
                  icon: YbIcons.militaryTechFilled,
                  label: strings.foundingBadge,
                  tone: YbInfoTone.founding,
                ),
              ),
            // A bundled example says so on its own tag.
            if (item.isDemo)
              YbInfoTag(icon: YbIcons.info, label: strings.sampleTag),
          ],
        ),
      ],
    );
  }
}

class _ActionBar extends ConsumerWidget {
  const _ActionBar({
    required this.isOwnXizmat,
    required this.effectiveOwnerId,
    required this.item,
    required this.strings,
  });

  final bool isOwnXizmat;
  final String? effectiveOwnerId;
  final XizmatFeedItem item;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;

    // A sample takes no deal: interest in it becomes a real request.
    if (item.isDemo) {
      return YbStickyActionBar(
        children: [
          Text(
            strings.sampleFindProviderHint,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: colors.ink2),
          ),
          const SizedBox(height: AppSpacing.sm),
          YbPrimaryButton(
            label: strings.sampleFindProvider,
            icon: YbIcons.campaign,
            tone: YbButtonTone.ask,
            onPressed: () => findProviderFromSample(context, ref, item),
          ),
        ],
      );
    }

    if (isOwnXizmat) {
      return YbStickyActionBar(
        children: [
          if (effectiveOwnerId != null) ...[
            YbSecondaryButton(
              label: strings.profileViewPublic,
              icon: YbIcons.visibility,
              onPressed: () => context.push('/user/$effectiveOwnerId'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          YbPrimaryButton(
            label: strings.xizmatEditTitle,
            icon: YbIcons.edit,
            onPressed: () => context.push('/xizmat/${item.id}/manage'),
          ),
        ],
      );
    }

    // The price where the thumb is, next to the one thing to do.
    final price = xizmatPriceParts(item, strings);
    return YbStickyActionBar(
      children: [
        Row(
          children: [
            Flexible(
              child: MergeSemantics(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        price.value,
                        maxLines: 1,
                        style: AppTypography.price.copyWith(color: colors.ink),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      price.unit,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(color: colors.ink2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            YbPrimaryButton(
              label: strings.filterYordamKerak,
              icon: YbIcons.campaign,
              tone: YbButtonTone.ask,
              expand: false,
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
                  target: TaklifTarget.xizmat(xizmatId: item.id),
                  title: strings.taklifFlowTitleYordamKerak(item.name),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// The provider's other services, up to three, as rows in one frame.
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
    final items = ref.watch(publicUserXizmatlarProvider(ownerId)).valueOrNull;
    if (items == null) return const SizedBox.shrink();

    final others = items.where((item) => item.id != currentXizmatId).toList();
    if (others.isEmpty) return const SizedBox.shrink();
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: YbSectionCard(
        icon: YbIcons.gridViewFilled,
        title: strings.xizmatOtherServices,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, item) in others.take(3).indexed) ...[
              if (index > 0) Divider(height: 1, color: colors.borderSubtle),
              _OtherServiceRow(item: item),
            ],
            if (others.length > 3) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => context.push('/user/$ownerId'),
                  child: Text(strings.xizmatViewAllServices),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OtherServiceRow extends StatelessWidget {
  const _OtherServiceRow({required this.item});

  final XizmatFeedItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final tint = CategoryIcons.tint(context, item.categoryId);

    return InkWell(
      onTap: () => context.push('/xizmat/${item.id}'),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tint.fill,
                borderRadius: BorderRadius.circular(AppRadius.sm + 2),
              ),
              child: Icon(
                CategoryIcons.forService(
                  categoryId: item.categoryId,
                  subcategoryId: item.subcategoryId,
                ),
                size: 22,
                color: tint.ink,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.serviceDisplayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    item.subcategoryLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(color: colors.ink2),
                  ),
                ],
              ),
            ),
            Icon(YbIcons.chevronRightFilled, color: colors.ink3),
          ],
        ),
      ),
    );
  }
}
