import 'package:flutter/material.dart';

/// Compact summary card used in the horizontal summary row.
class SummaryMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final VoidCallback? onTap;

  const SummaryMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(width: 4),
                Text(unit, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


