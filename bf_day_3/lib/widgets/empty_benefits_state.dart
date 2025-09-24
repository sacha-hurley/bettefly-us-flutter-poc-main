import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';

class EmptyBenefitsState extends StatelessWidget {
  final VoidCallback? onConnect;
  const EmptyBenefitsState({super.key, this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: BdsColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.credit_card_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text('No benefits connected', style: BdsTextStyle.displaySmall()),
            const SizedBox(height: 8),
            Text(
              'Connect a benefit to view balances, transactions, and eligible expenses.',
              textAlign: TextAlign.center,
              style: BdsTextStyle.bodyLarge(
                color: BdsColors.onSurfaceTextVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onConnect,
              child: const Text('Connect a Benefit'),
            ),
          ],
        ),
      ),
    );
  }
}
