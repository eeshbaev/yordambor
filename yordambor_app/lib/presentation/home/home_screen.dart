import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_job_post_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_xizmat_card.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/auth/widgets/auth_welcome_banner.dart';
import 'package:yordambor/presentation/home/widgets/create_yordam_kerak_sheet.dart';
import 'package:yordambor/presentation/home/widgets/feed_load_more_sentinel.dart';
import 'package:yordambor/presentation/home/widgets/home_filter_bar.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/presentation/kelishuv/yordam_bor_flow.dart';
import 'package:yordambor/core/share/feed_share.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';
import 'package:yordambor/presentation/shell/shell_notification_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final filter = ref.watch(feedFilterProvider);
    final isYordamKerak = filter.mode == FeedMode.yordamKerak;
    final feed = isYordamKerak ? const FeedState() : ref.watch(feedProvider);
    final jobFeed = isYordamKerak
        ? ref.watch(yordamKerakFeedProvider)
        : const YordamKerakFeedState();
    final favorites = ref.watch(favoritesProvider);

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            if (isYordamKerak) {
              await ref.read(yordamKerakFeedProvider.notifier).load();
            } else {
              await ref.read(feedProvider.notifier).load();
            }
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                toolbarHeight: kHomeAppBarToolbarHeight,
                title: _HomeTitle(
                  session: session,
                  strings: strings,
                ),
                actions: const [ShellNotificationButton()],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(kHomeFilterBarHeight),
                  child: const HomeFilterBar(),
                ),
              ),
              const SliverToBoxAdapter(child: AuthWelcomeBanner()),
              if (isYordamKerak)
                ..._yordamKerakSlivers(
                  context,
                  ref,
                  strings: strings,
                  jobFeed: jobFeed,
                )
              else
                ..._yordamBorSlivers(
                  context,
                  ref,
                  strings: strings,
                  feed: feed,
                  favorites: favorites,
                ),
            ],
          ),
        ),
        if (isYordamKerak)
          Positioned(
            right: AppSpacing.lg,
            bottom: AppShell.homeFabBottomOffset(context),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.button),
                boxShadow: AppElevation.fab(context),
              ),
              child: FloatingActionButton.extended(
                onPressed: () => _openCreatePost(context, ref),
                icon: const Icon(Icons.add_rounded),
                label: Text(strings.fabPostYordamKerak),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openCreatePost(BuildContext context, WidgetRef ref) async {
    final allowed = await requireVerifiedAuth(
      context,
      ref,
      authContext: AuthContextType.postJob,
    );
    if (!allowed || !context.mounted) return;
    await showCreateYordamKerakSheet(context);
  }

  List<Widget> _yordamKerakSlivers(
    BuildContext context,
    WidgetRef ref, {
    required AppStrings strings,
    required YordamKerakFeedState jobFeed,
  }) {
    if (jobFeed.isLoading && jobFeed.items.isEmpty) {
      return const [
        SliverFillRemaining(
          child: YbSkeletonList(),
        ),
      ];
    }

    if (jobFeed.items.isEmpty) {
      return [
        SliverFillRemaining(
          child: YbEmptyState(
            icon: Icons.campaign_outlined,
            title: strings.homeJobsEmptyTitle,
            subtitle: strings.homeJobsEmptySubtitle,
            actionLabel: strings.fabPostYordamKerak,
            onAction: () => _openCreatePost(context, ref),
          ),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= jobFeed.items.length) {
              return FeedLoadMoreSentinel(
                key: ValueKey('jobs-${jobFeed.items.length}'),
                isLoadingMore: jobFeed.isLoadingMore,
                onLoadMore: () =>
                    ref.read(yordamKerakFeedProvider.notifier).loadMore(),
              );
            }

            final item = jobFeed.items[index];
            return YbJobPostCard(
              item: item,
              sectorLine: strings.sectorLine(
                item.categoryLabel,
                item.subcategoryLabel,
              ),
              yordamBorLabel: strings.filterYordamBor,
              onTap: () => context.push('/post/${item.id}'),
              onShare: () => FeedShare.shareYordamKerakPost(
                strings: strings,
                postId: item.id,
                title: item.title,
              ),
              shareTooltip: strings.shareYordamKerak,
              onAuthorTap: item.authorId != null
                  ? () => context.push('/user/${item.authorId}')
                  : null,
              callLabel: strings.userProfileCall,
              phoneHiddenLabel: strings.userProfilePhoneHidden,
              onYordamBor: () async {
                final allowed = await requireVerifiedAuth(
                  context,
                  ref,
                  authContext: AuthContextType.yordamBor,
                );
                if (!allowed || !context.mounted) return;
                await openYordamBorForPost(
                  context,
                  ref,
                  postId: item.id,
                  subcategoryId: item.subcategoryId,
                );
              },
            );
          },
          childCount: jobFeed.items.length + (jobFeed.hasMore ? 1 : 0),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.only(
          bottom: AppShell.scrollBottomPadding(
            context,
            includeExtendedFab: true,
          ),
        ),
      ),
    ];
  }

  List<Widget> _yordamBorSlivers(
    BuildContext context,
    WidgetRef ref, {
    required AppStrings strings,
    required FeedState feed,
    required Set<String> favorites,
  }) {
    if (feed.isLoading && feed.items.isEmpty) {
      return const [
        SliverFillRemaining(
          child: YbSkeletonList(),
        ),
      ];
    }

    if (feed.items.isEmpty) {
      return [
        SliverFillRemaining(
          child: YbEmptyState(
            icon: Icons.design_services_outlined,
            title: strings.homeEmptyTitle,
            subtitle: strings.homeEmptySubtitle,
            actionLabel: strings.createXizmat,
            onAction: () => requireVerifiedAuth(
              context,
              ref,
              authContext: AuthContextType.generic,
            ).then((ok) {
              if (ok && context.mounted) context.push('/create-xizmat');
            }),
          ),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= feed.items.length) {
              return FeedLoadMoreSentinel(
                key: ValueKey('xizmat-${feed.items.length}'),
                isLoadingMore: feed.isLoadingMore,
                onLoadMore: () => ref.read(feedProvider.notifier).loadMore(),
              );
            }

            final item = feed.items[index];
            final availability = xizmatAvailabilityDisplay(item, strings);
            return RepaintBoundary(
              key: ValueKey('xizmat-card-${item.id}'),
              child: YbXizmatCard(
                item: item,
                isFavorite: favorites.contains(item.id),
                providerTypeLabel: strings.providerTypeLabel(item.providerType),
                sectorLine: strings.sectorLine(
                  item.categoryLabel,
                  item.subcategoryLabel,
                ),
                completedLabel:
                    strings.xizmatCompletedCount(item.completedCount),
                priceLabel: xizmatPricingLabel(item, strings),
                availabilityLabel: availability?.label,
                availabilityTone: availability?.tone,
                servicePromise: item.visibleServicePromise,
                onTap: () => context.push('/xizmat/${item.id}'),
                onShare: () => FeedShare.shareXizmat(
                  strings: strings,
                  xizmatId: item.id,
                  xizmatName: item.name,
                ),
                shareTooltip: strings.shareXizmat,
                onOwnerTap: item.ownerId != null
                    ? () => context.push('/user/${item.ownerId}')
                    : null,
                onFavoriteToggle: () =>
                    ref.read(favoritesProvider.notifier).toggle(item.id),
              ),
            );
          },
          childCount: feed.items.length + (feed.hasMore ? 1 : 0),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.only(
          bottom: AppShell.scrollBottomPadding(context),
        ),
      ),
    ];
  }
}

class _HomeTitle extends StatelessWidget {
  const _HomeTitle({
    required this.session,
    required this.strings,
  });

  final SessionState session;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    if (!session.isAuthenticated) {
      return YbAppBrandTitle(
        style: AppTypography.title.copyWith(color: colors.textPrimary),
      );
    }

    final greetingName = sessionGreetingName(session, strings.welcomeGuestName);

    return YbAppBrandTitle(
      style: AppTypography.title.copyWith(
        color: colors.textPrimary,
        fontSize: 20,
        height: 1.2,
      ),
      logoSize: 32,
      subtitle: Text(
        strings.homeGreetingShort(greetingName),
        style: AppTypography.caption.copyWith(
          color: colors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
