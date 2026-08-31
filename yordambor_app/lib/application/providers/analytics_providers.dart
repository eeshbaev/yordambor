import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/data/analytics/analytics_repository.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

final xizmatAnalyticsProvider =
    FutureProvider.family<XizmatAnalytics, String>((ref, xizmatId) async {
  return ref.watch(analyticsRepositoryProvider).fetchForXizmat(xizmatId);
});
