import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/data/onboarding/onboarding_prefs_repository.dart';

final onboardingPrefsRepositoryProvider =
    Provider<OnboardingPrefsRepository>((ref) {
  return OnboardingPrefsRepository();
});

class OnboardingPrefsState {
  const OnboardingPrefsState({
    this.isLoaded = false,
    this.welcomeSeen = false,
    this.providerPromptDismissed = false,
    this.language = 'uz',
    this.themeMode = ThemeMode.system,
    this.onboardingDone = false,
    this.onboardingGoal,
    this.providerTypePreference,
  });

  final bool isLoaded;
  final bool welcomeSeen;
  final bool providerPromptDismissed;
  final String language;
  final ThemeMode themeMode;

  /// The introduction and its two questions were finished (or skipped).
  final bool onboardingDone;

  /// `needHelp`, `offer` or `both`.
  final String? onboardingGoal;

  /// `individual` or `institution`; new services start with it.
  final String? providerTypePreference;

  OnboardingPrefsState copyWith({
    bool? isLoaded,
    bool? welcomeSeen,
    bool? providerPromptDismissed,
    String? language,
    ThemeMode? themeMode,
    bool? onboardingDone,
    String? onboardingGoal,
    String? providerTypePreference,
  }) {
    return OnboardingPrefsState(
      isLoaded: isLoaded ?? this.isLoaded,
      welcomeSeen: welcomeSeen ?? this.welcomeSeen,
      providerPromptDismissed:
          providerPromptDismissed ?? this.providerPromptDismissed,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      onboardingGoal: onboardingGoal ?? this.onboardingGoal,
      providerTypePreference:
          providerTypePreference ?? this.providerTypePreference,
    );
  }
}

final onboardingPrefsProvider =
    StateNotifierProvider<OnboardingPrefsNotifier, OnboardingPrefsState>(
        (ref) {
  return OnboardingPrefsNotifier(ref.watch(onboardingPrefsRepositoryProvider));
});

class OnboardingPrefsNotifier extends StateNotifier<OnboardingPrefsState> {
  OnboardingPrefsNotifier(this._repository)
      : super(const OnboardingPrefsState()) {
    load();
  }

  final OnboardingPrefsRepository _repository;

  Future<void> load() async {
    final snapshot = await _repository.loadAll();

    state = OnboardingPrefsState(
      isLoaded: true,
      welcomeSeen: snapshot.welcomeSeen,
      providerPromptDismissed: snapshot.providerPromptDismissed,
      language: snapshot.language,
      themeMode: snapshot.themeMode,
      onboardingDone: snapshot.onboardingDone,
      onboardingGoal: snapshot.onboardingGoal,
      providerTypePreference: snapshot.providerTypePreference,
    );
  }

  /// Onboarding is over, with what the person chose (if anything).
  Future<void> completeOnboarding({
    String? goal,
    String? providerType,
  }) async {
    await _repository.completeOnboarding(
      goal: goal,
      providerType: providerType,
    );
    state = state.copyWith(
      onboardingDone: true,
      welcomeSeen: true,
      onboardingGoal: goal,
      providerTypePreference: providerType,
    );
  }

  Future<void> markWelcomeSeen() async {
    await _repository.setWelcomeSeen();
    state = state.copyWith(welcomeSeen: true);
  }

  Future<void> dismissProviderPrompt() async {
    await _repository.dismissProviderPrompt();
    state = state.copyWith(providerPromptDismissed: true);
  }

  Future<void> setLanguage(String code) async {
    await _repository.setLanguage(code);
    state = state.copyWith(language: code);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repository.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }
}
