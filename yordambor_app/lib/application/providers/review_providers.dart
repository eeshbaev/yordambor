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

final kelishuvReviewProvider =
    FutureProvider.family<Review?, String>((ref, kelishuvId) async {
  return ref.watch(reviewRepositoryProvider).fetchForKelishuv(kelishuvId);
});
