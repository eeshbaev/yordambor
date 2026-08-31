import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/data/safety/block_repository.dart';
import 'package:yordambor/data/safety/report_repository.dart';

final blockRepositoryProvider = Provider<BlockRepository>((ref) {
  return BlockRepository();
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository();
});

final blockedUserIdsProvider = FutureProvider<Set<String>>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return {};
  return ref.watch(blockRepositoryProvider).fetchBlockedUserIds();
});

final blockedUsersProvider = FutureProvider<List<BlockedUser>>((ref) async {
  final session = ref.watch(sessionProvider);
  if (!session.isAuthenticated) return [];
  return ref.watch(blockRepositoryProvider).fetchBlockedUsers();
});
