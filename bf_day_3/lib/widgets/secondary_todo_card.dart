import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../services/todo_service.dart';
import '../services/currency_service.dart';

class SecondaryTodoCard extends StatefulWidget {
  final List<String> todoIds;
  final String pageContext;
  final String? titleOverride;
  final String? subtitleOverride;

  const SecondaryTodoCard({
    super.key,
    required this.todoIds,
    required this.pageContext,
    this.titleOverride,
    this.subtitleOverride,
  });

  @override
  State<SecondaryTodoCard> createState() => _SecondaryTodoCardState();
}

class _SecondaryTodoCardState extends State<SecondaryTodoCard>
    with TickerProviderStateMixin {
  late final AnimationController _completionController;
  final TodoService _service = TodoService();

  @override
  void initState() {
    super.initState();
    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Ensure global todos are loaded and subscribe to changes
    _service.ensureInitialized().then((_) {
      if (mounted) setState(() {});
    });
    _service.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    _completionController.dispose();
    _service.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _markComplete(String id, {int points = 100}) async {
    await TodoService().markComplete(id);
    await CurrencyService().addCurrency(points);
    // ignore: deprecated_member_use
    SemanticsService.announce(
      'Completed. +$points BetterFlies',
      TextDirection.ltr,
    );
    if (mounted) setState(() {});
    await _completionController.forward();
    _completionController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final items = _service.items
        .where((e) => widget.todoIds.contains(e.id))
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'To-dos',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    height: 28 / 18,
                    color: Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 8),
                if (items.isNotEmpty)
                  _SecondaryRow(
                    id: items.first.id,
                    title: widget.titleOverride ?? items.first.title,
                    subtitle:
                        widget.subtitleOverride ??
                        'Scroll down and explore the content below.',
                    completed: items.first.isCompleted,
                    onComplete: () => _markComplete(
                      items.first.id,
                      points: items.first.points,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryRow extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final bool completed;
  final VoidCallback onComplete;
  const _SecondaryRow({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              color: Color(0xFF0A0A0A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: Color(0xFF717182),
            ),
          ),
          const SizedBox(height: 12),
          completed
              ? SizedBox(
                  height: 40,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 32),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFFDBDDDC),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Color(0xFF22C55E),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: Color(0xFF939995),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF0F1C14),
                        width: 1,
                      ),
                      foregroundColor: const Color(0xFF0F1C14),
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      fixedSize: const Size.fromHeight(40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.standard,
                    ),
                    onPressed: onComplete,
                    child: const Text(
                      'Mark as complete',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Color(0xFF0F1C14),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
