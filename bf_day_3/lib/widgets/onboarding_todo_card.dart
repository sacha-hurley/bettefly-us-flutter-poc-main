import 'package:flutter/material.dart';

// Design tokens per spec
class OnboardingColors {
  static const Color surfaceContainer = Color(0xFFFFFFFF);
  static const Color onSurfaceText = Color(0xFF0F1C14);
  static const Color onSurfaceTextVariant = Color(0xFF6F7772);
  static const Color outlineSubtle = Color(0xFFDBDDDC);
  static const Color iconSuccess = Color(0xFF00BF5D);
  static const Color dividerLight = Color(0xFFF5F6F6);
}

class OnboardingTextStyles {
  static const TextStyle titleBold = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: OnboardingColors.onSurfaceText,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.42,
  );
}

class OnboardingSpacing {
  static const double spacing02 = 8;
  static const double spacing04 = 16;
  static const double spacing06 = 24;
  static const double radius08 = 32;
}

/// Onboarding To-do Card
/// Pixel-perfect implementation per spec. Contains:
/// - Header with circular progress + titles
/// - Three task rows with specified states
/// - Exact dimensions, spacing, and colors
// Deprecated - replaced by TodoMainCard
// Keeping minimal stub for potential references. Will be removed.
class OnboardingTodoCard extends StatelessWidget {
  const OnboardingTodoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

// Removed: unused private widgets from deprecated card

// Removed: unused private widgets from deprecated card

// Removed: unused private widgets from deprecated card

// Removed: unused private widgets from deprecated card

// Removed: unused private widgets from deprecated card

// Circular progress removed per updated spec (using horizontal bar)
