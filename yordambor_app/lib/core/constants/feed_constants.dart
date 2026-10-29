abstract final class FeedConstants {
  static const int pageSize = 20;

  /// Whether the bundled samples follow the real listings in both feeds.
  /// They stay until this is set to false.
  static const bool showSamples = true;
  static const Duration networkTimeout = Duration(seconds: 6);
  /// How long a feed page may take before the samples stand in. Slow
  /// mobile networks need more than a few seconds; placeholders show
  /// meanwhile.
  static const Duration feedFetchTimeout = Duration(seconds: 8);
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
