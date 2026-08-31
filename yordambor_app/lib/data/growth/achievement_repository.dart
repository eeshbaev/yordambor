import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/domain/growth/achievement.dart';

class AchievementRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<List<AchievementUnlock>> fetchUnlocked(String profileId) async {
    final client = _client;
    if (client == null) return [];

    final rows = await client
        .from('profile_achievements')
        .select('achievement_id, unlocked_at')
        .eq('profile_id', profileId)
        .order('unlocked_at');

    return (rows as List<dynamic>).map((raw) {
      final map = raw as Map<String, dynamic>;
      return AchievementUnlock(
        id: map['achievement_id'] as String,
        unlockedAt: DateTime.parse(map['unlocked_at'] as String),
      );
    }).toList();
  }

  Future<List<String>> syncUnlocks({
    required String profileId,
    required List<String> computedIds,
  }) async {
    final client = _client;
    if (client == null) return computedIds;

    final existing = await fetchUnlocked(profileId);
    final existingIds = existing.map((e) => e.id).toSet();
    final newlyUnlocked = <String>[];

    for (final id in computedIds) {
      if (existingIds.contains(id)) continue;
      await client.from('profile_achievements').insert({
        'profile_id': profileId,
        'achievement_id': id,
      });
      newlyUnlocked.add(id);
    }

    return newlyUnlocked;
  }
}
