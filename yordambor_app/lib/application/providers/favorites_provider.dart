import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/config/env.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier(this._ref) : super({}) {
    _ready = _load();
  }

  final Ref _ref;
  late final Future<void> _ready;

  static const _storageKey = 'favorite_xizmat_ids';

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];
    state = stored.toSet();
  }

  Future<bool> toggle(String id) async {
    await _ready;

    final next = Set<String>.from(state);
    final adding = !next.contains(id);

    if (adding) {
      next.add(id);
    } else {
      next.remove(id);
    }
    state = next;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, next.toList());
    _ref.invalidate(favoriteXizmatlarProvider);

    if (_isUuid(id)) {
      await _syncRemote(id, adding: adding);
    }

    return adding;
  }

  bool _isUuid(String id) =>
      !id.startsWith('demo-') &&
      RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      ).hasMatch(id);

  Future<void> _syncRemote(String xizmatId, {required bool adding}) async {
    final client = _client;
    final userId = _ref.read(sessionProvider).user?.id;
    if (client == null || userId == null) return;

    try {
      if (adding) {
        await client.from('favorites').upsert({
          'user_id': userId,
          'xizmat_id': xizmatId,
        });
      } else {
        await client.from('favorites').delete().match({
          'user_id': userId,
          'xizmat_id': xizmatId,
        });
      }
      _ref.invalidate(favoriteXizmatlarProvider);
    } catch (_) {
      // Local favorite still works offline.
    }
  }

  Future<void> syncToAccountAfterLogin() async {
    await _ready;
    final client = _client;
    final userId = _ref.read(sessionProvider).user?.id;
    if (client == null || userId == null) return;

    try {
      final rows = await client
          .from('favorites')
          .select('xizmat_id')
          .eq('user_id', userId);
      final remoteIds = (rows as List)
          .map((row) => row['xizmat_id'] as String)
          .toSet();
      final merged = {...state, ...remoteIds};
      state = merged;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, merged.toList());

      for (final id in merged) {
        if (_isUuid(id)) {
          await client.from('favorites').upsert({
            'user_id': userId,
            'xizmat_id': id,
          });
        }
      }
      _ref.invalidate(favoriteXizmatlarProvider);
    } catch (_) {
      // Local favorites remain available offline.
    }
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref);
});
