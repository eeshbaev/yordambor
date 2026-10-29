import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/l10n/current_strings.dart';

final appStringsProvider = Provider<AppStrings>((ref) {
  final language = ref.watch(onboardingPrefsProvider).language;
  // Code without a widget at hand (repositories, notifications) reads it.
  CurrentStrings.language = language;
  return AppStrings.forLanguage(language);
});
