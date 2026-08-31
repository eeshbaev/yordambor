import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/safety_providers.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/kelishuv/kelishuv_repository.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_message.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';

final kelishuvRepositoryProvider = Provider<KelishuvRepository>((ref) {
  return KelishuvRepository(ref.watch(blockRepositoryProvider));
});

final kelishuvDetailProvider =
    FutureProvider.family<Kelishuv?, String>((ref, id) async {
  return ref
      .watch(kelishuvRepositoryProvider)
      .fetchById(id)
      .timeout(FeedConstants.networkTimeout);
});

final kelishuvMessagesProvider =
    FutureProvider.family<List<KelishuvMessage>, String>((ref, kelishuvId) async {
  return ref
      .watch(kelishuvRepositoryProvider)
      .fetchMessages(kelishuvId)
      .timeout(FeedConstants.networkTimeout);
});

final incomingKelishuvProvider =
    FutureProvider<List<KelishuvInboxGroup>>((ref) async {
  final userId = ref.watch(sessionProvider).user?.id;
  if (userId == null) return [];
  return ref
      .watch(kelishuvRepositoryProvider)
      .fetchIncomingGrouped(userId)
      .timeout(FeedConstants.networkTimeout);
});

final kelishuvInboxForXizmatProvider = FutureProvider.family<
    List<KelishuvSummary>,
    String>((ref, xizmatId) async {
  final userId = ref.watch(sessionProvider).user?.id;
  if (userId == null) return [];
  return ref
      .watch(kelishuvRepositoryProvider)
      .fetchIncomingForXizmat(xizmatId, userId)
      .timeout(FeedConstants.networkTimeout);
});

final myKelishuvRequestsProvider =
    FutureProvider<List<KelishuvSummary>>((ref) async {
  final userId = ref.watch(sessionProvider).user?.id;
  if (userId == null) return [];
  return ref
      .watch(kelishuvRepositoryProvider)
      .fetchMyRequests(userId)
      .timeout(FeedConstants.networkTimeout);
});

final archivedKelishuvProvider =
    FutureProvider<List<KelishuvSummary>>((ref) async {
  final userId = ref.watch(sessionProvider).user?.id;
  if (userId == null) return [];
  return ref
      .watch(kelishuvRepositoryProvider)
      .fetchArchived(userId)
      .timeout(FeedConstants.networkTimeout);
});

final pendingKelishuvActionsProvider = FutureProvider<int>((ref) async {
  final userId = ref.watch(sessionProvider).user?.id;
  if (userId == null) return 0;

  final incoming = await ref.watch(incomingKelishuvProvider.future);
  final requests = await ref.watch(myKelishuvRequestsProvider.future);

  var count = 0;
  for (final group in incoming) {
    for (final item in group.items) {
      if (item.needsMyAccept) count++;
      if (item.needsMyComplete) count++;
    }
  }
  for (final item in requests) {
    if (item.needsMyAccept) count++;
    if (item.needsMyComplete) count++;
  }
  return count;
});
