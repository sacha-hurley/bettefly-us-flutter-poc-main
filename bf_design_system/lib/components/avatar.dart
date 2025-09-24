import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// BFAvatar - A reusable avatar component following bubble design system patterns
///
/// Features:
/// - Displays user initials in a circular container
/// - Consistent sizing and colors from bubble DS
/// - Supports tap interactions
/// - Customizable radius and colors
class BFAvatar extends StatelessWidget {
  /// The user's initials to display (e.g., "JD" for John Doe)
  final String initials;

  /// The radius of the circular avatar
  final double radius;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Background color override (uses bubble DS primary if not provided)
  final Color? backgroundColor;

  /// Text color override (uses white if not provided)
  final Color? textColor;

  const BFAvatar({
    super.key,
    required this.initials,
    this.radius = 18.0,
    this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Get bubble DS colors from theme
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? colors.primary,
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: _calculateFontSize(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // If onTap is provided, wrap in GestureDetector
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }

  /// Calculate font size based on radius for proper scaling
  double _calculateFontSize() {
    if (radius <= 16) return 12;
    if (radius <= 24) return 14;
    if (radius <= 32) return 16;
    return 18;
  }
}
