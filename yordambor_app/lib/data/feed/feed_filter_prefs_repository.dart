import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const feedFilterPrefsKey = 'home_feed_filters_v1';

final feedFilterPrefsRepositoryProvider = Provider<FeedFilterPrefsRepository>(
  (ref) => FeedFilterPrefsRepository(),
);

class FeedFilterPrefsRepository {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _instance() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<Map<String, dynamic>?> load() async {
    final prefs = await _instance();
    final raw = prefs.getString(feedFilterPrefsKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final json = jsonDecode(raw);
      return json is Map<String, dynamic> ? json : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> save(Map<String, dynamic> json) async {
    final prefs = await _instance();
    await prefs.setString(feedFilterPrefsKey, jsonEncode(json));
  }

  Future<void> clear() async {
    final prefs = await _instance();
    await prefs.remove(feedFilterPrefsKey);
  }
}
