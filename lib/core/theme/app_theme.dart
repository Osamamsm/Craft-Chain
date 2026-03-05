import 'package:craft_chain/core/theme/app_colors.dart';
import 'package:craft_chain/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Light ───────────────────────────────────────────────────────────────────

  static ThemeData light() {
    const c = AppColors.light;
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.primary,
        brightness: Brightness.light,
        primary: c.primary,
        onPrimary: c.onPrimary,
        surface: c.surface,
        onSurface: c.onSurface,
        error: c.error,
      ),
      scaffoldBackgroundColor: c.background,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: c.onSurface),
      ),
      textTheme: _buildTextTheme(c),
      inputDecorationTheme: _buildInputDecoration(c),
      elevatedButtonTheme: _buildElevatedButton(c),
      textButtonTheme: _buildTextButton(c),
      checkboxTheme: _buildCheckbox(c),
      dividerColor: c.inputBorder,
    );
  }

  // ── Dark ────────────────────────────────────────────────────────────────────

  static ThemeData dark() {
    const c = AppColors.dark;
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.primary,
        brightness: Brightness.dark,
        primary: c.primary,
        onPrimary: c.onPrimary,
        surface: c.surface,
        onSurface: c.onSurface,
        error: c.error,
      ),
      scaffoldBackgroundColor: c.background,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: c.onSurface),
      ),
      textTheme: _buildTextTheme(c),
      inputDecorationTheme: _buildInputDecoration(c),
      elevatedButtonTheme: _buildElevatedButton(c),
      textButtonTheme: _buildTextButton(c),
      checkboxTheme: _buildCheckbox(c),
      dividerColor: c.inputBorder,
    );
  }

  // ── Shared builders ─────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(AppColorPalette c) {
    return TextTheme(
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: c.onBackground,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: c.onBackground,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: c.onBackground),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: c.onBackground),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: c.onBackground),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: c.onBackground),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: c.secondaryText),
      labelSmall: AppTextStyles.labelUppercase.copyWith(color: c.secondaryText),
    );
  }

  static InputDecorationTheme _buildInputDecoration(AppColorPalette c) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c.inputBorder),
    );
    return InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: c.primary, width: 1.5),
      ),
      errorBorder: border.copyWith(borderSide: BorderSide(color: c.error)),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(color: c.error, width: 1.5),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: c.secondaryText),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: c.secondaryText),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: c.error),
      prefixIconColor: c.secondaryText,
      suffixIconColor: c.secondaryText,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButton(AppColorPalette c) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        disabledBackgroundColor: c.primary.withValues(alpha: 0.4),
        disabledForegroundColor: c.onPrimary.withValues(alpha: 0.6),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.buttonLarge,
        elevation: 0,
      ),
    );
  }

  static TextButtonThemeData _buildTextButton(AppColorPalette c) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.primary,
        textStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static CheckboxThemeData _buildCheckbox(AppColorPalette c) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return c.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(c.onPrimary),
      side: BorderSide(color: c.inputBorder, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}
