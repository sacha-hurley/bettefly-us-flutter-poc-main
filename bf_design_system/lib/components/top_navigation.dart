import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'currency_counter.dart';
import 'package:bubble_ds/bubble_ds.dart';

/// BFTopNavigation - A reusable top navigation bar component
///
/// Features:
/// - Left: User avatar with tap interaction
/// - Right: Currency counter and buddy AI icon
/// - Consistent bubble DS styling and theming
/// - Implements PreferredSizeWidget for use as AppBar
/// - Customizable callbacks for all interactions
class BFTopNavigation extends StatelessWidget implements PreferredSizeWidget {
  /// User initials for the avatar (e.g., "JD")
  final String userInitials;

  /// Current currency amount to display
  final int currencyAmount;

  /// Callback when avatar is tapped (typically opens profile modal)
  final VoidCallback? onAvatarTap;

  /// Callback when currency counter is tapped (typically opens currency modal)
  final VoidCallback? onCurrencyTap;

  /// Callback when buddy AI icon is tapped (typically opens chat modal)
  final VoidCallback? onBuddyTap;

  /// Background color override
  final Color? backgroundColor;

  /// Whether to show elevation/shadow
  final bool showElevation;

  /// Custom buddy icon (defaults to sentiment_very_satisfied)
  final IconData buddyIcon;

  /// Optional buddy graphic widget (e.g., an SVG). If provided, this
  /// will be shown instead of the `buddyIcon`.
  final Widget? buddyGraphic;

  /// Optional currency graphic widget (e.g., an SVG). If provided, this will
  /// be shown instead of the default material icon in the currency counter.
  final Widget? currencyGraphic;

  const BFTopNavigation({
    super.key,
    required this.userInitials,
    required this.currencyAmount,
    this.onAvatarTap,
    this.onCurrencyTap,
    this.onBuddyTap,
    this.backgroundColor,
    this.showElevation = true,
    this.buddyIcon = Icons.sentiment_very_satisfied,
    this.buddyGraphic,
    this.currencyGraphic,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    // Get bubble DS colors from theme
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;
    // Ensure Bubble DS avatar initials meet API requirement (max 2 chars, uppercase)
    final String sanitizedInitials =
        (userInitials.length > 2 ? userInitials.substring(0, 2) : userInitials)
            .toUpperCase();

    return AppBar(
      automaticallyImplyLeading: false,
      // Match page background; avoid distinct bar tint
      backgroundColor: backgroundColor ?? Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: colors.textPrimary,
      elevation: showElevation ? 1 : 0,
      scrolledUnderElevation: showElevation ? 3 : 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Avatar (Bubble DS)
          BdsAvatar(
            initialsText: sanitizedInitials,
            size: BdsAvatarSize
                .m, // 40px medium size; 64px AppBar remains for spacing
            onAvatarTap: onAvatarTap,
          ),

          // Right side: Currency + Buddy
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Currency Counter
              BFAnimatedCurrencyCounter(
                amount: currencyAmount,
                onTap: onCurrencyTap,
                iconColor: colors.warning,
                textColor: colors.textPrimary,
                iconGraphic: currencyGraphic,
              ),

              const SizedBox(width: 16),

              // Buddy AI Assistant
              _buildBuddyIcon(colors),
            ],
          ),
        ],
      ),
    );
  }

  /// Build the buddy AI icon with tap interaction
  Widget _buildBuddyIcon(BFColors colors) {
    final Widget icon =
        buddyGraphic ?? Icon(buddyIcon, size: 28, color: colors.primary);

    if (onBuddyTap != null) {
      return GestureDetector(
        onTap: onBuddyTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: icon,
        ),
      );
    }

    return icon;
  }
}

/// BFReactiveTopNavigation - A top navigation that automatically updates
/// when currency changes via ValueNotifier
///
/// This version is perfect for use with services that notify of currency changes
class BFReactiveTopNavigation extends StatelessWidget
    implements PreferredSizeWidget {
  /// User initials for the avatar (e.g., "JD")
  final String userInitials;

  /// ValueNotifier that holds the current currency amount
  final ValueNotifier<int> currencyNotifier;

  /// Callback when avatar is tapped (typically opens profile modal)
  final VoidCallback? onAvatarTap;

  /// Callback when currency counter is tapped (typically opens currency modal)
  final VoidCallback? onCurrencyTap;

  /// Callback when buddy AI icon is tapped (typically opens chat modal)
  final VoidCallback? onBuddyTap;

  /// Background color override
  final Color? backgroundColor;

  /// Whether to show elevation/shadow
  final bool showElevation;

  /// Custom buddy icon (defaults to sentiment_very_satisfied)
  final IconData buddyIcon;

  /// Optional buddy graphic widget (e.g., an SVG). If provided, this
  /// will be shown instead of the `buddyIcon`.
  final Widget? buddyGraphic;

  /// Optional currency graphic widget (e.g., an SVG). If provided, this will
  /// be shown instead of the default material icon in the currency counter.
  final Widget? currencyGraphic;

  const BFReactiveTopNavigation({
    super.key,
    required this.userInitials,
    required this.currencyNotifier,
    this.onAvatarTap,
    this.onCurrencyTap,
    this.onBuddyTap,
    this.backgroundColor,
    this.showElevation = true,
    this.buddyIcon = Icons.sentiment_very_satisfied,
    this.buddyGraphic,
    this.currencyGraphic,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currencyNotifier,
      builder: (context, currencyAmount, child) {
        return BFTopNavigation(
          userInitials: userInitials,
          currencyAmount: currencyAmount,
          onAvatarTap: onAvatarTap,
          onCurrencyTap: onCurrencyTap,
          onBuddyTap: onBuddyTap,
          backgroundColor: backgroundColor,
          showElevation: showElevation,
          buddyIcon: buddyIcon,
          buddyGraphic: buddyGraphic,
          currencyGraphic: currencyGraphic,
        );
      },
    );
  }
}
