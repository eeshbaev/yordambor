import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/notifications/subsector_alert_repository.dart';
import 'package:yordambor/domain/entities/subsector_alert_subscription.dart';

final subsectorAlertRepositoryProvider = Provider<SubsectorAlertRepository>(
  (ref) => SubsectorAlertRepository(),
);

final subsectorAlertsProvider =
    FutureProvider<List<SubsectorAlertSubscription>>((ref) async {
  final session = ref.watch(sessionProvider);
  if (session.isLoading || !session.isAuthenticated) return [];

  return ref
      .read(subsectorAlertRepositoryProvider)
      .fetchMine()
      .timeout(FeedConstants.networkTimeout);
});
