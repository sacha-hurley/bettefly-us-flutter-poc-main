import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble_ds/bubble_ds.dart';
import '../state/app_state.dart';
import '../navigation/bottom_navigation.dart';

class MainTodoCard extends StatelessWidget {
  const MainTodoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    final items = [
      _TodoItem(
        id: 'reviewHealth',
        label: 'Review health dashboard',
        completed: app.reviewHealth,
        disabled: false,
        action: () => TabSwitchNotification(
          2,
        ).dispatch(context), // Navigate to Health tab
      ),
      _TodoItem(
        id: 'joinChallenge',
        label: 'Opt into company challenge',
        completed: app.joinChallenge,
        disabled: false,
        action: () => TabSwitchNotification(
          3,
        ).dispatch(context), // Navigate to Social tab
      ),
      _TodoItem(
        id: 'completeChallenge',
        label: 'Complete first company daily challenge',
        completed: app.completeChallenge,
        disabled: !app.joinChallenge,
        action: () => TabSwitchNotification(
          3,
        ).dispatch(context), // Navigate to Social tab
      ),
      _TodoItem(
        id: 'browseBenefits',
        label: 'Browse eligible benefits',
        completed: app.browseBenefits,
        disabled: false,
        action: () => TabSwitchNotification(
          1,
        ).dispatch(context), // Navigate to Benefits tab
      ),
    ];

    // Compute progress once so we can show 0/4 complete + progress bar
    final completed = items.where((i) => i.completed).length;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5EB),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: BdsColors.onSurfaceTextVariant.withOpacity(0.12),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s tasks',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: BdsColors.onSurfaceText),
          ),
          const SizedBox(height: 8),
          // Inline progress row below the title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$completed/4 complete',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: BdsColors.onSurfaceTextVariant,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 8,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 4 == 0 ? 0 : (completed / 4).clamp(0.0, 1.0),
                      child: Container(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in items) ...[
            _TodoRow(item: item),
            Divider(
              color: BdsColors.onSurfaceTextVariant.withOpacity(0.3),
              height: 12,
            ),
          ],
        ],
      ),
    );
  }
}

class _TodoItem {
  _TodoItem({
    required this.id,
    required this.label,
    required this.completed,
    required this.disabled,
    required this.action,
  });
  final String id;
  final String label;
  final bool completed;
  final bool disabled;
  final VoidCallback action;
}

class _TodoRow extends StatelessWidget {
  const _TodoRow({required this.item});
  final _TodoItem item;

  @override
  Widget build(BuildContext context) {
    final baseColor = BdsColors.onSurfaceText;
    final color = item.completed ? baseColor.withOpacity(0.7) : baseColor;
    return InkWell(
      onTap: item.disabled ? null : item.action,
      child: Opacity(
        opacity: item.completed ? 0.7 : 1.0,
        child: Row(
          children: [
            Icon(
              item.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: color,
                  decoration: item.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}
