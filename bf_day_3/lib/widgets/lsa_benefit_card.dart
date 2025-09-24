import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';
import '../benefits/models.dart';

class LSABenefitCard extends StatelessWidget {
  final LsaBenefit benefit;
  final VoidCallback? onUploadReceipt;
  final VoidCallback? onViewDetails;

  const LSABenefitCard({
    super.key,
    required this.benefit,
    this.onUploadReceipt,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final used = benefit.usedDollars;
    final total = benefit.totalDollars;
    final usedFraction = benefit.usedFraction;

    return Card(
      elevation: 1,
      color: BdsColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.credit_card, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Limited Spending Account',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          _TypeChip(label: 'LSA'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${benefit.maskedCardNumber} • ${benefit.providerName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BdsColors.onSurfaceTextVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Expires ${_formatExpiry(benefit.expirationDate)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: BdsColors.onSurfaceTextVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: usedFraction.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: BdsColors.backgroundSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'Used \$${used.toStringAsFixed(0)} of \$${total.toStringAsFixed(0)} available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: BdsColors.onSurfaceTextVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: onUploadReceipt,
                  child: const Text('Upload Receipt'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onViewDetails,
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatExpiry(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final yy = (date.year % 100).toString().padLeft(2, '0');
    return '$mm/$yy';
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  const _TypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: BdsColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style:
            Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: BdsColors.onSurfaceText) ??
            const TextStyle(fontSize: 10),
      ),
    );
  }
}
