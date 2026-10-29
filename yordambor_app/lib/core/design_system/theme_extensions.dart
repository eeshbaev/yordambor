import 'package:flutter/material.dart';

/// YordamBor colour roles for the light and dark themes.
///
/// Teal is the help: providers, agreement, navigation and every "yes".
/// Apricot is the need: requests, the "Yordam soʻrash" composer and the
/// negotiating state. Green only means "done"; red only means errors and
/// destructive actions. Text on a soft container always uses the matching
/// `-Ink` role.
///
/// Every text pair here passes 4.5:1 in both themes. Read colours with
/// `context.ybColors` so they follow the theme; the static `AppColors` are the
/// light values only.
@immutable
class YbThemeColors extends ThemeExtension<YbThemeColors> {
  const YbThemeColors({
    required this.surface,
    required this.surfaceElevated,
    required this.card,
    required this.surface2,
    required this.surface3,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.borderSubtle,
    required this.outline,
    required this.teal,
    required this.tealBrand,
    required this.tealSoft,
    required this.tealInk,
    required this.onTeal,
    required this.apricot,
    required this.apricotSoft,
    required this.apricotInk,
    required this.onApricot,
    required this.success,
    required this.successSoft,
    required this.error,
    required this.errorSoft,
    required this.onError,
    required this.star,
    required this.heart,
    required this.place,
    required this.placeSoft,
    required this.placeInk,
    required this.skeleton,
    required this.overlay,
    required this.shadow,
  });

  /// Page background ("bg" in the design direction).
  final Color surface;

  /// Bars and sheets that sit above the page.
  final Color surfaceElevated;

  /// Cards, fields and sheets ("surface" in the design direction).
  final Color card;

  /// Quiet fills: segmented tracks, facts, skeletons, disabled buttons.
  final Color surface2;

  /// Image placeholders and pressed fills.
  final Color surface3;

  /// Text, in three steps.
  final Color ink;
  final Color ink2;
  final Color ink3;

  /// Hairlines and dividers.
  final Color line;

  /// Card edges in the dark theme, list separators.
  final Color borderSubtle;

  /// Input and secondary-button outlines (3:1 against [card]).
  final Color outline;

  /// The help: primary actions, links, navigation, agreed deals.
  final Color teal;

  /// Logo and brand surfaces only.
  final Color tealBrand;
  final Color tealSoft;
  final Color tealInk;
  final Color onTeal;

  /// The need: requests, asking, negotiating.
  final Color apricot;
  final Color apricotSoft;
  final Color apricotInk;
  final Color onApricot;

  /// Done.
  final Color success;
  final Color successSoft;

  /// Errors and destructive actions.
  final Color error;
  final Color errorSoft;
  final Color onError;

  final Color star;

  /// A saved (filled) heart.
  final Color heart;

  /// Where: the city on listings, always with a pin. Violet, so it never
  /// reads as the brand teal, the request apricot or the price green.
  final Color place;
  final Color placeSoft;
  final Color placeInk;

  final Color skeleton;

  /// Modal scrim: 36% ink in light, 60% black in dark.
  final Color overlay;

  /// Base colour for shadows.
  final Color shadow;

  // Older names, kept so existing widgets keep compiling.
  Color get textPrimary => ink;
  Color get textSecondary => ink2;
  Color get textTertiary => ink3;
  Color get border => line;
  Color get primaryMuted => tealSoft;
  Color get bg => surface;

  static const light = YbThemeColors(
    surface: Color(0xFFF2F6F6),
    surfaceElevated: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    surface2: Color(0xFFE8EEEE),
    surface3: Color(0xFFDCE5E5),
    ink: Color(0xFF0F1F21),
    ink2: Color(0xFF4E5E60),
    ink3: Color(0xFF637275),
    line: Color(0xFFD8E0E0),
    borderSubtle: Color(0xFFE8EEEE),
    outline: Color(0xFF879496),
    teal: Color(0xFF0A6A70),
    tealBrand: Color(0xFF048289),
    tealSoft: Color(0xFFE0F1F1),
    tealInk: Color(0xFF074349),
    onTeal: Color(0xFFFFFFFF),
    apricot: Color(0xFFF28A2E),
    apricotSoft: Color(0xFFFFEBD6),
    apricotInk: Color(0xFFA0500D),
    onApricot: Color(0xFF0F1F21),
    success: Color(0xFF16774B),
    successSoft: Color(0xFFE1F2E8),
    error: Color(0xFFC0392F),
    errorSoft: Color(0xFFFBE6E3),
    onError: Color(0xFFFFFFFF),
    star: Color(0xFFF2B01E),
    heart: Color(0xFFE0484F),
    place: Color(0xFF5B4BD1),
    placeSoft: Color(0xFFECEAFB),
    placeInk: Color(0xFF4433A6),
    skeleton: Color(0xFFE8EEEE),
    overlay: Color(0x5C0F1F21),
    shadow: Color(0xFF0F1F21),
  );

  static const dark = YbThemeColors(
    surface: Color(0xFF0A1416),
    // Elevated surfaces get lighter in the dark (manual C-05).
    surfaceElevated: Color(0xFF152224),
    card: Color(0xFF111C1E),
    surface2: Color(0xFF172527),
    surface3: Color(0xFF1F3033),
    ink: Color(0xFFECF3F3),
    ink2: Color(0xFFA3B4B5),
    ink3: Color(0xFF8A9B9C),
    line: Color(0xFF233234),
    borderSubtle: Color(0xFF1C2B2D),
    outline: Color(0xFF5E7072),
    teal: Color(0xFF4CC7C4),
    tealBrand: Color(0xFF2DB3B5),
    tealSoft: Color(0xFF0E3A3E),
    tealInk: Color(0xFF9FE3E1),
    onTeal: Color(0xFF03161A),
    apricot: Color(0xFFFFAD5C),
    apricotSoft: Color(0xFF3D2610),
    apricotInk: Color(0xFFFFC48A),
    onApricot: Color(0xFF1A0F04),
    success: Color(0xFF4CC38A),
    successSoft: Color(0xFF0F2F21),
    error: Color(0xFFFF7A6E),
    errorSoft: Color(0xFF3A1513),
    onError: Color(0xFF2A0705),
    star: Color(0xFFF5C04A),
    heart: Color(0xFFFF6F75),
    place: Color(0xFF9D8FFF),
    placeSoft: Color(0xFF211C45),
    placeInk: Color(0xFFC9C1FF),
    skeleton: Color(0xFF172527),
    overlay: Color(0x99000000),
    shadow: Color(0xFF000000),
  );

  @override
  YbThemeColors copyWith({
    Color? surface,
    Color? surfaceElevated,
    Color? card,
    Color? surface2,
    Color? surface3,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? line,
    Color? borderSubtle,
    Color? outline,
    Color? teal,
    Color? tealBrand,
    Color? tealSoft,
    Color? tealInk,
    Color? onTeal,
    Color? apricot,
    Color? apricotSoft,
    Color? apricotInk,
    Color? onApricot,
    Color? success,
    Color? successSoft,
    Color? error,
    Color? errorSoft,
    Color? onError,
    Color? star,
    Color? heart,
    Color? place,
    Color? placeSoft,
    Color? placeInk,
    Color? skeleton,
    Color? overlay,
    Color? shadow,
  }) {
    return YbThemeColors(
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      card: card ?? this.card,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      line: line ?? this.line,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      outline: outline ?? this.outline,
      teal: teal ?? this.teal,
      tealBrand: tealBrand ?? this.tealBrand,
      tealSoft: tealSoft ?? this.tealSoft,
      tealInk: tealInk ?? this.tealInk,
      onTeal: onTeal ?? this.onTeal,
      apricot: apricot ?? this.apricot,
      apricotSoft: apricotSoft ?? this.apricotSoft,
      apricotInk: apricotInk ?? this.apricotInk,
      onApricot: onApricot ?? this.onApricot,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      error: error ?? this.error,
      errorSoft: errorSoft ?? this.errorSoft,
      onError: onError ?? this.onError,
      star: star ?? this.star,
      heart: heart ?? this.heart,
      place: place ?? this.place,
      placeSoft: placeSoft ?? this.placeSoft,
      placeInk: placeInk ?? this.placeInk,
      skeleton: skeleton ?? this.skeleton,
      overlay: overlay ?? this.overlay,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  YbThemeColors lerp(ThemeExtension<YbThemeColors>? other, double t) {
    if (other is! YbThemeColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return YbThemeColors(
      surface: l(surface, other.surface),
      surfaceElevated: l(surfaceElevated, other.surfaceElevated),
      card: l(card, other.card),
      surface2: l(surface2, other.surface2),
      surface3: l(surface3, other.surface3),
      ink: l(ink, other.ink),
      ink2: l(ink2, other.ink2),
      ink3: l(ink3, other.ink3),
      line: l(line, other.line),
      borderSubtle: l(borderSubtle, other.borderSubtle),
      outline: l(outline, other.outline),
      teal: l(teal, other.teal),
      tealBrand: l(tealBrand, other.tealBrand),
      tealSoft: l(tealSoft, other.tealSoft),
      tealInk: l(tealInk, other.tealInk),
      onTeal: l(onTeal, other.onTeal),
      apricot: l(apricot, other.apricot),
      apricotSoft: l(apricotSoft, other.apricotSoft),
      apricotInk: l(apricotInk, other.apricotInk),
      onApricot: l(onApricot, other.onApricot),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      error: l(error, other.error),
      errorSoft: l(errorSoft, other.errorSoft),
      onError: l(onError, other.onError),
      star: l(star, other.star),
      heart: l(heart, other.heart),
      place: l(place, other.place),
      placeSoft: l(placeSoft, other.placeSoft),
      placeInk: l(placeInk, other.placeInk),
      skeleton: l(skeleton, other.skeleton),
      overlay: l(overlay, other.overlay),
      shadow: l(shadow, other.shadow),
    );
  }
}

extension YbThemeContext on BuildContext {
  YbThemeColors get ybColors =>
      Theme.of(this).extension<YbThemeColors>() ?? YbThemeColors.light;
}
