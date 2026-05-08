import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_dimens.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

abstract class AppTheme {
  // ═══════════════════════════════════════════════════════
  //  LIGHT THEME
  // ═══════════════════════════════════════════════════════
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: AppTypography.fontFamily,

        // ── Colors ───────────────────────────────────────
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryLight,
          tertiary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.textPrimary,
          onError: AppColors.white,
          outline: AppColors.border,
        ),
        scaffoldBackgroundColor: AppColors.background,
        dividerColor: AppColors.divider,

        // ── AppBar ───────────────────────────────────────
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          titleTextStyle: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        // ── Card ─────────────────────────────────────────
        cardTheme: CardThemeData(
          elevation: AppDimens.elevationLow,
          color: AppColors.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusMedium,
          ),
        ),

        // ── ElevatedButton ───────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacing24,
              vertical: AppDimens.spacing12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppDimens.borderRadiusMedium,
            ),
            textStyle: AppTypography.button,
          ),
        ),

        // ── OutlinedButton ───────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacing24,
              vertical: AppDimens.spacing12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppDimens.borderRadiusMedium,
            ),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            textStyle: AppTypography.button,
          ),
        ),

        // ── TextButton ───────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.button,
          ),
        ),

        // ── InputDecoration ──────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacing16,
            vertical: AppDimens.spacing16,
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textHint,
          ),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
        ),

        // ── BottomNavigationBar ──────────────────────────
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textHint,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: AppTypography.caption,
          unselectedLabelStyle: AppTypography.caption,
        ),

        // ── FloatingActionButton ─────────────────────────
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          shape: CircleBorder(),
        ),

        // ── ListTile ─────────────────────────────────────
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacing16,
            vertical: AppDimens.spacing4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusMedium,
          ),
        ),

        // ── Dialog ───────────────────────────────────────
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusLarge,
          ),
          titleTextStyle: AppTypography.heading3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        // ── Divider ──────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 0,
        ),

        // ── SnackBar ─────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusMedium,
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // ── Text Theme ──────────────────────────────────
        textTheme: const TextTheme(
          headlineLarge: AppTypography.heading1,
          headlineMedium: AppTypography.heading2,
          headlineSmall: AppTypography.heading3,
          titleLarge: AppTypography.subtitle1,
          titleMedium: AppTypography.subtitle2,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
        ),
      );

  // ═══════════════════════════════════════════════════════
  //  DARK THEME
  // ═══════════════════════════════════════════════════════
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: AppTypography.fontFamily,

        // ── Colors ───────────────────────────────────────
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryLight,
          primaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondaryLight,
          secondaryContainer: AppColors.secondaryDark,
          tertiary: AppColors.accent,
          surface: AppColors.darkSurface,
          error: AppColors.error,
          onPrimary: AppColors.darkBackground,
          onSecondary: AppColors.darkBackground,
          onSurface: AppColors.darkTextPrimary,
          onError: AppColors.white,
          outline: AppColors.darkBorder,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        dividerColor: AppColors.darkDivider,

        // ── AppBar ───────────────────────────────────────
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextPrimary,
          ),
        ),

        // ── Card ─────────────────────────────────────────
        cardTheme: CardThemeData(
          elevation: AppDimens.elevationNone,
          color: AppColors.darkCard,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusMedium,
          ),
        ),

        // ── ElevatedButton ───────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacing24,
              vertical: AppDimens.spacing12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppDimens.borderRadiusMedium,
            ),
            textStyle: AppTypography.button,
          ),
        ),

        // ── OutlinedButton ───────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacing24,
              vertical: AppDimens.spacing12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppDimens.borderRadiusMedium,
            ),
            side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
            textStyle: AppTypography.button,
          ),
        ),

        // ── TextButton ───────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            textStyle: AppTypography.button,
          ),
        ),

        // ── InputDecoration ──────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkCard,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacing16,
            vertical: AppDimens.spacing16,
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextHint,
          ),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide:
                const BorderSide(color: AppColors.primaryLight, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppDimens.borderRadiusMedium,
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
        ),

        // ── BottomNavigationBar ──────────────────────────
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.darkTextHint,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: AppTypography.caption,
          unselectedLabelStyle: AppTypography.caption,
        ),

        // ── FloatingActionButton ─────────────────────────
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          shape: CircleBorder(),
        ),

        // ── ListTile ─────────────────────────────────────
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacing16,
            vertical: AppDimens.spacing4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusMedium,
          ),
        ),

        // ── Dialog ───────────────────────────────────────
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.darkSurface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusLarge,
          ),
          titleTextStyle: AppTypography.heading3.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),

        // ── Divider ──────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
          space: 0,
        ),

        // ── SnackBar ─────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.darkCard,
          contentTextStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusMedium,
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // ── Text Theme ──────────────────────────────────
        textTheme: const TextTheme(
          headlineLarge: AppTypography.heading1,
          headlineMedium: AppTypography.heading2,
          headlineSmall: AppTypography.heading3,
          titleLarge: AppTypography.subtitle1,
          titleMedium: AppTypography.subtitle2,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
        ),
      );
}
