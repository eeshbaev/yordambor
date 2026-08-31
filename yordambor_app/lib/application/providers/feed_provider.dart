import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/safety_providers.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/demo/demo_feed_support.dart';
import 'package:yordambor/data/demo/demo_xizmat_feed.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

class FeedState {
  const FeedState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.items = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final List<XizmatFeedItem> items;
  final String? errorMessage;

  FeedState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    List<XizmatFeedItem>? items,
    String? errorMessage,
  }) {
    return FeedState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      items: items ?? this.items,
      errorMessage: errorMessage,
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
    final labelResolver = _ref.read(categoryLabelResolverProvider);
    await labelResolver.ensureLoaded();
    final demoItems = _filterItems(
      labelResolver.localizeXizmatList(DemoXizmatFeed.items, language),
      filter,
    );
    final instantItems = DemoFeedSupport.composePinned<XizmatFeedItem>(
      pinnedItems: const <XizmatFeedItem>[],
      realItems: const <XizmatFeedItem>[],
      demoItems: demoItems,
      idOf: (item) => item.id,
    );

    state = FeedState(
      isLoading: instantItems.isEmpty,
      items: instantItems,
    );

    final repo = _ref.read(xizmatRepositoryProvider);

    try {
      final results = await Future.wait<Object>([
        repo
            .fetchFeedPage(
              categoryId: filter.categoryId,
              subcategoryId: filter.subcategoryId,
              providerType: filter.providerType,
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
      final items = DemoFeedSupport.composePinned(
        pinnedItems: myItems,
        realItems: realItems,
        demoItems: demoItems,
        idOf: (item) => item.id,
      );

      if (realItems.isNotEmpty) {
        _nextOffset = page.nextOffset;
      }

      state = FeedState(
        isLoading: false,
        items: items,
        hasMore: realItems.isNotEmpty && page.hasMore,
      );
    } catch (error) {
      if (!mounted || generation != _loadGeneration) return;

      state = FeedState(
        isLoading: false,
        items: state.items,
        hasMore: false,
        errorMessage: state.items.isEmpty ? error.toString() : null,
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
    final repo = _ref.read(xizmatRepositoryProvider);

    try {
      final results = await Future.wait<Object>([
        repo
            .fetchFeedPage(
              categoryId: filter.categoryId,
              subcategoryId: filter.subcategoryId,
              providerType: filter.providerType,
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

      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...uniqueNewItems],
        hasMore: page.hasMore,
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
          .timeout(FeedConstants.feedFetchTimeout);
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
    return result;
  }
}
