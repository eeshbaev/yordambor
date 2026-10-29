import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

/// Bundled type families.
///
/// Onest (400–700) is the interface face: it draws Uzbek ʻ ʼ and Cyrillic
/// ў қ ғ ҳ properly. Commissioner Flare (800) is for display moments only:
/// onboarding, celebrations and empty states, at most one line per screen.
/// Both are static, subset instances of the OFL variable fonts in
/// `assets/fonts/`.
abstract final class AppFonts {
  static const family = 'Onest';
  static const display = 'CommissionerFlare';

  /// Prices, counts and times line up in columns.
  static const tabular = [FontFeature.tabularFigures()];

  /// Adds the fonts' SIL Open Font Licences to the app's licence page.
  static void registerLicenses() {
    LicenseRegistry.addLicense(() async* {
      const licences = [
        ('Onest', 'assets/fonts/OFL-Onest.txt'),
        ('Commissioner', 'assets/fonts/OFL-Commissioner.txt'),
        ('Material Symbols', 'assets/fonts/LICENSE-MaterialSymbols.txt'),
      ];
      for (final (name, asset) in licences) {
        yield LicenseEntryWithLineBreaks(
          [name],
          await rootBundle.loadString(asset),
        );
      }
    });
  }

  static TextStyle ui({
    required double size,
    required FontWeight weight,
    required double height,
    Color? color,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      height: height,
      leadingDistribution: TextLeadingDistribution.even,
      letterSpacing: letterSpacing,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle displayStyle({
    required double size,
    required double height,
    Color? color,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: display,
      fontSize: size,
      fontWeight: FontWeight.w800,
      height: height,
      leadingDistribution: TextLeadingDistribution.even,
      letterSpacing: letterSpacing,
      color: color ?? AppColors.textPrimary,
    );
  }
}
