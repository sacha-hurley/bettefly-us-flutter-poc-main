import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:collection/collection.dart';
import 'package:bf_day_3/models/todo_item.dart';
import 'package:bf_day_3/services/todo_service.dart';
import 'package:bf_day_3/modals/success_todos_modal.dart';
import 'package:bf_day_3/widgets/notification_host.dart';
import 'package:bf_day_3/navigation/bottom_navigation.dart';

class TodoMainCard extends StatefulWidget {
  const TodoMainCard({super.key});

  @override
  State<TodoMainCard> createState() => _TodoMainCardState();
}

class _TodoMainCardState extends State<TodoMainCard>
    with TickerProviderStateMixin {
  final TodoService _service = TodoService();
  // Persistence is handled inside TodoService

  late final AnimationController _collapseController;
  late final Animation<double> _heightFactor;
  late final Animation<double> _opacity;

  late final AnimationController _chevronController;

  @override
  void initState() {
    super.initState();
    _collapseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = CurvedAnimation(
      parent: _collapseController,
      curve: Curves.easeInOut,
    );
    _opacity = Tween<double>(begin: 1, end: 0).animate(_heightFactor);

    _chevronController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0,
    );

    _service.ensureInitialized().then((_) {
      // Sync initial collapse state
      final collapsed = _service.isCollapsed;
      setState(() {
        if (collapsed) {
          _collapseController.value = 1.0;
          _chevronController.value = 1.0;
        } else {
          _collapseController.value = 0.0;
          _chevronController.value = 0.0;
        }
      });
    });
    _service.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    if (!mounted) return;
    // Animate collapse state if changed
    final targetCollapsed = _service.isCollapsed;
    if (targetCollapsed &&
        _collapseController.status != AnimationStatus.forward &&
        _collapseController.value == 0.0) {
      _collapseController.forward();
      _chevronController.forward();
    } else if (!targetCollapsed &&
        _collapseController.status != AnimationStatus.reverse &&
        _collapseController.value == 1.0) {
      _collapseController.reverse();
      _chevronController.reverse();
    }
    // Detect transition to all complete and show modal once
    final isAllComplete =
        _service.items.isNotEmpty && _service.items.every((e) => e.isCompleted);
    if (isAllComplete && !_shownAllDoneThisSession) {
      _showCompletionModalOnce();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _collapseController.dispose();
    _chevronController.dispose();
    _service.removeListener(_onServiceChanged);
    super.dispose();
  }

  int get _total => _service.items.length;
  int get _completed => _service.items.where((i) => i.isCompleted).length;

  Future<void> _toggleCollapse() async {
    final newCollapsed = !_service.isCollapsed;
    if (newCollapsed) {
      await Future.wait([
        _collapseController.forward(),
        _chevronController.forward(),
      ]);
    } else {
      await Future.wait([
        _collapseController.reverse(),
        _chevronController.reverse(),
      ]);
    }
    _service.setCollapsed(newCollapsed);
  }

  Future<void> _toggleComplete(TodoItem item) async {
    final becameCompleted = !item.isCompleted;
    await _service.toggleComplete(item.id);

    if (becameCompleted) {
      NotificationHost.showToast(
        context,
        message: '+${item.points} points earned',
      );
      // Announce completion
      // ignore: deprecated_member_use
      SemanticsService.announce('${item.title} completed', TextDirection.ltr);
    } else {
      // ignore: deprecated_member_use
      SemanticsService.announce(
        '${item.title} marked incomplete',
        TextDirection.ltr,
      );
    }
    // If all items completed now, show success modal once
    if (_service.items.isNotEmpty &&
        _service.items.every((e) => e.isCompleted)) {
      _showCompletionModalOnce();
    }
  }

  Future<void> _removeItem(String id) async {
    await _service.remove(id);
  }

  void _navigate(TodoItem item) {
    if (item.navigationRoute == null) return;
    switch (item.navigationRoute) {
      case '/dashboard':
        const TabSwitchNotification(2).dispatch(context);
        break;
      case '/challenges':
        // Social tab with Challenges sub-tab active: set sub-tab FIRST, then switch tab
        const SetSocialSubTabNotification(1).dispatch(context);
        const TabSwitchNotification(3).dispatch(context);
        break;
      case '/leaderboard':
        const SetSocialSubTabNotification(0).dispatch(context);
        const TabSwitchNotification(3).dispatch(context);
        break;
      case '/daily':
        const TabSwitchNotification(3).dispatch(context);
        break;
      case '/profile':
        // Could open a profile modal/screen; placeholder announcement for now
        SemanticsService.announce('Profile coming soon', TextDirection.ltr);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Outer container follows PRD: radius 32, 1px border #E5E7EB, bg white, padding 24
    return Semantics(
      label: 'Your To-dos',
      container: true,
      child: SizedBox(
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
                  _Header(
                    completed: _completed,
                    total: _total,
                    isCollapsed: _service.isCollapsed,
                    chevronController: _chevronController,
                    onToggle: _toggleCollapse,
                  ),
                  SizeTransition(
                    sizeFactor: ReverseAnimation(_heightFactor),
                    axisAlignment: -1,
                    child: FadeTransition(
                      opacity: _opacity,
                      child: Column(
                        children: [const SizedBox(height: 8), ..._buildItems()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    // Preserve original order exactly as defined in the service
    final ordered = _service.items;

    // Empty state when no to-dos remain
    if (ordered.isEmpty) {
      return [
        Semantics(
          container: true,
          label: 'No to-dos',
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7), // light gray
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: const Center(
              child: Text(
                'No to-dos',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF717182),
                  height: 20 / 14,
                ),
              ),
            ),
          ),
        ),
      ];
    }

    return ordered
        .mapIndexed(
          (index, item) => Column(
            children: [
              _TodoRow(
                item: item,
                onToggle: () => _toggleComplete(item),
                onTap: () => _navigate(item),
                onRemove: () => _removeItem(item.id),
              ),
              if (index != ordered.length - 1)
                Container(
                  height: 1,
                  color: const Color(0x0D000000), // 5% black
                ),
            ],
          ),
        )
        .toList();
  }

  bool _shownAllDoneThisSession = false;
  void _showCompletionModalOnce() {
    if (_shownAllDoneThisSession) return;
    _shownAllDoneThisSession = true;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => const SuccessTodosModal(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.completed,
    required this.total,
    required this.isCollapsed,
    required this.chevronController,
    required this.onToggle,
  });

  final int completed;
  final int total;
  final bool isCollapsed;
  final AnimationController chevronController;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your To-dos',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 28 / 18,
                  color: Color(0xFF101828),
                ),
              ),
              Text(
                '$completed of $total completed',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  color: Color(0xFF717182),
                ),
              ),
            ],
          ),
        ),
        _CollapseButton(controller: chevronController, onPressed: onToggle),
      ],
    );
  }
}

class _CollapseButton extends StatelessWidget {
  const _CollapseButton({required this.controller, required this.onPressed});
  final AnimationController controller;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Collapse to-dos',
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44, // larger hit target for accessibility
          height: 44,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final angle = controller.value * math.pi; // 180deg
                return Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      size: 20,
                      color: Color(0xFF717182),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TodoRow extends StatelessWidget {
  const _TodoRow({
    required this.item,
    required this.onToggle,
    required this.onTap,
    required this.onRemove,
  });
  final TodoItem item;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isCompleted = item.isCompleted;
    final textColor = isCompleted
        ? const Color(0xFFA3A3A3)
        : const Color(0xFF171717);

    final row = Semantics(
      label: item.title,
      button: true,
      onTapHint: 'Open task',
      child: InkWell(
        onTap: isCompleted ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onToggle,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: _StatusIcon(isCompleted: isCompleted),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                  ).copyWith(color: textColor),
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 12),
              IntrinsicWidth(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: isCompleted
                      ? IconButton(
                          tooltip: 'Remove',
                          iconSize: 20,
                          onPressed: onRemove,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF717182),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '+${item.points}',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF016630),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0xFF717182),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (isCompleted) {
      return Dismissible(
        key: ValueKey('todo-${item.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onRemove(),
        background: const SizedBox.shrink(),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          color: Colors.transparent,
          padding: const EdgeInsets.only(right: 12),
          child: const Icon(Icons.delete_outline, color: Color(0xFF717182)),
        ),
        child: row,
      );
    }
    return row;
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.isCompleted});
  final bool isCompleted;
  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF22C55E),
        ),
        child: const Center(
          child: Icon(Icons.check, size: 14, color: Colors.white),
        ),
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: const Color(0xFFA3A3A3), width: 1),
      ),
    );
  }
}
