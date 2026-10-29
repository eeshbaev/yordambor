import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/safety_providers.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/core/network/network_errors.dart';
import 'package:yordambor/data/demo/demo_yordam_kerak_feed.dart';
import 'package:yordambor/data/yordam_kerak/yordam_kerak_repository.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

final yordamKerakRepositoryProvider = Provider<YordamKerakRepository>((ref) {
  return YordamKerakRepository(ref.watch(categoryRepositoryProvider));
});

class YordamKerakFeedState {
  const YordamKerakFeedState({
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
  final List<YordamKerakFeedItem> items;
  final String? errorMessage;

  /// The last load failed for want of a connection.
  final bool offline;

  /// Samples follow the real requests in the feed.
  final bool showingSamples;

  YordamKerakFeedState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    List<YordamKerakFeedItem>? items,
    String? errorMessage,
    bool? offline,
    bool? showingSamples,
  }) {
    return YordamKerakFeedState(
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

final yordamKerakFeedProvider =
    StateNotifierProvider<YordamKerakFeedNotifier, YordamKerakFeedState>((ref) {
  final notifier = YordamKerakFeedNotifier(ref);
  ref.listen(feedFilterProvider, (_, _) {
    notifier.scheduleLoad();
  });
  ref.listen(
    onboardingPrefsProvider.select((prefs) => prefs.language),
    (_, _) => notifier.scheduleLoad(),
  );
  return notifier;
});

class YordamKerakFeedNotifier extends StateNotifier<YordamKerakFeedState> {
  YordamKerakFeedNotifier(this._ref)
      : super(const YordamKerakFeedState(isLoading: true)) {
    unawaited(load());
  }

  final Ref _ref;
  int _nextOffset = 0;
  int _loadGeneration = 0;
  Timer? _debounceTimer;

  /// The filter the items on screen belong to.
  String? _shownFilterKey;

  /// Samples for the current filter, waiting for the last real page.
  List<YordamKerakFeedItem> _pendingSamples = const [];

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
    if (filter.mode != FeedMode.yordamKerak) {
      state = const YordamKerakFeedState(isLoading: false);
      return;
    }

    final generation = ++_loadGeneration;
    _nextOffset = 0;

    final language = _ref.read(onboardingPrefsProvider).language;
    final filterKey = [
      filter.categoryId,
      filter.subcategoryId,
      filter.serviceCityId,
      language,
    ].join('|');
    // A refresh keeps what is on screen until the new page arrives; a new
    // filter shows placeholders, never the old results.
    final previous = state;
    final keep = filterKey == _shownFilterKey && previous.items.isNotEmpty;
    state = keep
        ? previous.copyWith(isLoading: true)
        : const YordamKerakFeedState(isLoading: true);
    _shownFilterKey = filterKey;

    final repo = _ref.read(yordamKerakRepositoryProvider);
    final labelResolver = _ref.read(categoryLabelResolverProvider);
    await labelResolver.ensureLoaded();
    final demoItems = FeedConstants.showSamples
        ? _filterItems(
            labelResolver.localizeYordamKerakList(
              DemoYordamKerakFeed.items,
              language,
            ),
            filter,
          )
        : const <YordamKerakFeedItem>[];
    _pendingSamples = const [];

    try {
      final results = await Future.wait<Object>([
        repo
            .fetchOpenPostsPage(
              categoryId: filter.categoryId,
              subcategoryId: filter.subcategoryId,
              serviceCityId: filter.serviceCityId,
              language: language,
              offset: 0,
              limit: FeedConstants.pageSize,
            )
            .timeout(FeedConstants.feedFetchTimeout),
        _ref
            .read(blockedUserIdsProvider.future)
            .timeout(FeedConstants.blockedUsersTimeout, onTimeout: () => {}),
      ]);

      if (!mounted || generation != _loadGeneration) return;

      final page = results[0] as FeedPage<YordamKerakFeedItem>;
      final blocked = results[1] as Set<String>;
      final realItems = _filterBlocked(page.items, blocked);
      // Real requests first; the samples follow after the last real page.
      final more = realItems.isNotEmpty && page.hasMore;
      final realIds = {for (final item in realItems) item.id};
      _pendingSamples = more ? demoItems : const [];

      if (realItems.isNotEmpty) {
        _nextOffset = page.nextOffset;
      }

      state = YordamKerakFeedState(
        isLoading: false,
        items: [
          ...realItems,
          if (!more)
            ...demoItems.where((item) => !realIds.contains(item.id)),
        ],
        hasMore: more,
        showingSamples: !more && demoItems.isNotEmpty,
      );
    } catch (error) {
      if (!mounted || generation != _loadGeneration) return;

      // No answer: what is already on screen stays; otherwise the samples
      // rather than an empty page.
      final items = keep ? previous.items : demoItems;
      state = YordamKerakFeedState(
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

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    final filter = _ref.read(feedFilterProvider);
    final language = _ref.read(onboardingPrefsProvider).language;
    final repo = _ref.read(yordamKerakRepositoryProvider);

    try {
      final results = await Future.wait<Object>([
        repo
            .fetchOpenPostsPage(
              categoryId: filter.categoryId,
              subcategoryId: filter.subcategoryId,
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

      final page = results[0] as FeedPage<YordamKerakFeedItem>;
      final blocked = results[1] as Set<String>;
      final newItems = _filterBlocked(page.items, blocked);
      _nextOffset = page.nextOffset;

      final seen = state.items.map((item) => item.id).toSet();
      final uniqueNewItems =
          newItems.where((item) => seen.add(item.id)).toList();
      // The last real page is in: the samples follow it.
      final samples = page.hasMore
          ? const <YordamKerakFeedItem>[]
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

  List<YordamKerakFeedItem> _filterBlocked(
    List<YordamKerakFeedItem> items,
    Set<String> blocked,
  ) {
    if (blocked.isEmpty) return items;

    return items
        .where(
          (item) =>
              item.authorId == null || !blocked.contains(item.authorId),
        )
        .toList();
  }

  List<YordamKerakFeedItem> _filterItems(
    List<YordamKerakFeedItem> items,
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
    if (filter.serviceCityId != null) {
      result = result
          .where((item) => item.serviceCity == filter.serviceCityId)
          .toList();
    }
    return result;
  }
}

final yordamKerakPostProvider =
    FutureProvider.family<YordamKerakFeedItem?, String>((ref, id) async {
  final language = ref.watch(onboardingPrefsProvider).language;
  final demo = DemoYordamKerakFeed.findById(id);
  if (demo != null) {
    final resolver = ref.watch(categoryLabelResolverProvider);
    await resolver.ensureLoaded();
    return resolver.localizeYordamKerak(demo, language);
  }

  return ref.watch(yordamKerakRepositoryProvider).fetchById(
        id: id,
        language: language,
      );
});
