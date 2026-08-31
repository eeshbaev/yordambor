import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/earnings_providers.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_sync_result.dart';

Future<KelishuvSyncResult> syncProviderToolsFromKelishuv(
  WidgetRef ref,
  Kelishuv kelishuv,
  String? userId,
) async {
  if (userId == null) return const KelishuvSyncResult();
  if (kelishuv.status != KelishuvStatus.jarayonda) {
    return const KelishuvSyncResult();
  }

  final result = await ref.read(providerToolsServiceProvider).syncFromKelishuv(
        kelishuv,
        userId,
      );

  if (result.synced) {
    invalidateProviderTools(ref);
  }

  return result;
}

void invalidateProviderTools(WidgetRef ref) {
  ref.invalidate(clientRegistryProvider);
  ref.invalidate(bookingsProvider);
  ref.invalidate(earningsRowsProvider);
  ref.invalidate(remindersProvider);
}
