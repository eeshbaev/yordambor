import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';

/// 4-point spacing. 16 is the phone gutter, 24 the tablet gutter, 32 the gap
/// between sections.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Three radii plus the pill (manual L-03, PR-01, PR-05).
///
/// 8: chips, inputs, badges, small tiles. 16: every card, one card style.
/// 20: sheets and dialogs. Pill: buttons, the tab bar, FABs, status pills.
/// Nested corners are concentric: inner radius = outer radius − padding.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 20;
  static const double pill = 999;

  // Role names used across the app.
  static const double xs = sm;
  static const double badge = sm;

  /// Small containers: tags, icon tiles, calendar cells.
  static const double chip = sm;
  static const double tile = sm;
  static const double field = sm;

  /// Segmented tracks and other large controls. Buttons are pills.
  static const double button = md;
  static const double card = md;
  static const double sheet = lg;
}

abstract final class AppTouch {
  static const double minTarget = 48;

  /// Screen actions.
  static const double buttonHeight = 56;

  /// Actions inside sheets.
  static const double buttonHeightMedium = 48;

  /// Actions inside cards (the touch target is still padded to 48).
  static const double buttonHeightSmall = 40;
}

/// Light-theme brand values.
///
/// These are constants, so they cannot follow dark mode. In widgets read
/// `context.ybColors` instead; these remain for brand surfaces (splash, logo)
/// and for code that has no BuildContext.
abstract final class AppColors {
  /// Registan deep teal: primary actions and text links.
  static const primary = Color(0xFF0A6A70);

  /// Teal ink: text on teal-soft.
  static const primaryDark = Color(0xFF074349);

  /// Teal in the dark theme.
  static const primaryLight = Color(0xFF4CC7C4);

  /// Teal soft: selected fills, tonal buttons.
  static const primaryMuted = Color(0xFFE0F1F1);

  /// Registan teal-brand: the logo and brand surfaces only.
  static const brand = Color(0xFF048289);

  /// Oʻrik apricot: the need, asking, negotiating.
  static const apricot = Color(0xFFF28A2E);
  static const apricotSoft = Color(0xFFFFEBD6);
  static const apricotInk = Color(0xFFA0500D);

  static const surface = Color(0xFFF2F6F6);
  static const card = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0F1F21);
  static const textSecondary = Color(0xFF4E5E60);
  static const success = Color(0xFF16774B);

  /// Text-safe warning (apricot ink).
  static const warning = Color(0xFFA0500D);
  static const error = Color(0xFFC0392F);
  static const border = Color(0xFFD8E0E0);
  static const skeleton = Color(0xFFE8EEEE);
  static const demoBadge = Color(0xFF637275);
  static const star = Color(0xFFF2B01E);

  /// On photos (any theme): a light pill with ink text, and status dots.
  static const onPhotoPill = Color(0xEBFFFFFF);
  static const onPhotoInk = Color(0xFF0F1F21);
  static const available = Color(0xFF1E9E62);
  static const neutralDot = Color(0xFF879496);
}

abstract final class AppShell {
  /// Height of [FloatingActionButton.extended] on the home Yordam Kerak tab.
  static const double extendedFabHeight = 56;

  /// When false, tab body ends above [NavigationBar] so it stays always visible.
  static const bool bodyExtendsBehindNav = false;

  /// Scroll inset for tab screens inside [MainShell].
  static double scrollBottomPadding(
    BuildContext context, {
    bool includeExtendedFab = false,
    int fabStack = 1,
  }) {
    // [fabStack] buttons one above the other, [AppSpacing.md] apart.
    final fabInset = includeExtendedFab
        ? extendedFabHeight * fabStack +
            AppSpacing.md * (fabStack - 1) +
            AppSpacing.lg
        : 0.0;

    if (!bodyExtendsBehindNav) {
      return AppSpacing.xl + fabInset;
    }

    final media = MediaQuery.of(context);
    final systemBottom = media.viewPadding.bottom;
    final navHeight =
        NavigationBarTheme.of(context).height ?? kBottomNavigationBarHeight;
    final shellInset = systemBottom > 0 ? 0.0 : AppSpacing.sm;
    return navHeight + systemBottom + shellInset + AppSpacing.xl + fabInset;
  }

  /// Bottom offset for the home Yordam Kerak FAB.
  static double homeFabBottomOffset(BuildContext context) {
    if (!bodyExtendsBehindNav) {
      return AppSpacing.lg;
    }

    final media = MediaQuery.of(context);
    final systemBottom = media.viewPadding.bottom;
    final navHeight =
        NavigationBarTheme.of(context).height ?? kBottomNavigationBarHeight;
    final shellInset = systemBottom > 0 ? 0.0 : AppSpacing.sm;
    return navHeight + systemBottom + shellInset + AppSpacing.lg;
  }
}

/// The type scale (manual Part 3). Onest at three weights (400, 600, 700);
/// Commissioner Flare only for [display]. Headings sit at 1.1–1.25× line
/// height, body text at 1.4–1.5×.
///
/// Colours here are the light values: at call sites set the colour from
/// `context.ybColors` so dark mode follows.
abstract final class AppTypography {
  static TextStyle _style({
    required double size,
    required FontWeight weight,
    required double lineHeight,
    Color? color,
    double? letterSpacing,
  }) {
    return AppFonts.ui(
      size: size,
      weight: weight,
      height: lineHeight / size,
      letterSpacing: letterSpacing,
      color: color ?? AppColors.textPrimary,
    );
  }

  /// Commissioner Flare 800 · 40/44. One line per screen, at most, and only
  /// in onboarding, celebrations and empty states.
  static TextStyle get display => AppFonts.displayStyle(
        size: 40,
        height: 44 / 40,
        letterSpacing: -0.4,
      );

  /// Onest 700 · 28/34. Page titles.
  static TextStyle get largeTitle => _style(
        size: 28,
        weight: FontWeight.w700,
        lineHeight: 34,
        letterSpacing: -0.4,
      );

  /// Onest 700 · 22/27. Section and sheet titles.
  static TextStyle get title => _style(
        size: 22,
        weight: FontWeight.w700,
        lineHeight: 27,
        letterSpacing: -0.25,
      );

  /// Onest 600 · 17/21. Card and row titles.
  static TextStyle get headline => _style(
        size: 17,
        weight: FontWeight.w600,
        lineHeight: 21,
        letterSpacing: -0.1,
      );

  /// Onest 400 · 15/21. Interface text and list subtitles.
  static TextStyle get body => _style(
        size: 15,
        weight: FontWeight.w400,
        lineHeight: 21,
      );

  /// Same as [body]; the name the design direction uses.
  static TextStyle get callout => body;

  /// Onest 400 · 16/24. Reading text: descriptions, messages, reviews.
  static TextStyle get bodyRegular => _style(
        size: 16,
        weight: FontWeight.w400,
        lineHeight: 24,
      );

  /// Onest 400 · 13/18. Meta lines: time, place, counts.
  static TextStyle get caption => _style(
        size: 13,
        weight: FontWeight.w400,
        lineHeight: 18,
        color: AppColors.textSecondary,
      );

  /// Onest 600 · 12/16. Badges and small labels.
  static TextStyle get label => _style(
        size: 12,
        weight: FontWeight.w600,
        lineHeight: 16,
        letterSpacing: 0.1,
        color: AppColors.textSecondary,
      );

  /// Onest 600 · 16/20. Button labels.
  static TextStyle get button => _style(
        size: 16,
        weight: FontWeight.w600,
        lineHeight: 20,
        letterSpacing: -0.08,
        color: Colors.white,
      );

  /// Onest 700 · 17/20 with tabular figures: "120 000 soʻm".
  static TextStyle get price => _style(
        size: 17,
        weight: FontWeight.w700,
        lineHeight: 20,
        letterSpacing: -0.17,
      ).copyWith(fontFeatures: AppFonts.tabular);

  /// Adds tabular figures to any style, for counts and times.
  static TextStyle tabular(TextStyle style) =>
      style.copyWith(fontFeatures: AppFonts.tabular);
}
