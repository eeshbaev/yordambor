import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

abstract final class AppTheme {
  static ThemeData _baseTheme({
    required ColorScheme colorScheme,
    required YbThemeColors yb,
  }) {
    final baseText = TextTheme(
      displaySmall: AppTypography.display.copyWith(color: yb.textPrimary),
      titleLarge: AppTypography.title.copyWith(color: yb.textPrimary),
      titleMedium: AppTypography.headline.copyWith(color: yb.textPrimary),
      titleSmall: AppTypography.headline.copyWith(color: yb.textPrimary),
      bodyLarge: AppTypography.bodyRegular.copyWith(color: yb.textPrimary),
      bodyMedium: AppTypography.caption.copyWith(color: yb.textSecondary),
      bodySmall: AppTypography.caption.copyWith(color: yb.textTertiary),
      labelLarge: AppTypography.button.copyWith(color: AppColors.primary),
      labelMedium: AppTypography.label.copyWith(color: yb.textSecondary),
      labelSmall: AppTypography.label.copyWith(color: yb.textTertiary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      fontFamily: AppFonts.family,
      scaffoldBackgroundColor: yb.surface,
      textTheme: baseText,
      extensions: [yb],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: yb.surface,
        foregroundColor: yb.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.title.copyWith(color: yb.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: yb.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: yb.borderSubtle),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.buttonHeight),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.buttonHeight),
          foregroundColor: AppColors.primaryDark,
          side: BorderSide(color: yb.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTypography.button.copyWith(color: AppColors.primaryDark),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.headline.copyWith(color: AppColors.primary),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        indicatorColor: yb.primaryMuted,
        backgroundColor: yb.surfaceElevated.withValues(alpha: 0.94),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.label.copyWith(color: AppColors.primary);
          }
          return AppTypography.label.copyWith(color: yb.textTertiary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return IconThemeData(color: yb.textTertiary, size: 24);
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        extendedPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: yb.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: yb.borderSubtle, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: yb.textPrimary,
        contentTextStyle:
            AppTypography.bodyRegular.copyWith(color: yb.surfaceElevated),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: yb.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: yb.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(color: yb.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.caption.copyWith(color: yb.textSecondary),
        hintStyle: AppTypography.bodyRegular.copyWith(color: yb.textTertiary),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        titleTextStyle: AppTypography.headline.copyWith(color: yb.textPrimary),
        subtitleTextStyle: AppTypography.caption.copyWith(color: yb.textSecondary),
      ),
    );
  }

  static ThemeData get light {
    const yb = YbThemeColors.light;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primaryDark,
      surface: yb.surface,
      onSurface: yb.textPrimary,
      error: AppColors.error,
    );

    return _baseTheme(colorScheme: colorScheme, yb: yb);
  }

  static ThemeData get dark {
    const yb = YbThemeColors.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.primary,
      surface: yb.surface,
      onSurface: yb.textPrimary,
      error: AppColors.error,
    );

    return _baseTheme(colorScheme: colorScheme, yb: yb);
  }
}
