import 'package:yordambor/core/l10n/app_strings.dart';

/// The app's strings in the language the person chose, for code with no
/// widget or provider at hand: repositories, entities, notification
/// channels. [appStringsProvider] keeps [language] in step.
abstract final class CurrentStrings {
  static String language = 'uz';

  static AppStrings get value => AppStrings.forLanguage(language);
}
