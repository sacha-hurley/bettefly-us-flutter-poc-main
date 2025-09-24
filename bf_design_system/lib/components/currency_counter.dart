import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// BFCurrencyCounter - A reusable currency display component
///
/// Features:
/// - Displays currency icon and amount
/// - Consistent styling from bubble DS
/// - Supports tap interactions
/// - Reactive updates via ValueNotifier or similar
/// - Customizable icon and colors
class BFCurrencyCounter extends StatelessWidget {
  /// The currency amount to display
  final int amount;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Currency icon (defaults to flutter_dash for butterfly-like appearance)
  final IconData icon;

  /// Icon color override
  final Color? iconColor;

  /// Text color override
  final Color? textColor;

  /// Icon size
  final double iconSize;

  /// Text size
  final double fontSize;

  /// Optional custom graphic to use instead of the material [icon]. For example,
  /// an SVG passed from the app layer. When provided, this widget is rendered
  /// in place of the [Icon] and the [icon], [iconColor], and [iconSize]
  /// parameters are ignored for display purposes.
  final Widget? iconGraphic;

  const BFCurrencyCounter({
    super.key,
    required this.amount,
    this.onTap,
    this.icon = Icons.flutter_dash, // Butterfly-like icon as specified in PRD
    this.iconColor,
    this.textColor,
    this.iconSize = 20.0,
    this.fontSize = 16.0,
    this.iconGraphic,
  });

  @override
  Widget build(BuildContext context) {
    // Get bubble DS colors from theme
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;

    final Widget leadingIcon =
        iconGraphic ??
        Icon(
          icon,
          size: iconSize,
          color: iconColor ?? colors.warning, // Orange color for currency
        );

    final counter = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leadingIcon,
        const SizedBox(width: 4),
        Text(
          amount.toString(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor ?? colors.textPrimary,
          ),
        ),
      ],
    );

    // If onTap is provided, wrap in GestureDetector with tap feedback
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          child: counter,
        ),
      );
    }

    return counter;
  }
}

/// BFReactiveCurrencyCounter - A currency counter that automatically updates
/// when the provided ValueNotifier changes
///
/// This version is perfect for use with services that notify of currency changes
class BFReactiveCurrencyCounter extends StatelessWidget {
  /// ValueNotifier that holds the current currency amount
  final ValueNotifier<int> currencyNotifier;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Currency icon (defaults to flutter_dash for butterfly-like appearance)
  final IconData icon;

  /// Icon color override
  final Color? iconColor;

  /// Text color override
  final Color? textColor;

  /// Icon size
  final double iconSize;

  /// Text size
  final double fontSize;

  /// Optional custom graphic to use instead of the material [icon].
  final Widget? iconGraphic;

  const BFReactiveCurrencyCounter({
    super.key,
    required this.currencyNotifier,
    this.onTap,
    this.icon = Icons.flutter_dash,
    this.iconColor,
    this.textColor,
    this.iconSize = 20.0,
    this.fontSize = 16.0,
    this.iconGraphic,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currencyNotifier,
      builder: (context, amount, child) {
        return BFCurrencyCounter(
          amount: amount,
          onTap: onTap,
          icon: icon,
          iconColor: iconColor,
          textColor: textColor,
          iconSize: iconSize,
          fontSize: fontSize,
          iconGraphic: iconGraphic,
        );
      },
    );
  }
}

class BFAnimatedCurrencyCounter extends StatefulWidget {
  final int amount;
  final VoidCallback? onTap;
  final IconData icon;
  final Color? iconColor;
  final Color? textColor;
  final double iconSize;
  final double fontSize;
  final Widget? iconGraphic;

  const BFAnimatedCurrencyCounter({
    super.key,
    required this.amount,
    this.onTap,
    this.icon = Icons.flutter_dash,
    this.iconColor,
    this.textColor,
    this.iconSize = 20.0,
    this.fontSize = 16.0,
    this.iconGraphic,
  });

  @override
  State<BFAnimatedCurrencyCounter> createState() =>
      _BFAnimatedCurrencyCounterState();
}

class _BFAnimatedCurrencyCounterState extends State<BFAnimatedCurrencyCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _roll; // 0..1 progress mapped to value tween
  int _startAmount = 0;
  int _endAmount = 0;

  @override
  void initState() {
    super.initState();
    _startAmount = widget.amount;
    _endAmount = widget.amount;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // 0.2s + 0.3s + 0.2s
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.12,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.12,
          end: 1.06,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.06,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    // Roll progresses only during the middle window (0.2..0.5)
    _roll = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant BFAnimatedCurrencyCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amount != oldWidget.amount) {
      // Only run celebratory sequence on increases
      if (widget.amount > oldWidget.amount) {
        _startAmount = oldWidget.amount;
        _endAmount = widget.amount;
        _controller.forward(from: 0);
      } else {
        // Decrease or equal: update without celebration
        _startAmount = widget.amount;
        _endAmount = widget.amount;
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _animatedAmount {
    final t = _roll.value; // 0..1
    final value = _startAmount + ((_endAmount - _startAmount) * t);
    return value.round();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;

    final Widget leadingIcon =
        widget.iconGraphic ??
        Icon(
          widget.icon,
          size: widget.iconSize,
          color: widget.iconColor ?? colors.warning,
        );

    final child = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final displayAmount =
            (_controller.isAnimating && _endAmount > _startAmount)
            ? _animatedAmount
            : widget.amount;
        return Transform.scale(
          scale: _scale.value.clamp(0.9, 1.2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              leadingIcon,
              const SizedBox(width: 4),
              Text(
                displayAmount.toString(),
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor ?? colors.textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          child: child,
        ),
      );
    }

    return child;
  }
}
