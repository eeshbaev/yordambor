import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yordambor/domain/growth/app_review_prompt.dart';

const _keyLastPrompt = 'app_review_last_prompt_at';
const _keySnoozeUntil = 'app_review_snooze_until';
const _keyCompletedCount = 'app_review_completed_kelishuv_count';
const _keyCelebrated = 'celebrated_achievements';

class AppReviewPrefsStore {
  Future<AppReviewPrefs> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppReviewPrefs(
      lastPromptAt: _parse(prefs.getString(_keyLastPrompt)),
      snoozeUntil: _parse(prefs.getString(_keySnoozeUntil)),
      completedKelishuvCount: prefs.getInt(_keyCompletedCount) ?? 0,
    );
  }

  Future<void> recordCompletedKelishuv() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_keyCompletedCount) ?? 0;
    await prefs.setInt(_keyCompletedCount, count + 1);
  }

  Future<void> recordPromptShown(DateTime now) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastPrompt, now.toIso8601String());
  }

  Future<void> snooze(DateTime until) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySnoozeUntil, until.toIso8601String());
  }

  DateTime? _parse(String? raw) =>
      raw == null ? null : DateTime.tryParse(raw);
}

class AchievementCelebrationStore {
  Future<Set<String>> loadCelebrated() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyCelebrated);
    return raw?.toSet() ?? {};
  }

  Future<void> markCelebrated(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    final set = await loadCelebrated();
    set.add(achievementId);
    await prefs.setStringList(_keyCelebrated, set.toList());
  }

  Future<void> markAllCelebrated(Iterable<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final set = await loadCelebrated()..addAll(ids);
    await prefs.setStringList(_keyCelebrated, set.toList());
  }
}

final appReviewPrefsStoreProvider = Provider<AppReviewPrefsStore>((ref) {
  return AppReviewPrefsStore();
});

final achievementCelebrationStoreProvider =
    Provider<AchievementCelebrationStore>((ref) {
  return AchievementCelebrationStore();
});
