import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

/// The first providers on YordamBor. Every real service added before
/// [until] keeps the "First on YordamBor" badge for good; samples never
/// have it. Move [until] to end the founding period sooner or later.
abstract final class FoundingProviders {
  static final until = DateTime.utc(2027, 7, 1);

  static bool isFounding(XizmatFeedItem item) {
    if (item.isDemo) return false;
    final created = item.createdAt;
    return created != null && created.isBefore(until);
  }
}
