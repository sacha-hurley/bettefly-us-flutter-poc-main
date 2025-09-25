import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble_ds/bubble_ds.dart';
import 'state/app_state.dart';
import 'navigation/bottom_navigation.dart';
import 'widgets/notification_host.dart';
import 'services/currency_service.dart';
import 'debug_top_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Ensure currency service loads its persisted state before UI renders.
  WidgetsFlutterBinding.ensureInitialized();
  await CurrencyService().ensureLoaded();
  // Debug: clear persisted todos on hot restart for a fresh state
  assert(() {
    () async {
      final svc = await SharedPreferences.getInstance();
      // Use a toggle flag to clear only once per run if needed; clear always here
      // Import is heavy here, so call via shared prefs keys directly
      await svc.remove('todo_items_v1');
      await svc.remove('todo_collapsed_v1');
    }();
    return true;
  }());

  // Debug-only one-time seed: add 4,000 BetterFlies to facilitate testing
  // This runs only once thanks to a SharedPreferences flag.
  // Remove or change the key/amount after testing as needed.
  assert(() {
    () async {
      final prefs = await SharedPreferences.getInstance();
      const seedKey = 'debug_seeded_bf_4000_once';
      final alreadySeeded = prefs.getBool(seedKey) ?? false;
      if (!alreadySeeded) {
        await CurrencyService().addCurrency(4000);
        await prefs.setBool(seedKey, true);
      }
    }();
    return true;
  }());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Betterfly Health LSA App',
        // Using bubble_ds theming with Betterfly brand colors
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          // Wrap with NotificationHost and use a descendant context for toasts
          return NotificationHost(
            child: Builder(
              builder: (hostContext) {
                CurrencyService().onAward ??= (tx) {
                  final amount = tx.amount;
                  if (amount > 0) {
                    NotificationHost.showToast(
                      hostContext,
                      message: '+$amount BetterFlies earned',
                      icon: Icons.flutter_dash,
                    );
                  }
                };
                return child ?? const SizedBox.shrink();
              },
            ),
          );
        },
        // Add debug routes for testing
        routes: {
          // '/': (context) => const MainBottomNavigation(),
          '/debug': (context) => const TestBFComponents(),
        },
        home: const MainBottomNavigation(),
      ),
    );
  }

  /// Build light theme using bubble_ds colors and Material 3
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // Use bubble_ds colors for consistent theming
      colorScheme: ColorScheme.fromSeed(
        seedColor: BdsColors.accentPrimary, // Betterfly green
        brightness: Brightness.light,
        primary: BdsColors.accentPrimary,
        secondary: BdsColors.accentSecondary,
        tertiary: BdsColors.accentTertiary,
        surface: BdsColors.backgroundSecondary,
        background: BdsColors.backgroundPrimary,
        error: BdsColors.textError,
      ),
      // Preserve existing component theming with bubble_ds colors
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 3,
        backgroundColor: BdsColors.backgroundSecondary,
        foregroundColor: BdsColors.onSurfaceText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BdsColors.accentPrimary,
          foregroundColor: BdsColors.onSurfaceTextInverse,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: BdsColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // Bottom navigation bar theming for bubble_ds integration
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: BdsColors.backgroundSecondary,
        selectedItemColor: BdsColors.accentPrimary,
        unselectedItemColor: BdsColors.onSurfaceTextVariant,
        elevation: 3,
      ),
    );
  }

  /// Build dark theme using bubble_ds colors
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: BdsColors.accentPrimary,
        brightness: Brightness.dark,
        primary: BdsColors.accentPrimary,
        secondary: BdsColors.accentSecondary,
        tertiary: BdsColors.accentTertiary,
        surface: BdsColors.surfaceContainerInverse,
        background: BdsColors.surfaceContainerInverseVariable,
        error: BdsColors.textError,
      ),
    );
  }
}

// Retain the GalleryHome entry point via a debug-only FAB on HomeScreen later if needed.
