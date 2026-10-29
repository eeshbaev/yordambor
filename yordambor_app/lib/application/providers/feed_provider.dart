import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/safety_providers.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/core/network/network_errors.dart';
import 'package:yordambor/data/demo/demo_feed_support.dart';
import 'package:yordambor/data/demo/demo_xizmat_feed.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

class FeedState {
  const FeedState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.items = const [],
    this.errorMessage,
    this.offline = false,
    this.showingSamples = false,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final List<XizmatFeedItem> items;
  final String? errorMessage;

  /// The last load failed for want of a connection; what shows is what was
  /// already on the phone.
  final bool offline;

  /// Samples follow the real services in the feed.
  final bool showingSamples;

  FeedState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    List<XizmatFeedItem>? items,
    String? errorMessage,
    bool? offline,
    bool? showingSamples,
  }) {
    return FeedState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      items: items ?? this.items,
      errorMessage: errorMessage,
      offline: offline ?? this.offline,
      showingSamples: showingSamples ?? this.showingSamples,
    );
  }
}

final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  final notifier = FeedNotifier(ref);
  ref.listen(feedFilterProvider, (_, _) {
    notifier.scheduleLoad();
  });
  ref.listen(
    onboardingPrefsProvider.select((prefs) => prefs.language),
    (_, _) => notifier.scheduleLoad(),
  );
  return notifier;
});

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier(this._ref) : super(const FeedState(isLoading: true)) {
    unawaited(load());
  }

  final Ref _ref;
  int _nextOffset = 0;
  int _loadGeneration = 0;
  Timer? _debounceTimer;

  /// The filter the items on screen belong to.
  String? _shownFilterKey;

  /// Samples for the current filter, waiting for the last real page.
  List<XizmatFeedItem> _pendingSamples = const [];

  void scheduleLoad() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(FeedConstants.filterDebounce, () {
      unawaited(load());
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    final filter = _ref.read(feedFilterProvider);
    if (filter.mode == FeedMode.yordamKerak) {
      state = const FeedState(isLoading: false);
      return;
    }

    final generation = ++_loadGeneration;
    _nextOffset = 0;

    final language = _ref.read(onboardingPrefsProvider).language;
    final filterKey = _filterKey(filter, language);
    // A refresh keeps what is on screen until the new page arrives; a new
    // filter shows placeholders, never the old results.
    final previous = state;
    final keep = filterKey == _shownFilterKey && previous.items.isNotEmpty;
    state = keep
        ? previous.copyWith(isLoading: true)
        : const FeedState(isLoading: true);
    _shownFilterKey = filterKey;

    final labelResolver = _ref.read(categoryLabelResolverProvider);
    await labelResolver.ensureLoaded();
    final demoItems = FeedConstants.showSamples
        ? _filterItems(
            labelResolver.localizeXizmatList(DemoXizmatFeed.items, language),
            filter,
          )
        : const <XizmatFeedItem>[];
    _pendingSamples = const [];

    final repo = _ref.read(xizmatRepositoryProvider);

    try {
      final results = await Future.wait<Object>([
        repo
            .fetchFeedPage(
              categoryId: filter.categoryId,
              subcategoryId: filter.subcategoryId,
              providerType: filter.providerType,
              serviceCityId: filter.serviceCityId,
              language: language,
              offset: 0,
              limit: FeedConstants.pageSize,
            )
            .timeout(FeedConstants.feedFetchTimeout),
        _ref
            .read(blockedUserIdsProvider.future)
            .timeout(FeedConstants.blockedUsersTimeout, onTimeout: () => {}),
        _fetchMyItems(language),
      ]);

      if (!mounted || generation != _loadGeneration) return;

      final page = results[0] as FeedPage<XizmatFeedItem>;
      final blocked = results[1] as Set<String>;
      final myItems = _filterItems(results[2] as List<XizmatFeedItem>, filter);
      final realItems = _filterBlocked(page.items, blocked);
      // Real services first; the samples follow after the last real page.
      final more = realItems.isNotEmpty && page.hasMore;
      final items = DemoFeedSupport.composePinned<XizmatFeedItem>(
        pinnedItems: myItems,
        realItems: realItems,
        demoItems: more ? const <XizmatFeedItem>[] : demoItems,
        idOf: (item) => item.id,
      );
      _pendingSamples = more ? demoItems : const [];

      if (realItems.isNotEmpty) {
        _nextOffset = page.nextOffset;
      }

      state = FeedState(
        isLoading: false,
        items: items,
        hasMore: more,
        showingSamples: !more && demoItems.isNotEmpty,
      );
    } catch (error) {
      if (!mounted || generation != _loadGeneration) return;

      // No answer: what is already on screen stays; otherwise the samples
      // rather than an empty page.
      final items = keep ? previous.items : demoItems;
      state = FeedState(
        isLoading: false,
        items: items,
        hasMore: false,
        errorMessage: items.isEmpty ? error.toString() : null,
        offline: isLikelyOfflineError(error),
        showingSamples:
            keep ? previous.showingSamples : demoItems.isNotEmpty,
      );
    }
  }

  static String _filterKey(FeedFilterState filter, String language) => [
        filter.categoryId,
        filter.subcategoryId,
        filter.providerType,
        filter.serviceCityId,
        language,
      ].join('|');

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    final filter = _ref.read(feedFilterProvider);
    final language = _ref.read(onboardingPrefsProvider).language;
    final repo = _ref.read(xizmatRepositoryProvider);

    try {
      final results = await Future.wait<Object>([
        repo
            .fetchFeedPage(
              categoryId: filter.categoryId,
              subcategoryId: filter.subcategoryId,
              providerType: filter.providerType,
              serviceCityId: filter.serviceCityId,
              language: language,
              offset: _nextOffset,
              limit: FeedConstants.pageSize,
            )
            .timeout(FeedConstants.feedFetchTimeout),
        _ref
            .read(blockedUserIdsProvider.future)
            .timeout(FeedConstants.blockedUsersTimeout, onTimeout: () => {}),
      ]);

      final page = results[0] as FeedPage<XizmatFeedItem>;
      final blocked = results[1] as Set<String>;
      final newItems = _filterBlocked(page.items, blocked);
      _nextOffset = page.nextOffset;

      final seen = state.items.map((item) => item.id).toSet();
      final uniqueNewItems =
          newItems.where((item) => seen.add(item.id)).toList();
      // The last real page is in: the samples follow it.
      final samples = page.hasMore
          ? const <XizmatFeedItem>[]
          : _pendingSamples.where((item) => seen.add(item.id)).toList();
      if (!page.hasMore) _pendingSamples = const [];

      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...uniqueNewItems, ...samples],
        hasMore: page.hasMore,
        showingSamples: state.showingSamples || samples.isNotEmpty,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<List<XizmatFeedItem>> _fetchMyItems(String language) async {
    final userId = _ref.read(sessionProvider).user?.id;
    if (userId == null) return [];

    try {
      return await _ref
          .read(xizmatRepositoryProvider)
          .fetchMine(userId, language)
          .timeout(FeedConstants.networkTimeout);
    } catch (_) {
      return [];
    }
  }

  List<XizmatFeedItem> _filterBlocked(
    List<XizmatFeedItem> items,
    Set<String> blocked,
  ) {
    if (blocked.isEmpty) return items;

    return items
        .where(
          (item) => item.ownerId == null || !blocked.contains(item.ownerId),
        )
        .toList();
  }

  List<XizmatFeedItem> _filterItems(
    List<XizmatFeedItem> items,
    FeedFilterState filter,
  ) {
    var result = items;
    if (filter.categoryId != null) {
      result = result
          .where((item) => item.categoryId == filter.categoryId)
          .toList();
    }
    if (filter.subcategoryId != null) {
      result = result
          .where((item) => item.subcategoryId == filter.subcategoryId)
          .toList();
    }
    if (filter.providerType != null) {
      result = result
          .where((item) => item.providerType == filter.providerType)
          .toList();
    }
    if (filter.serviceCityId != null) {
      result = result
          .where(
            (item) =>
                ServiceCities.resolveForFeed(
                  item.serviceCity,
                  isDemo: item.isDemo,
                  listingId: item.id,
                ) ==
                filter.serviceCityId,
          )
          .toList();
    }
    return result;
  }
}
