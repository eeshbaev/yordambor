/// Helpers for mixing demo listings into home feeds.
///
/// Demos stay visible until removed from [DemoXizmatFeed] / [DemoYordamKerakFeed].
abstract final class DemoFeedSupport {
  static List<T> mergeRealAndDemo<T>({
    required List<T> realItems,
    required List<T> demoItems,
  }) {
    if (demoItems.isEmpty) return realItems;
    if (realItems.isEmpty) return demoItems;
    return [...realItems, ...demoItems];
  }

  static List<T> composePinned<T>({
    required List<T> pinnedItems,
    required List<T> realItems,
    required List<T> demoItems,
    required String Function(T item) idOf,
  }) {
    final seen = <String>{};
    final result = <T>[];

    void add(T item) {
      final id = idOf(item);
      if (seen.add(id)) result.add(item);
    }

    for (final item in pinnedItems) {
      add(item);
    }
    for (final item in realItems) {
      final id = idOf(item);
      // Bundled demos always win — Supabase must not override demo-* listings.
      if (id.startsWith('demo-')) continue;
      add(item);
    }
    for (final item in demoItems) {
      add(item);
    }

    return result;
  }

  static List<T> withoutDemos<T>(
    List<T> items,
    bool Function(T item) isDemo,
  ) =>
      items.where((item) => !isDemo(item)).toList(growable: false);

  static List<T> onlyDemos<T>(
    List<T> items,
    bool Function(T item) isDemo,
  ) =>
      items.where(isDemo).toList(growable: false);
}
