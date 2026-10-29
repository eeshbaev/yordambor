import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// Light and dark themes built from [YbThemeColors].
///
/// The colour scheme is explicit (no seed), so every role is a checked
/// colour: teal for the help and every "yes", apricot for the need, green for
/// done, red for errors.
abstract final class AppTheme {
  static ThemeData get light => _build(YbThemeColors.light, Brightness.light);

  static ThemeData get dark => _build(YbThemeColors.dark, Brightness.dark);

  /// Android expects the button's tooltip repeated as the icon's label;
  /// other platforms read the tooltip alone (as Flutter's own icons do).
  static String? _androidIconLabel(String label) =>
      defaultTargetPlatform == TargetPlatform.android ? label : null;

  static ColorScheme _scheme(YbThemeColors c, Brightness b) {
    final isDark = b == Brightness.dark;
    return ColorScheme(
      brightness: b,
      primary: c.teal,
      onPrimary: c.onTeal,
      primaryContainer: c.tealSoft,
      onPrimaryContainer: c.tealInk,
      secondary: c.apricot,
      onSecondary: c.onApricot,
      secondaryContainer: c.apricotSoft,
      onSecondaryContainer: c.apricotInk,
      tertiary: c.success,
      onTertiary: isDark ? const Color(0xFF04190F) : Colors.white,
      tertiaryContainer: c.successSoft,
      onTertiaryContainer: c.success,
      error: c.error,
      onError: c.onError,
      errorContainer: c.errorSoft,
      onErrorContainer: c.error,
      surface: c.card,
      onSurface: c.ink,
      onSurfaceVariant: c.ink2,
      surfaceDim: isDark ? c.surface : c.surface3,
      surfaceBright: isDark ? c.surface3 : c.card,
      surfaceContainerLowest: isDark ? c.surface : c.card,
      surfaceContainerLow: isDark ? c.card : c.surface,
      surfaceContainer: c.surface2,
      surfaceContainerHigh: c.surface3,
      surfaceContainerHighest:
          isDark ? const Color(0xFF263A3D) : const Color(0xFFD3DDDD),
      outline: c.outline,
      outlineVariant: c.line,
      shadow: c.shadow,
      scrim: Colors.black,
      inverseSurface: c.ink,
      onInverseSurface: c.surface,
      inversePrimary: isDark ? AppColors.primary : AppColors.primaryLight,
      surfaceTint: Colors.transparent,
    );
  }

  static TextStyle _t(
    YbThemeColors c, {
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
      color: color ?? c.ink,
    );
  }

  static TextTheme _textTheme(YbThemeColors c) {
    TextStyle display(double size, double lineHeight) => AppFonts.displayStyle(
          size: size,
          height: lineHeight / size,
          letterSpacing: -size * 0.01,
          color: c.ink,
        );

    return TextTheme(
      displayLarge: display(40, 44),
      displayMedium: display(34, 38),
      displaySmall: display(28, 32),
      // Headings at 1.1–1.25× line height, body at 1.4–1.5× (manual T-04);
      // three weights only: 400, 600, 700 (T-03).
      headlineLarge: _t(c, size: 32, weight: FontWeight.w700, lineHeight: 38, letterSpacing: -0.5),
      headlineMedium: _t(c, size: 28, weight: FontWeight.w700, lineHeight: 34, letterSpacing: -0.4),
      headlineSmall: _t(c, size: 24, weight: FontWeight.w700, lineHeight: 29, letterSpacing: -0.3),
      titleLarge: _t(c, size: 22, weight: FontWeight.w700, lineHeight: 27, letterSpacing: -0.25),
      titleMedium: _t(c, size: 17, weight: FontWeight.w600, lineHeight: 21, letterSpacing: -0.1),
      titleSmall: _t(c, size: 15, weight: FontWeight.w600, lineHeight: 19),
      bodyLarge: _t(c, size: 16, weight: FontWeight.w400, lineHeight: 24),
      bodyMedium: _t(c, size: 15, weight: FontWeight.w400, lineHeight: 21, color: c.ink2),
      bodySmall: _t(c, size: 13, weight: FontWeight.w400, lineHeight: 18, color: c.ink2),
      labelLarge: _t(c, size: 15, weight: FontWeight.w600, lineHeight: 20),
      labelMedium: _t(c, size: 13, weight: FontWeight.w600, lineHeight: 16, color: c.ink2),
      labelSmall: _t(c, size: 12, weight: FontWeight.w600, lineHeight: 16, letterSpacing: 0.1, color: c.ink2),
    );
  }

  static ThemeData _build(YbThemeColors c, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = _scheme(c, brightness);
    final text = _textTheme(c);
    final buttonText = AppTypography.button;
    const stadium = StadiumBorder();

    OutlineInputBorder fieldBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.family,
      textTheme: text,
      scaffoldBackgroundColor: c.surface,
      canvasColor: c.card,
      dividerColor: c.line,
      splashFactory: InkRipple.splashFactory,
      extensions: [c],
      // Back and close buttons draw from the app's one icon family.
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) => Icon(
          switch (Theme.of(context).platform) {
            TargetPlatform.iOS || TargetPlatform.macOS =>
              YbIcons.arrowBackIosNew,
            _ => YbIcons.arrowBack,
          },
          semanticLabel: _androidIconLabel(
            MaterialLocalizations.of(context).backButtonTooltip,
          ),
        ),
        closeButtonIconBuilder: (context) => Icon(
          YbIcons.close,
          semanticLabel: _androidIconLabel(
            MaterialLocalizations.of(context).closeButtonTooltip,
          ),
        ),
      ),
      appBarTheme: AppBarThemeData(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: c.surface,
        foregroundColor: c.ink,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleLarge,
        iconTheme: IconThemeData(color: c.ink),
        actionsIconTheme: IconThemeData(color: c.ink),
      ),
      iconTheme: IconThemeData(color: c.ink2, size: 24),
      cardTheme: CardThemeData(
        color: c.card,
        elevation: isDark ? 0 : 1,
        shadowColor: c.shadow.withValues(alpha: 0.35),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: isDark
              ? BorderSide(color: c.borderSubtle)
              : BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          backgroundColor: c.teal,
          foregroundColor: c.onTeal,
          disabledBackgroundColor: c.surface2,
          disabledForegroundColor: c.ink3,
          elevation: 0,
          shape: stadium,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          backgroundColor: c.card,
          foregroundColor: c.ink,
          disabledForegroundColor: c.ink3,
          side: BorderSide(color: c.outline),
          shape: stadium,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.teal,
          disabledForegroundColor: c.ink3,
          minimumSize: const Size(48, 44),
          shape: stadium,
          textStyle: AppFonts.ui(
            size: 15,
            weight: FontWeight.w600,
            height: 20 / 15,
            color: c.teal,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: c.ink2,
          minimumSize: const Size(AppTouch.minTarget, AppTouch.minTarget),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.teal,
        foregroundColor: c.onTeal,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        extendedPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        extendedTextStyle: buttonText,
        shape: stadium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: c.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        indicatorColor: c.tealSoft,
        indicatorShape: stadium,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        // One weight in both states, so labels never shift.
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppFonts.ui(
            size: 12,
            weight: FontWeight.w600,
            height: 16 / 12,
            color: selected ? c.teal : c.ink2,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? c.tealInk : c.ink2,
            size: 24,
          );
        }),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceElevated,
        modalBackgroundColor: c.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        modalBarrierColor: c.overlay,
        showDragHandle: true,
        dragHandleColor: c.outline.withValues(alpha: 0.5),
        dragHandleSize: const Size(40, 5),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        barrierColor: c.overlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyLarge?.copyWith(color: c.ink2),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.card,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shadowColor: c.shadow.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        textStyle: text.bodyLarge,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        headerForegroundColor: c.ink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: c.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.card,
        selectedColor: c.tealSoft,
        disabledColor: c.surface2,
        checkmarkColor: c.tealInk,
        side: BorderSide(color: c.line),
        shape: stadium,
        labelStyle: AppFonts.ui(
          size: 14,
          weight: FontWeight.w600,
          height: 20 / 14,
          color: c.ink,
        ),
        secondaryLabelStyle: AppFonts.ui(
          size: 14,
          weight: FontWeight.w600,
          height: 20 / 14,
          color: c.tealInk,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        iconTheme: IconThemeData(color: c.ink2, size: 18),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: c.card,
          foregroundColor: c.ink2,
          selectedBackgroundColor: c.tealSoft,
          selectedForegroundColor: c.tealInk,
          side: BorderSide(color: c.line),
          shape: stadium,
          textStyle: AppFonts.ui(
            size: 14,
            weight: FontWeight.w600,
            height: 20 / 14,
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: c.teal,
        unselectedLabelColor: c.ink2,
        indicatorColor: c.teal,
        dividerColor: c.line,
        labelStyle: AppFonts.ui(size: 15, weight: FontWeight.w600, height: 20 / 15),
        unselectedLabelStyle:
            AppFonts.ui(size: 15, weight: FontWeight.w600, height: 20 / 15),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return c.surface3;
          return states.contains(WidgetState.selected) ? c.onTeal : c.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return c.surface2;
          return states.contains(WidgetState.selected) ? c.teal : c.surface2;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Colors.transparent
              : c.outline;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? c.teal
              : Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(c.onTeal),
        side: BorderSide(color: c.outline, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? c.teal : c.outline;
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.teal,
        linearTrackColor: c.surface2,
        circularTrackColor: Colors.transparent,
        refreshBackgroundColor: c.card,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: c.apricot,
        textColor: c.onApricot,
        textStyle: AppFonts.ui(
          size: 11,
          weight: FontWeight.w700,
          height: 1,
        ).copyWith(fontFeatures: AppFonts.tabular),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.ink,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        textStyle: AppFonts.ui(
          size: 13,
          weight: FontWeight.w400,
          height: 18 / 13,
          color: c.surface,
        ),
      ),
      dividerTheme: DividerThemeData(color: c.line, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.ink,
        actionTextColor: isDark ? AppColors.primary : AppColors.primaryLight,
        contentTextStyle: AppFonts.ui(
          size: 15,
          weight: FontWeight.w400,
          height: 21 / 15,
          color: c.surface,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.teal,
        selectionColor: c.teal.withValues(alpha: 0.25),
        selectionHandleColor: c.teal,
      ),
      // Labels stay visible above the value; hints are examples (manual K-11).
      inputDecorationTheme: InputDecorationThemeData(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: c.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: fieldBorder(c.outline),
        enabledBorder: fieldBorder(c.outline),
        focusedBorder: fieldBorder(c.teal, 2),
        errorBorder: fieldBorder(c.error),
        focusedErrorBorder: fieldBorder(c.error, 2),
        disabledBorder: fieldBorder(c.line),
        labelStyle: AppFonts.ui(
          size: 16,
          weight: FontWeight.w600,
          height: 22 / 16,
          color: c.ink2,
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          final Color color;
          if (states.contains(WidgetState.error)) {
            color = c.error;
          } else if (states.contains(WidgetState.focused)) {
            color = c.teal;
          } else {
            color = c.ink2;
          }
          return AppFonts.ui(
            size: 16,
            weight: FontWeight.w600,
            height: 22 / 16,
            color: color,
          );
        }),
        hintStyle: AppFonts.ui(
          size: 16,
          weight: FontWeight.w400,
          height: 24 / 16,
          color: c.ink3,
        ),
        errorStyle: AppFonts.ui(
          size: 13,
          weight: FontWeight.w400,
          height: 18 / 13,
          color: c.error,
        ),
        prefixIconColor: c.ink2,
        suffixIconColor: c.ink2,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        iconColor: c.ink2,
        titleTextStyle: AppFonts.ui(
          size: 16,
          weight: FontWeight.w400,
          height: 22 / 16,
          color: c.ink,
        ),
        subtitleTextStyle: AppFonts.ui(
          size: 13,
          weight: FontWeight.w400,
          height: 18 / 13,
          color: c.ink2,
        ),
      ),
    );
  }
}
