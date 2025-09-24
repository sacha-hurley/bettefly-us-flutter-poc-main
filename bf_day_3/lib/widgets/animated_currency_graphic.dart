import 'package:flutter/material.dart';

/// AnimatedCurrencyGraphic
/// A tiny wrapper that applies a brief scale/flash animation when the
/// [amount] changes. Intended to wrap the currency icon/graphic in the top bar.
class AnimatedCurrencyGraphic extends StatefulWidget {
  final int amount;
  final Widget child;

  const AnimatedCurrencyGraphic({
    super.key,
    required this.amount,
    required this.child,
  });

  @override
  State<AnimatedCurrencyGraphic> createState() =>
      _AnimatedCurrencyGraphicState();
}

class _AnimatedCurrencyGraphicState extends State<AnimatedCurrencyGraphic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  int _lastAmount = 0;

  @override
  void initState() {
    super.initState();
    _lastAmount = widget.amount;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void didUpdateWidget(covariant AnimatedCurrencyGraphic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amount != _lastAmount) {
      _lastAmount = widget.amount;
      // Play a quick scale up and down
      _controller.forward(from: 0.0).then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
