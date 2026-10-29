import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/data/review/review_repository.dart';
import 'package:yordambor/domain/entities/review.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository();
});

final xizmatReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, xizmatId) async {
  return ref.watch(reviewRepositoryProvider).fetchForXizmat(xizmatId);
});

/// The average and the count for each star, over all of a service's
/// reviews: what its page shows on top and above the reviews.
final xizmatRatingSummaryProvider =
    FutureProvider.family<RatingSummary, String>((ref, xizmatId) async {
  final ratings =
      await ref.watch(reviewRepositoryProvider).fetchRatings(xizmatId);
  return RatingSummary.fromRatings(ratings);
});

final kelishuvReviewProvider =
    FutureProvider.family<Review?, String>((ref, kelishuvId) async {
  return ref.watch(reviewRepositoryProvider).fetchForKelishuv(kelishuvId);
});
