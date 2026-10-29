import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/subsector_alert_providers.dart';
import 'package:yordambor/domain/entities/subsector_alert_subscription.dart';

/// Alerts for new services in a trade, for both kinds of provider. Keeps
/// whatever else the person already asked to hear. False when it failed.
Future<bool> subscribeToNewServices(
  WidgetRef ref, {
  required String categoryId,
  required String subcategoryId,
}) {
  return _subscribe(
    ref,
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    providerTypes: const ['individual', 'institution'],
    newService: true,
  );
}

/// Alerts for new requests in a trade. False when it failed.
Future<bool> subscribeToHelpPosts(
  WidgetRef ref, {
  required String categoryId,
  required String subcategoryId,
}) {
  // Request alerts do not depend on the kind of provider; one row will do.
  return _subscribe(
    ref,
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    providerTypes: const ['individual'],
    helpPost: true,
  );
}

Future<bool> _subscribe(
  WidgetRef ref, {
  required String categoryId,
  required String subcategoryId,
  required List<String> providerTypes,
  bool newService = false,
  bool helpPost = false,
}) async {
  if (categoryId.isEmpty || subcategoryId.isEmpty) return false;
  final repo = ref.read(subsectorAlertRepositoryProvider);
  try {
    final existing = await repo.fetchMine();
    for (final type in providerTypes) {
      SubsectorAlertSubscription? current;
      for (final item in existing) {
        if (item.categoryId == categoryId &&
            item.subcategoryId == subcategoryId &&
            item.providerType == type) {
          current = item;
        }
      }
      if (current != null) {
        await repo.updateFlags(
          id: current.id,
          alertNewService: current.alertNewService || newService,
          alertDiscount: current.alertDiscount,
          alertHelpPost: current.alertHelpPost || helpPost,
        );
      } else {
        await repo.upsert(
          UpsertSubsectorAlertInput(
            categoryId: categoryId,
            subcategoryId: subcategoryId,
            providerType: type,
            alertNewService: newService,
            alertDiscount: false,
            alertHelpPost: helpPost,
          ),
        );
      }
    }
    ref.invalidate(subsectorAlertsProvider);
    return true;
  } catch (_) {
    // The request itself is out; the alert can be set from notifications.
    return false;
  }
}
