import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// BFModal - A reusable modal base component following bubble design system patterns
///
/// Features:
/// - Full-screen modal with rounded top corners
/// - Drag handle for visual consistency
/// - Header with title and close button
/// - Customizable content area
/// - Consistent styling from bubble DS
/// - Safe area handling
class BFModal extends StatelessWidget {
  /// The title displayed in the modal header
  final String title;

  /// Optional leading widget in the header (like an icon)
  final Widget? headerLeading;

  /// The main content of the modal
  final Widget child;

  /// Whether to show the drag handle at the top
  final bool showDragHandle;

  /// Whether to show the close button
  final bool showCloseButton;

  /// Custom close button callback (if null, uses Navigator.pop)
  final VoidCallback? onClose;

  /// Background color override
  final Color? backgroundColor;

  /// Header background color override
  final Color? headerBackgroundColor;

  /// Extra spacing above the header (below the drag handle)
  final double extraTopPadding;

  const BFModal({
    super.key,
    required this.title,
    required this.child,
    this.headerLeading,
    this.showDragHandle = true,
    this.showCloseButton = true,
    this.onClose,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.extraTopPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Get bubble DS colors from theme
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drag handle
            if (showDragHandle) _buildDragHandle(colors),

            // Extra space above header if requested
            if (extraTopPadding > 0) SizedBox(height: extraTopPadding),

            // Header
            _buildHeader(context, colors),

            // Content
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  /// Build the drag handle widget
  Widget _buildDragHandle(BFColors colors) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: colors.textSecondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// Build the header with title and close button
  Widget _buildHeader(BuildContext context, BFColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: headerBackgroundColor ?? colors.surface,
        border: Border(
          bottom: BorderSide(
            color: colors.textSecondary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Leading widget (optional icon)
          if (headerLeading != null) ...[
            headerLeading!,
            const SizedBox(width: 8),
          ],

          // Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ),

          // Close button
          if (showCloseButton)
            IconButton(
              onPressed: onClose ?? () => Navigator.pop(context),
              icon: Icon(Icons.close, color: colors.textSecondary),
              tooltip: 'Close',
            ),
        ],
      ),
    );
  }
}

/// BFModalContent - A helper widget for modal content with consistent padding
///
/// Use this to wrap your modal content for consistent spacing and layout
class BFModalContent extends StatelessWidget {
  /// The content to display
  final Widget child;

  /// Custom padding override
  final EdgeInsets? padding;

  const BFModalContent({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding ?? const EdgeInsets.all(16), child: child);
  }
}

/// Helper function to show a BFModal as a bottom sheet
///
/// This provides the standard way to display modals in the app
Future<T?> showBFModal<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  Widget? headerLeading,
  bool showDragHandle = true,
  bool showCloseButton = true,
  VoidCallback? onClose,
  Color? backgroundColor,
  Color? headerBackgroundColor,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = true,
  double extraTopPadding = 0,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    builder: (context) => FractionallySizedBox(
      heightFactor: 1.0, // Force full-height sheet
      child: BFModal(
        title: title,
        headerLeading: headerLeading,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        onClose: onClose,
        backgroundColor: backgroundColor,
        headerBackgroundColor: headerBackgroundColor,
        extraTopPadding: extraTopPadding,
        child: child,
      ),
    ),
  );
}
