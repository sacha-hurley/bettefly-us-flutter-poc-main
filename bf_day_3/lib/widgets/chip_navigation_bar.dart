import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A responsive chip-based tab navigation widget for iOS Flutter
/// that replicates the Figma design exactly with pixel-perfect accuracy.
///
/// Features:
/// - Three chips: "Today", "Week", "Month"
/// - Active state: Dark green/black background (#0f1c14), white text, white checkmark icon
/// - Inactive state: Transparent background, dark green/black border (#0f1c14), dark green/black text
/// - Smooth animations and haptic feedback
/// - Fully responsive layout
/// Layout behavior for `ChipNavigationBar`.
/// - fill: each chip expands equally to fill available width (segmented control)
/// - hugScrollable: each chip hugs its content; chips can horizontally scroll when overflowing
enum ChipLayout { fill, hugScrollable }

class ChipNavigationBar extends StatefulWidget {
  /// List of chip labels to display
  final List<String> labels;

  /// Currently selected chip index (0-based)
  final int selectedIndex;

  /// Callback when selection changes
  final ValueChanged<int> onSelectionChanged;

  /// Optional custom styling
  final Color? activeBackgroundColor;
  final Color? activeTextColor;
  final Color? inactiveBorderColor;
  final Color? inactiveTextColor;

  /// Layout behavior; defaults to `ChipLayout.fill` (segmented control)
  final ChipLayout layout;

  /// Outer padding around the chip bar container. Defaults to symmetric horizontal 16, vertical 8
  /// to match the Steps Detail design. Override (e.g., `EdgeInsets.zero`) when parent already
  /// provides padding (such as inside a padded ListView) to avoid double padding.
  final EdgeInsetsGeometry? padding;

  /// Spacing between chips (used by both layouts). Defaults to 8.
  final double spacing;

  /// Minimum width for each chip. If null, no explicit minimum is enforced.
  final double? minChipWidth;

  /// If provided, compute [minChipWidth] from this label using the chip's
  /// text style and current text scale. Useful to standardize to a specific
  /// label width (e.g., 'HSA').
  final String? minWidthFromLabel;

  const ChipNavigationBar({
    super.key,
    required this.labels,
    this.selectedIndex = 0,
    required this.onSelectionChanged,
    this.activeBackgroundColor,
    this.activeTextColor,
    this.inactiveBorderColor,
    this.inactiveTextColor,
    this.layout = ChipLayout.fill,
    this.padding,
    this.spacing = 8,
    this.minChipWidth,
    this.minWidthFromLabel,
  });

  @override
  State<ChipNavigationBar> createState() => _ChipNavigationBarState();
}

class _ChipNavigationBarState extends State<ChipNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late int _selectedIndex;

  // Figma design colors
  static const Color _activeBackgroundColor = Color(0xFF0F1C14);
  static const Color _activeTextColor = Color(0xFFFFFFFF);
  static const Color _inactiveBorderColor = Color(0xFF0F1C14);
  static const Color _inactiveTextColor = Color(0xFF0F1C14);

  @override
  void initState() {
    super.initState();

    // Validate inputs
    assert(widget.labels.isNotEmpty, 'Labels list cannot be empty');
    assert(
      widget.selectedIndex >= 0 && widget.selectedIndex < widget.labels.length,
      'Selected index out of range',
    );

    _selectedIndex = widget.selectedIndex;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(ChipNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != _selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onChipTapped(int index) {
    if (index == _selectedIndex) return;

    // Haptic feedback for iOS feel
    HapticFeedback.selectionClick();

    setState(() {
      _selectedIndex = index;
    });

    // Animate the transition
    _animationController.forward().then((_) {
      _animationController.reset();
    });

    // Notify parent
    widget.onSelectionChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry resolvedPadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    final double? computedMinWidth = _computeMinChipWidth(context);

    // Build list of chip widgets with spacing applied to the right except the last
    final List<Widget> chipWidgets = widget.labels.asMap().entries.map((entry) {
      final int index = entry.key;
      final String label = entry.value;
      final bool isActive = index == _selectedIndex;

      final Widget chip = _buildChip(label, index, isActive, computedMinWidth);

      return Padding(
        padding: EdgeInsets.only(
          right: index < widget.labels.length - 1 ? widget.spacing : 0,
        ),
        child: chip,
      );
    }).toList();

    if (widget.layout == ChipLayout.fill) {
      return Container(
        padding: resolvedPadding,
        child: Row(
          children: widget.labels.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final bool isActive = index == _selectedIndex;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < widget.labels.length - 1 ? widget.spacing : 0,
                ),
                child: _buildChip(label, index, isActive, computedMinWidth),
              ),
            );
          }).toList(),
        ),
      );
    }

    // ChipLayout.hugScrollable
    return Container(
      padding: resolvedPadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: chipWidgets),
      ),
    );
  }

  Widget _buildChip(String label, int index, bool isActive, double? minWidth) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 40,
      constraints: BoxConstraints(minHeight: 40, minWidth: minWidth ?? 0),
      decoration: BoxDecoration(
        color: isActive
            ? (widget.activeBackgroundColor ?? _activeBackgroundColor)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? null
            : Border.all(
                color: widget.inactiveBorderColor ?? _inactiveBorderColor,
                width: 1,
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onChipTapped(index),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: isActive
                ? const EdgeInsets.only(left: 8, right: 12, top: 4, bottom: 4)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isActive) ...[
                  // Checkmark icon for active state
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                // Label text
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isActive
                        ? (widget.activeTextColor ?? _activeTextColor)
                        : (widget.inactiveTextColor ?? _inactiveTextColor),
                    height: 1.5, // line-height: 21px for 14px font
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double? _computeMinChipWidth(BuildContext context) {
    if (widget.minChipWidth != null) return widget.minChipWidth;
    final String? label = widget.minWidthFromLabel;
    if (label == null) return null;

    const TextStyle style = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );

    final TextPainter painter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    // Horizontal padding inside chip is 12 + 12
    const double horizontalPadding = 24;
    return painter.size.width + horizontalPadding;
  }
}
