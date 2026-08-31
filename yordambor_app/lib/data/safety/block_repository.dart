import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';

class BlockFailure implements Exception {
  BlockFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class BlockedUser {
  const BlockedUser({
    required this.userId,
    required this.fullName,
    required this.blockedAt,
  });

  final String userId;
  final String fullName;
  final DateTime blockedAt;
}

class BlockRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<Set<String>> fetchBlockedUserIds() async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) return {};

    final rows = await client
        .from('blocks')
        .select('blocked_id')
        .eq('blocker_id', userId);

    return (rows as List<dynamic>)
        .map((row) => (row as Map<String, dynamic>)['blocked_id'] as String)
        .toSet();
  }

  Future<List<BlockedUser>> fetchBlockedUsers() async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) return [];

    final rows = await client
        .from('blocks')
        .select('''
          blocked_id,
          created_at,
          profiles!blocks_blocked_id_fkey ( full_name )
        ''')
        .eq('blocker_id', userId)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final profile = map['profiles'] as Map<String, dynamic>?;
      return BlockedUser(
        userId: map['blocked_id'] as String,
        fullName: profile?['full_name'] as String? ?? 'Foydalanuvchi',
        blockedAt: DateTime.parse(map['created_at'] as String),
      );
    }).toList();
  }

  Future<void> blockUser(String blockedId) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw BlockFailure('Kirish talab qilinadi');
    }
    if (blockedId == userId) {
      throw BlockFailure('O\'zingizni bloklab bo\'lmaydi');
    }

    await client.from('blocks').upsert({
      'blocker_id': userId,
      'blocked_id': blockedId,
    });
  }

  Future<void> unblockUser(String blockedId) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw BlockFailure('Kirish talab qilinadi');
    }

    await client
        .from('blocks')
        .delete()
        .eq('blocker_id', userId)
        .eq('blocked_id', blockedId);
  }

  Future<void> assertCanInteract(String otherUserId) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) return;
    if (otherUserId == userId) return;

    final rows = await client
        .from('blocks')
        .select('blocker_id, blocked_id')
        .or(
          'and(blocker_id.eq.$userId,blocked_id.eq.$otherUserId),and(blocker_id.eq.$otherUserId,blocked_id.eq.$userId)',
        );

    if ((rows as List).isNotEmpty) {
      throw BlockFailure('Bu foydalanuvchi bilan aloqa bloklangan');
    }
  }
}
