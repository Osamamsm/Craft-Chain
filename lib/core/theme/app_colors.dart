import 'package:flutter/material.dart';

class AppColorPalette {
  const AppColorPalette({
    required this.primary,
    required this.background,
    required this.surface,
    required this.surface2,
    required this.error,
    required this.onPrimary,
    required this.onBackground,
    required this.onSurface,
    required this.secondaryText,
    required this.inputBorder,
    required this.greenAccent,
    required this.gradientStart,
    required this.gradientEnd,
    required this.infoBackground,
    required this.teachChipBg,
    required this.teachChipText,
  });

  final Color primary;
  final Color background;
  final Color surface;

  /// Secondary surface used for input backgrounds, back-button fills, etc.
  final Color surface2;

  final Color error;
  final Color onPrimary;
  final Color onBackground;
  final Color onSurface;
  final Color secondaryText;
  final Color inputBorder;
  final Color greenAccent;
  final Color gradientStart;
  final Color gradientEnd;

  /// Info / learn-chip background (blue tint).
  final Color infoBackground;

  /// Background for "teach" skill chips (green tint).
  final Color teachChipBg;

  /// Text/icon color for "teach" skill chips.
  final Color teachChipText;

  // ── Derived helpers ──────────────────────────────────────────────────────
  // Learn chips reuse infoBackground (bg) and primary (text) — no extra fields.
}

class AppColors {
  AppColors._();

  static const light = AppColorPalette(
    primary: Color(0xFF2563EB),
    background: Color(0xFFF7F8FC),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF1F5F9),
    error: Color(0xFFEF4444),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1E293B),
    onSurface: Color(0xFF1E293B),
    secondaryText: Color(0xFF64748B),
    inputBorder: Color(0xFFE2E8F0),
    greenAccent: Color(0xFF4ADE80),
    gradientStart: Color(0xFF1E3A8A),
    gradientEnd: Color(0xFF2563EB),
    infoBackground: Color(0xFFEFF6FF),
    teachChipBg: Color(0xFFF0FDF4),
    teachChipText: Color(0xFF16A34A),
  );

  static const dark = AppColorPalette(
    primary: Color(0xFF2563EB),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surface2: Color(0xFF1E293B),
    error: Color(0xFFEF4444),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFFF8FAFC),
    onSurface: Color(0xFFF8FAFC),
    secondaryText: Color(0xFF94A3B8),
    inputBorder: Color(0xFF334155),
    greenAccent: Color(0xFF4ADE80),
    gradientStart: Color(0xFF0F172A),
    gradientEnd: Color(0xFF1E3A8A),
    infoBackground: Color(0xFF1E3A5F),
    teachChipBg: Color(0xFF064E3B),
    teachChipText: Color(0xFF6EE7B7),
  );

  // ── Semantic extras (theme-independent) ─────────────────────────────────
  static const Color avatarPurple = Color(0xFF7C3AED);
  static const Color avatarGreen = Color(0xFF059669);
  static const Color avatarOrange = Color(0xFFF97316);
  static const Color avatarTeal = Color(0xFF10B981);
  static const Color skillBlue = Color(0xFFEFF6FF);
  static const Color skillBlueText = Color(0xFF2563EB);
  static const Color skillGreen = Color(0xFFF0FDF4);
  static const Color skillGreenText = Color(0xFF16A34A);
  static const Color googleBrand = Color(0xFF4285F4);
}

extension AppColorsX on BuildContext {
  AppColorPalette get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  }
}
