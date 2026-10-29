import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yordambor/data/onboarding/onboarding_prefs_repository.dart';
import 'package:yordambor/domain/entities/request_draft.dart';

/// Small per-device memory for the first minute of a launch: when the app
/// was last opened, which "What's new" was seen, and an unfinished request.
class ExperiencePrefsRepository {
  static const lastOpenKey = 'yb_last_open_at';
  static const firstOpenKey = 'yb_first_open_at';
  static const whatsNewSeenKey = 'yb_whats_new_seen';
  static const requestDraftKey = 'yb_request_draft';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _instance() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  /// Records this launch; returns the previous one (null on a first launch).
  /// The first launch is kept too, for the store-rating rules.
  Future<DateTime?> recordOpen(DateTime now) async {
    final prefs = await _instance();
    final previous = prefs.getInt(lastOpenKey);
    await prefs.setInt(lastOpenKey, now.millisecondsSinceEpoch);
    if (!prefs.containsKey(firstOpenKey)) {
      await prefs.setInt(firstOpenKey, now.millisecondsSinceEpoch);
    }
    return previous == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(previous);
  }

  /// Written by onboarding; read here to tell a fresh install from an
  /// update.
  Future<bool> isWelcomeSeen() async {
    final prefs = await _instance();
    return prefs.getBool(OnboardingPrefsRepository.welcomeSeenKey) ?? false;
  }

  Future<int?> whatsNewSeen() async {
    final prefs = await _instance();
    return prefs.getInt(whatsNewSeenKey);
  }

  Future<void> setWhatsNewSeen(int version) async {
    final prefs = await _instance();
    await prefs.setInt(whatsNewSeenKey, version);
  }

  Future<RequestDraft?> loadDraft() async {
    final prefs = await _instance();
    final raw = prefs.getString(requestDraftKey);
    if (raw == null) return null;
    try {
      return RequestDraft.fromJson(jsonDecode(raw));
    } on FormatException {
      return null;
    }
  }

  Future<void> saveDraft(RequestDraft draft) async {
    final prefs = await _instance();
    await prefs.setString(requestDraftKey, jsonEncode(draft.toJson()));
  }

  Future<void> clearDraft() async {
    final prefs = await _instance();
    await prefs.remove(requestDraftKey);
  }
}
