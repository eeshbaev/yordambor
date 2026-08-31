abstract final class FeedConstants {
  static const int pageSize = 20;
  static const Duration networkTimeout = Duration(seconds: 6);
  static const Duration feedFetchTimeout = Duration(seconds: 3);
  static const Duration blockedUsersTimeout = Duration(seconds: 2);
  static const Duration filterDebounce = Duration(milliseconds: 250);
}

class FeedPage<T> {
  const FeedPage({
    required this.items,
    required this.hasMore,
    required this.nextOffset,
  });

  final List<T> items;
  final bool hasMore;
  final int nextOffset;
}
