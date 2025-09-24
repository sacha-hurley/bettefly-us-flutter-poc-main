import 'package:flutter/material.dart';

class BFColors extends ThemeExtension<BFColors> {
  final Color primary;
  final Color secondary;
  final Color surface;
  final Color background;
  final Color brand;
  final Color brandOn;
  final Color bg;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color error;

  const BFColors({
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.background,
    required this.brand,
    required this.brandOn,
    required this.bg,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.error,
  });

  static const light = BFColors(
    primary: Color(0xFF2196F3),
    secondary: Color(0xFF03DAC6),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF5F5F5),
    brand: Color(0xFF2196F3),
    brandOn: Color(0xFFFFFFFF),
    bg: Color(0xFFF5F5F5),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF666666),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFF9800),
    error: Color(0xFFF44336),
  );

  static const dark = BFColors(
    primary: Color(0xFF1976D2),
    secondary: Color(0xFF018786),
    surface: Color(0xFF121212),
    background: Color(0xFF000000),
    brand: Color(0xFF1976D2),
    brandOn: Color(0xFFFFFFFF),
    bg: Color(0xFF121212),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFAAAAAA),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFF9800),
    error: Color(0xFFF44336),
  );

  @override
  BFColors copyWith({
    Color? primary,
    Color? secondary,
    Color? surface,
    Color? background,
    Color? brand,
    Color? brandOn,
    Color? bg,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return BFColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      brand: brand ?? this.brand,
      brandOn: brandOn ?? this.brandOn,
      bg: bg ?? this.bg,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  BFColors lerp(ThemeExtension<BFColors>? other, double t) {
    if (other is! BFColors) return this;
    return BFColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      brandOn: Color.lerp(brandOn, other.brandOn, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}