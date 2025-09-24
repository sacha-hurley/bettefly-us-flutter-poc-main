import 'package:flutter/material.dart';

class AppTheme {
  // Brand Green palette (from colors-primitive.scss)
  static const Color brandGreen10 = Color(0xFFD1EDD7);
  static const Color brandGreen30 = Color(0xFF75F1A8);
  static const Color brandGreen50 = Color(0xFF19F578);
  static const Color brandGreen70 = Color(0xFF00BF5D);
  static const Color brandGreen90 = Color(0xFF00804C);

  // Brand Yellow palette (from colors-primitive.scss)
  static const Color brandYellow10 = Color(0xFFF1F5BF);
  static const Color brandYellow30 = Color(0xFFEBF660);
  static const Color brandYellow50 = Color(0xFFE8FB10);
  static const Color brandYellow70 = Color(0xFFE6D200);
  static const Color brandYellow90 = Color(0xFFB65200);

  // Brand Pink palette (from colors-primitive.scss)
  static const Color brandPink10 = Color(0xFFF1E2F2);
  static const Color brandPink30 = Color(0xFFF8C6F9);
  static const Color brandPink50 = Color(0xFFFFAAFF);
  static const Color brandPink70 = Color(0xFFDF64DD);
  static const Color brandPink90 = Color(0xFFBF1DBA);

  // Primary brand color used across the light theme
  static const Color primaryColor = brandGreen70;
  static const Color secondaryColor = brandYellow70;
  static const Color tertiaryColor = brandPink70;
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color neutralColor = Color(0xFF605D62);
  static const Color neutralVariantColor = Color(0xFF79747E);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: brandGreen10,
      onPrimaryContainer: brandGreen90,
      secondary: secondaryColor,
      onSecondary: Color(0xFF000000),
      secondaryContainer: brandYellow10,
      onSecondaryContainer: brandYellow90,
      tertiary: tertiaryColor,
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: brandPink10,
      onTertiaryContainer: brandPink90,
      error: errorColor,
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFFEF7FF),
      onSurface: Color(0xFF1D1B20),
      surfaceContainerHighest: Color(0xFFE6E0E9),
      onSurfaceVariant: Color(0xFF49454F),
      outline: Color(0xFF79747E),
      outlineVariant: Color(0xFFCAC4D0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF322F35),
      onInverseSurface: Color(0xFFF5EFF7),
      inversePrimary: brandGreen30,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        success: Color(0xFF019866),
        onSuccess: Color(0xFFFFFFFF),
        successContainer: Color(0xFFD6FFF1),
        onSuccessContainer: Color(0xFF108755),
        info: Color(0xFF0167FE),
        onInfo: Color(0xFFFFFFFF),
        infoContainer: Color(0xFFE1EDFF),
        onInfoContainer: Color(0xFF2243BA),
        alert: Color(0xFFFE9001),
        onAlert: Color(0xFF000000),
        alertContainer: Color(0xFFFFF2E1),
        onAlertContainer: Color(0xFFBA5A22),
      ),
    ],
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      elevation: 0,
      labelType: NavigationRailLabelType.all,
      groupAlignment: 0,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      // Use a lighter brand green for dark theme primary
      primary: brandGreen30,
      onPrimary: Color(0xFF00150C),
      primaryContainer: brandGreen90,
      onPrimaryContainer: brandGreen10,
      secondary: brandYellow30,
      onSecondary: Color(0xFF000000),
      secondaryContainer: brandYellow90,
      onSecondaryContainer: brandYellow10,
      tertiary: brandPink30,
      onTertiary: Color(0xFF000000),
      tertiaryContainer: brandPink90,
      onTertiaryContainer: brandPink10,
      error: Color(0xFFFF7B85),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFFBA2222),
      onErrorContainer: Color(0xFFFFEBEB),
      surface: Color(0xFF141218),
      onSurface: Color(0xFFE6E0E9),
      surfaceContainerHighest: Color(0xFF49454F),
      onSurfaceVariant: Color(0xFFCAC4D0),
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454F),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E0E9),
      onInverseSurface: Color(0xFF322F35),
      inversePrimary: brandGreen70,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: brandGreen30, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFB4AB), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFB4AB), width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 3,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      elevation: 0,
      labelType: NavigationRailLabelType.all,
      groupAlignment: 0,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        success: Color(0xFF019866),
        onSuccess: Color(0xFFFFFFFF),
        successContainer: Color(0xFFD6FFF1),
        onSuccessContainer: Color(0xFF108755),
        info: Color(0xFF0167FE),
        onInfo: Color(0xFFFFFFFF),
        infoContainer: Color(0xFFE1EDFF),
        onInfoContainer: Color(0xFF2243BA),
        alert: Color(0xFFFE9001),
        onAlert: Color(0xFF000000),
        alertContainer: Color(0xFFFFF2E1),
        onAlertContainer: Color(0xFFBA5A22),
      ),
    ],
  );
}

class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color alert;
  final Color onAlert;
  final Color alertContainer;
  final Color onAlertContainer;

  const AppColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.alert,
    required this.onAlert,
    required this.alertContainer,
    required this.onAlertContainer,
  });

  @override
  AppColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? alert,
    Color? onAlert,
    Color? alertContainer,
    Color? onAlertContainer,
  }) {
    return AppColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      alert: alert ?? this.alert,
      onAlert: onAlert ?? this.onAlert,
      alertContainer: alertContainer ?? this.alertContainer,
      onAlertContainer: onAlertContainer ?? this.onAlertContainer,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      alert: Color.lerp(alert, other.alert, t)!,
      onAlert: Color.lerp(onAlert, other.onAlert, t)!,
      alertContainer: Color.lerp(alertContainer, other.alertContainer, t)!,
      onAlertContainer: Color.lerp(onAlertContainer, other.onAlertContainer, t)!,
    );
  }
}