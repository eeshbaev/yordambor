import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/safety_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/demo/demo_xizmat_feed.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/core/utils/money_format.dart';

/// What a search found, and whether the server could be asked at all.
class XizmatSearchResult {
  const XizmatSearchResult({required this.items, this.failed = false});

  final List<XizmatFeedItem> items;

  /// The server did not answer; [items] are only what the phone has.
  final bool failed;
}

/// Services found by a provider's or an organization's name, the service's
/// own name, or its trade ("santexnik" finds plumbers), in any language.
/// Blocked people stay out; samples follow the real results, as in the
/// feed.
final xizmatSearchProvider = FutureProvider.autoDispose
    .family<XizmatSearchResult, String>((ref, query) async {
  final text = query.trim();
  if (text.length < 2) return const XizmatSearchResult(items: []);
  // "o'zbek", "o`zbek" and "oʻzbek" all match.
  final needle = normalizeUz(text);
  final language = ref.watch(onboardingPrefsProvider).language;

  // Trades whose name matches, in any of the four languages.
  final categories = await ref.watch(categoriesProvider.future);
  final trades = <String>{
    for (final category in categories)
      for (final sub in category.subcategories)
        if (sub.id != 'other' &&
            sub.names.values
                .any((name) => normalizeUz(name).contains(needle)))
          sub.id,
  };

  var failed = false;
  var real = <XizmatFeedItem>[];
  try {
    real = await ref
        .read(xizmatRepositoryProvider)
        .search(text, language: language, subcategoryIds: trades)
        .timeout(FeedConstants.networkTimeout);
  } catch (_) {
    failed = true;
  }

  Set<String> blocked;
  try {
    blocked = await ref
        .read(blockedUserIdsProvider.future)
        .timeout(FeedConstants.blockedUsersTimeout);
  } catch (_) {
    blocked = const {};
  }
  real = [
    for (final item in real)
      if (item.ownerId == null || !blocked.contains(item.ownerId)) item,
  ];

  var samples = const <XizmatFeedItem>[];
  if (FeedConstants.showSamples) {
    final resolver = ref.read(categoryLabelResolverProvider);
    await resolver.ensureLoaded();
    samples = [
      for (final item
          in resolver.localizeXizmatList(DemoXizmatFeed.items, language))
        if (_matches(item, needle, trades)) item,
    ];
  }

  return XizmatSearchResult(items: [...real, ...samples], failed: failed);
});

bool _matches(XizmatFeedItem item, String needle, Set<String> trades) {
  if (trades.contains(item.subcategoryId)) return true;
  for (final text in [
    item.name,
    item.ownerName ?? '',
    item.categoryLabel,
    item.subcategoryLabel,
  ]) {
    if (text.toLowerCase().contains(needle)) return true;
  }
  return false;
}
