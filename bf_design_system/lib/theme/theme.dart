import 'package:flutter/material.dart';
import 'colors.dart';

class BfTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: BFColors.light.primary,
        brightness: Brightness.light,
      ),
      extensions: const [BFColors.light],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: BFColors.dark.primary,
        brightness: Brightness.dark,
      ),
      extensions: const [BFColors.dark],
    );
  }
}