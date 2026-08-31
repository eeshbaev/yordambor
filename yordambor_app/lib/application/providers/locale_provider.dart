import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

final appStringsProvider = Provider<AppStrings>((ref) {
  final language = ref.watch(onboardingPrefsProvider).language;
  return AppStrings.forLanguage(language);
});
