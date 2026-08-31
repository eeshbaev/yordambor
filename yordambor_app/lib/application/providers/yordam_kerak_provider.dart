import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/safety_providers.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/demo/demo_feed_support.dart';
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
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final List<YordamKerakFeedItem> items;
  final String? errorMessage;

  YordamKerakFeedState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    List<YordamKerakFeedItem>? items,
    String? errorMessage,
  }) {
    return YordamKerakFeedState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      items: items ?? this.items,
      errorMessage: errorMessage,
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
    final repo = _ref.read(yordamKerakRepositoryProvider);
    final labelResolver = _ref.read(categoryLabelResolverProvider);
    await labelResolver.ensureLoaded();
    final demoItems = _filterItems(
      labelResolver.localizeYordamKerakList(
        DemoYordamKerakFeed.items,
        language,
      ),
      filter,
    );

    state = YordamKerakFeedState(
      isLoading: demoItems.isEmpty,
      items: demoItems,
    );

    try {
      final results = await Future.wait<Object>([
        repo
            .fetchOpenPostsPage(
              categoryId: filter.categoryId,
              subcategoryId: filter.subcategoryId,
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
      final items = DemoFeedSupport.mergeRealAndDemo(
        realItems: realItems,
        demoItems: demoItems,
      );

      if (realItems.isNotEmpty) {
        _nextOffset = page.nextOffset;
      }

      state = YordamKerakFeedState(
        isLoading: false,
        items: items,
        hasMore: realItems.isNotEmpty && page.hasMore,
      );
    } catch (error) {
      if (!mounted || generation != _loadGeneration) return;

      state = YordamKerakFeedState(
        isLoading: false,
        items: demoItems,
        hasMore: false,
        errorMessage: demoItems.isEmpty ? error.toString() : null,
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

      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...newItems],
        hasMore: page.hasMore,
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
