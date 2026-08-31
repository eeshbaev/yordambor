import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPrefsSnapshot {
  const OnboardingPrefsSnapshot({
    required this.welcomeSeen,
    required this.providerPromptDismissed,
    required this.language,
    required this.themeMode,
  });

  final bool welcomeSeen;
  final bool providerPromptDismissed;
  final String language;
  final ThemeMode themeMode;
}

class OnboardingPrefsRepository {
  static const welcomeSeenKey = 'welcome_seen';
  static const providerPromptDismissedKey = 'provider_prompt_dismissed';
  static const languageKey = 'app_language';
  static const themeModeKey = 'theme_mode';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _instance() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<OnboardingPrefsSnapshot> loadAll() async {
    final prefs = await _instance();
    return OnboardingPrefsSnapshot(
      welcomeSeen: prefs.getBool(welcomeSeenKey) ?? false,
      providerPromptDismissed:
          prefs.getBool(providerPromptDismissedKey) ?? false,
      language: prefs.getString(languageKey) ?? 'uz',
      themeMode: switch (prefs.getString(themeModeKey)) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      },
    );
  }

  Future<bool> isWelcomeSeen() async {
    final prefs = await _instance();
    return prefs.getBool(welcomeSeenKey) ?? false;
  }

  Future<void> setWelcomeSeen() async {
    final prefs = await _instance();
    await prefs.setBool(welcomeSeenKey, true);
  }

  Future<bool> isProviderPromptDismissed() async {
    final prefs = await _instance();
    return prefs.getBool(providerPromptDismissedKey) ?? false;
  }

  Future<void> dismissProviderPrompt() async {
    final prefs = await _instance();
    await prefs.setBool(providerPromptDismissedKey, true);
  }

  Future<String> getLanguage() async {
    final prefs = await _instance();
    return prefs.getString(languageKey) ?? 'uz';
  }

  Future<void> setLanguage(String code) async {
    final prefs = await _instance();
    await prefs.setString(languageKey, code);
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await _instance();
    return switch (prefs.getString(themeModeKey)) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await _instance();
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await prefs.setString(themeModeKey, value);
  }
}
