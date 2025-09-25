import 'dart:async';
import 'package:flutter/material.dart';

/// Lightweight app-level toast host shown at the top of the screen.
///
/// Usage:
///   NotificationHost.showToast(context, message: '+100 BetterFlies earned');
///
/// This host is mounted at the root via MaterialApp.builder in main.dart.

class NotificationHost extends StatefulWidget {
  final Widget child;

  const NotificationHost({super.key, required this.child});

  static _NotificationHostState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NotificationHostState>();
  }

  static void showToast(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(milliseconds: 3000),
    IconData icon = Icons.check_circle_outline,
  }) {
    final state = NotificationHost.of(context);
    state?._showToast(message: message, duration: duration, icon: icon);
  }

  @override
  State<NotificationHost> createState() => _NotificationHostState();
}

class _NotificationHostState extends State<NotificationHost>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  String _message = '';
  // Icon is fixed to a green success check for now; field removed
  Timer? _timer;
  // No fade state needed; slide controls visibility

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showToast({
    required String message,
    required Duration duration,
    required IconData icon,
  }) {
    _timer?.cancel();
    setState(() {
      _message = message;
      _visible = true; // visible via slide
    });

    // Hold for the requested duration
    _timer = Timer(duration, () {
      if (!mounted) return;
      setState(() => _visible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Top toast overlay
        SafeArea(
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            offset: _visible ? const Offset(0, 0) : const Offset(0, -1),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 72),
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 12,
                      bottom: 16,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(300),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x330F1C14),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x190F1C14),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left icon area (32x32) with 24 icon centered
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: Icon(
                              Icons.check_circle,
                              size: 24,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Message
                        Expanded(
                          child: Text(
                            _message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.5,
                              color: Color(0xFF0F1C14),
                              decoration:
                                  TextDecoration.none, // remove underline
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Close button area 40x40 with 24 close icon (flush right)
                        Semantics(
                          button: true,
                          label: 'Dismiss notification',
                          child: GestureDetector(
                            onTap: () => setState(() => _visible = false),
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: 24,
                                  color: const Color(0xFF0F1C14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
