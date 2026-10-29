import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/experience_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_job_post_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_stagger_in.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/home/widgets/create_yordam_kerak_sheet.dart';
import 'package:yordambor/presentation/home/widgets/feed_load_more_sentinel.dart';
import 'package:yordambor/presentation/home/widgets/home_feed_end.dart';
import 'package:yordambor/presentation/home/widgets/home_filter_bar.dart';
import 'package:yordambor/presentation/home/widgets/home_header.dart';
import 'package:yordambor/presentation/home/widgets/home_list_detail.dart';
import 'package:yordambor/presentation/home/widgets/whats_new_sheet.dart';
import 'package:yordambor/presentation/kelishuv/yordam_bor_flow.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';
import 'package:yordambor/presentation/shared/detail_pane.dart';
import 'package:yordambor/presentation/shared/xizmat_feed_card.dart';
import 'package:yordambor/presentation/shell/deal_box.dart';
import 'package:yordambor/presentation/shell/shell_notification_button.dart';
import 'package:yordambor/presentation/shell/shell_tabs.dart';
import 'package:yordambor/presentation/xizmat/create_xizmat_gate.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';

/// Home, top to bottom (design direction Part 10): the greeting, the mode
/// switch, the filters and the feed. The bar and the mode switch stay
/// pinned; the filters come back as soon as the feed heads up; the two ways
/// to start (offer a service, ask for help) always float over the feed.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scroll = ScrollController();
  final _greetingKey = GlobalKey();
  final _headerKey = GlobalKey();

  /// The greeting has scrolled under the bar and folds into its title.
  final _barShowsGreeting = ValueNotifier(false);

  /// The filters have scrolled away and the feed is heading back up: they
  /// ride under the mode switch until the feed reaches them again.
  final _filtersFloating = ValueNotifier(false);
  double _lastOffset = 0;

  bool _whatsNewScheduled = false;

  /// The introduction was opened from here this session.
  bool _onboardingOpened = false;

  /// When the feed's current content first appeared, so its first rows
  /// rise in once (manual 8A) and not again on every rebuild.
  DateTime _feedShownAt = DateTime.now();
  String? _feedKey;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    ShellTabs.reselected.addListener(_onTabReselected);
  }

  @override
  void dispose() {
    ShellTabs.reselected.removeListener(_onTabReselected);
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _barShowsGreeting.dispose();
    _filtersFloating.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scroll.offset;
    final greeting = _greetingKey.currentContext?.size?.height ?? 64;
    _barShowsGreeting.value = offset > greeting * 0.7;
    _updateFloatingFilters(offset);
  }

  /// Quick return: the filters come back the moment the feed moves up and
  /// step aside when it moves on. Near the top they are simply in place.
  void _updateFloatingFilters(double offset) {
    final delta = offset - _lastOffset;
    _lastOffset = offset;
    // The bounce past the end is not a change of direction.
    if (offset > _scroll.position.maxScrollExtent) return;
    final header = _headerKey.currentContext?.size?.height;
    if (header == null || offset <= header) {
      _filtersFloating.value = false;
    } else if (delta < -2) {
      _filtersFloating.value = true;
    } else if (delta > 2) {
      _filtersFloating.value = false;
    }
  }

  /// Tapping "Asosiy" while on home brings the feed back to the top
  /// (manual N-05).
  void _onTabReselected() {
    final event = ShellTabs.reselected.value;
    if (event == null || event.index != 0 || !mounted) return;
    ShellTabs.scrollToTop(context, _scroll);
  }

  Future<void> _askForHelp() async {
    final allowed = await requireVerifiedAuth(
      context,
      ref,
      authContext: AuthContextType.postJob,
    );
    if (!allowed || !mounted) return;
    await showCreateYordamKerakSheet(context);
  }

  /// Signed in and under the services limit, else it says why.
  Future<void> _offerService() => openCreateXizmat(context, ref);

  /// The short introduction, once, for anyone who has not seen it (people
  /// who signed up before it existed too). It never asks to register.
  void _maybeShowOnboarding(OnboardingPrefsState prefs) {
    if (!prefs.isLoaded || prefs.onboardingDone || _onboardingOpened) return;
    _onboardingOpened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      // Not over another screen; it waits for the next visit home.
      if (route != null && !route.isCurrent) {
        _onboardingOpened = false;
        return;
      }
      context.push('/start');
    });
  }

  /// One "What's new" sheet after an update (manual WL-03), once home is on
  /// screen and nothing else is showing.
  void _maybeShowWhatsNew(LaunchExperience launch) {
    if (!launch.isLoaded || !launch.showWhatsNew) return;
    // Someone new sees the introduction instead.
    if (!ref.read(onboardingPrefsProvider).onboardingDone) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_whatsNewScheduled || !mounted) return;
      _whatsNewScheduled = true;
      // Let the page arrive and settle before anything rises over it.
      await Future<void>.delayed(const Duration(milliseconds: 800));
      _whatsNewScheduled = false;
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) return;
      if (!ref.read(launchExperienceProvider).showWhatsNew) return;
      await ref.read(launchExperienceProvider.notifier).markWhatsNewSeen();
      if (!mounted) return;
      await showWhatsNewSheet(context, ref.read(appStringsProvider));
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final filter = ref.watch(feedFilterProvider);
    final isYordamKerak = filter.mode == FeedMode.yordamKerak;
    final feed = isYordamKerak ? const FeedState() : ref.watch(feedProvider);
    final jobFeed = isYordamKerak
        ? ref.watch(yordamKerakFeedProvider)
        : const YordamKerakFeedState();
    final hasItems =
        isYordamKerak ? jobFeed.items.isNotEmpty : feed.items.isNotEmpty;
    final feedKey = [
      filter.mode,
      filter.categoryId,
      filter.subcategoryId,
      filter.providerType,
      filter.serviceCityId,
      hasItems,
    ].join('|');
    if (feedKey != _feedKey) {
      _feedKey = feedKey;
      _feedShownAt = DateTime.now();
    }

    _maybeShowOnboarding(ref.watch(onboardingPrefsProvider));
    _maybeShowWhatsNew(ref.watch(launchExperienceProvider));

    // On wide windows the open card shows beside the feed.
    return HomeListDetail(list: _feed(context, strings, filter, feed, jobFeed));
  }

  Widget _feed(
    BuildContext context,
    AppStrings strings,
    FeedFilterState filter,
    FeedState feed,
    YordamKerakFeedState jobFeed,
  ) {
    final isYordamKerak = filter.mode == FeedMode.yordamKerak;
    final (:greeting, fact: _) = homeGreeting(ref);
    final colors = context.ybColors;

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
          // Below the pinned bar, not under the status bar.
          edgeOffset: MediaQuery.paddingOf(context).top + kToolbarHeight,
          child: CustomScrollView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                title: ValueListenableBuilder<bool>(
                  valueListenable: _barShowsGreeting,
                  builder: (context, showGreeting, _) => AnimatedSwitcher(
                    duration: AppMotion.of(context, AppMotion.quick),
                    switchInCurve: AppMotion.quickCurve,
                    switchOutCurve: AppMotion.quickCurve,
                    layoutBuilder: (current, previous) => Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [...previous, ?current],
                    ),
                    child: showGreeting
                        ? Text(
                            greeting,
                            key: const ValueKey('greeting'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.headline.copyWith(
                              color: colors.ink,
                            ),
                          )
                        : YbAppBrandTitle(
                            key: const ValueKey('brand'),
                            logoSize: 28,
                            style: AppTypography.headline.copyWith(
                              color: colors.ink,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                actions: [
                  // Find a provider or an organization by name.
                  IconButton(
                    tooltip: strings.searchTooltip,
                    icon: const Icon(YbIcons.search),
                    onPressed: () => context.push('/search'),
                  ),
                  const DealBoxButton(),
                  const ShellNotificationButton(),
                ],
              ),
              SliverToBoxAdapter(
                child: KeyedSubtree(
                  key: _headerKey,
                  child: HomeHeader(greetingKey: _greetingKey),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _ModeSwitchHeader(
                  extent: homeModeSwitchExtent(context),
                  background: colors.surface,
                  divider: colors.line,
                ),
              ),
              const SliverToBoxAdapter(child: HomeFilterTiles()),
              if (isYordamKerak ? jobFeed.offline : feed.offline)
                SliverToBoxAdapter(
                  child: _OfflineBanner(
                    message: strings.stateOfflineBanner,
                    retryLabel: strings.actionRetry,
                    onRetry: () => isYordamKerak
                        ? ref.read(yordamKerakFeedProvider.notifier).load()
                        : ref.read(feedProvider.notifier).load(),
                  ),
                ),
              if (isYordamKerak)
                ..._jobSlivers(strings, jobFeed)
              else
                ..._xizmatSlivers(strings, feed),
            ],
          ),
        ),
        // The filters, back under the mode switch while the feed heads up.
        Positioned(
          top: MediaQuery.paddingOf(context).top +
              kToolbarHeight +
              homeModeSwitchExtent(context),
          left: 0,
          right: 0,
          child: _FloatingFilters(visible: _filtersFloating),
        ),
        // One way to start over each feed, in its colour: offering a
        // service over the services (teal), asking for help over the
        // requests (apricot). The button changes with the tab.
        Positioned(
          right: AppSpacing.lg,
          bottom: AppShell.homeFabBottomOffset(context),
          child: AnimatedSwitcher(
            duration: AppMotion.of(context, AppMotion.quick),
            switchInCurve: AppMotion.quickCurve,
            switchOutCurve: AppMotion.quickCurve,
            layoutBuilder: (current, previous) => Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [...previous, ?current],
            ),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
                alignment: Alignment.centerRight,
                child: child,
              ),
            ),
            child: isYordamKerak
                ? _HomeFab(
                    key: const ValueKey('home-ask'),
                    heroTag: 'home-ask',
                    color: colors.apricot,
                    onColor: colors.onApricot,
                    icon: YbIcons.campaignFilled,
                    label: strings.quickAskHelp,
                    onPressed: _askForHelp,
                  )
                : _HomeFab(
                    key: const ValueKey('home-offer'),
                    heroTag: 'home-offer',
                    color: colors.teal,
                    onColor: colors.onTeal,
                    icon: YbIcons.addBusinessFilled,
                    label: strings.quickOfferService,
                    onPressed: _offerService,
                  ),
          ),
        ),
      ],
    );
  }

  List<Widget> _jobSlivers(AppStrings strings, YordamKerakFeedState jobFeed) {
    if (jobFeed.isLoading && jobFeed.items.isEmpty) {
      return const [_SkeletonSliver()];
    }

    if (jobFeed.items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: YbEmptyState(
            icon: YbIcons.campaign,
            title: strings.homeJobsEmptyTitle,
            subtitle: strings.homeJobsEmptySubtitle,
            actionLabel: strings.quickAskHelp,
            onAction: _askForHelp,
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
            return YbStaggerIn(
              key: ValueKey('job-card-${item.id}'),
              index: index,
              listShownAt: _feedShownAt,
              child: YbJobPostCard(
                item: item,
                priceText: helpRequestPriceLabel(item, strings),
                sampleLabel: item.isDemo ? strings.sampleTag : null,
                sectorLine: strings.sectorLine(
                  item.categoryLabel,
                  item.subcategoryLabel,
                ),
                cityLabel: strings.serviceCityDisplayLabel(item.serviceCity),
                yordamBorLabel: strings.filterYordamBor,
                selected: DetailPane.selectedOf(context) ==
                    (kind: DetailKind.post, id: item.id),
                onTap: () => openPost(context, item.id),
                onAuthorTap: item.authorId != null
                    ? () => context.push('/user/${item.authorId}')
                    : null,
                onYordamBor: () => answerHelpRequest(context, ref, item),
              ),
            );
          },
          childCount: jobFeed.items.length + (jobFeed.hasMore ? 1 : 0),
        ),
      ),
      if (!jobFeed.hasMore)
        SliverToBoxAdapter(
          child: HomeFeedEnd(
            title: strings.feedEndTitle,
            prompt: strings.feedEndJobsHint,
          ),
        ),
      SliverPadding(
        padding: EdgeInsets.only(
          bottom: AppShell.scrollBottomPadding(
            context,
            includeExtendedFab: true,
            fabStack: 1,
          ),
        ),
      ),
    ];
  }

  List<Widget> _xizmatSlivers(AppStrings strings, FeedState feed) {
    if (feed.isLoading && feed.items.isEmpty) {
      return const [_SkeletonSliver()];
    }

    if (feed.items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: YbEmptyState(
            icon: YbIcons.designServices,
            title: strings.homeEmptyTitle,
            subtitle: strings.homeEmptySubtitle,
            actionLabel: strings.quickOfferService,
            onAction: _offerService,
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
            return RepaintBoundary(
              key: ValueKey('xizmat-card-${item.id}'),
              child: YbStaggerIn(
                index: index,
                listShownAt: _feedShownAt,
                child: XizmatFeedCard(item: item),
              ),
            );
          },
          childCount: feed.items.length + (feed.hasMore ? 1 : 0),
        ),
      ),
      if (!feed.hasMore)
        SliverToBoxAdapter(
          child: HomeFeedEnd(
            title: strings.feedEndTitle,
            prompt: strings.feedEndAskPrompt,
            actionLabel: strings.quickAskHelp,
            onAction: _askForHelp,
          ),
        ),
      // Room for the button that floats over the feed.
      SliverPadding(
        padding: EdgeInsets.only(
          bottom: AppShell.scrollBottomPadding(
            context,
            includeExtendedFab: true,
            fabStack: 1,
          ),
        ),
      ),
    ];
  }
}

/// The floating way to start over a feed, with a shadow in its own colour.
class _HomeFab extends StatelessWidget {
  const _HomeFab({
    super.key,
    required this.heroTag,
    required this.color,
    required this.onColor,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final String heroTag;
  final Color color;
  final Color onColor;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppElevation.fab(context, tint: color),
      ),
      child: FloatingActionButton.extended(
        heroTag: heroTag,
        backgroundColor: color,
        foregroundColor: onColor,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

/// The filters riding under the pinned mode switch (quick return). They
/// slide out from under it; while away they are not built at all, so they
/// take no taps and say nothing to screen readers.
class _FloatingFilters extends StatelessWidget {
  const _FloatingFilters({required this.visible});

  final ValueNotifier<bool> visible;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final duration = AppMotion.of(context, AppMotion.quick);

    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (context, shown, child) => IgnorePointer(
        ignoring: !shown,
        child: ClipRect(
          child: AnimatedSlide(
            offset: shown ? Offset.zero : const Offset(0, -1),
            duration: duration,
            curve: AppMotion.quickCurve,
            child: shown ? child : const SizedBox(width: double.infinity),
          ),
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(bottom: BorderSide(color: colors.line)),
        ),
        child: const HomeFilterTiles(),
      ),
    );
  }
}

/// No connection: say so once, calmly, above the saved results (design
/// direction, system states). Never blame, always offer the retry.
class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Semantics(
        liveRegion: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.xs,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Icon(YbIcons.cloudOff, size: 18, color: colors.ink2),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    message,
                    style: AppTypography.body.copyWith(color: colors.ink2),
                  ),
                ),
                TextButton(onPressed: onRetry, child: Text(retryLabel)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Three placeholder cards while the first page loads.
class _SkeletonSliver extends StatelessWidget {
  const _SkeletonSliver();

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: const [YbSkeletonCard(), YbSkeletonCard(), YbSkeletonCard()],
    );
  }
}

/// The pinned mode switch. A hairline appears under it only while the feed
/// scrolls beneath, so at rest the page has no borders.
class _ModeSwitchHeader extends SliverPersistentHeaderDelegate {
  const _ModeSwitchHeader({
    required this.extent,
    required this.background,
    required this.divider,
  });

  final double extent;
  final Color background;
  final Color divider;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: extent,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.quick),
        decoration: BoxDecoration(
          color: background,
          border: Border(
            bottom: BorderSide(
              color: overlapsContent ? divider : background,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: const HomeModeSwitch(),
      ),
    );
  }

  @override
  bool shouldRebuild(_ModeSwitchHeader oldDelegate) =>
      extent != oldDelegate.extent ||
      background != oldDelegate.background ||
      divider != oldDelegate.divider;
}
