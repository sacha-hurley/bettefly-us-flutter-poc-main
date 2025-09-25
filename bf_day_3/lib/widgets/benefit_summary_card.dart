import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';
import '../benefits/repository.dart';
import '../benefits/models.dart';
import '../navigation/bottom_navigation.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class BenefitSummaryCard extends StatelessWidget {
  const BenefitSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LsaBenefit>(
      future: BenefitsRepository().fetchLsaBenefit(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingCard();
        }
        if (!snapshot.hasData) {
          return const _ErrorCard();
        }
        final lsa = snapshot.data!;
        final app = context.watch<AppState>();
        final available = app.lsaBalance;
        final total = lsa.totalDollars;
        final usedFraction = total == 0
            ? 0.0
            : (1.0 - (available / total)).clamp(0.0, 1.0);
        return Card(
          elevation: 1,
          color: BdsColors.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Progress ring for used vs total
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: usedFraction.clamp(0.0, 1.0),
                        strokeWidth: 8,
                        backgroundColor: BdsColors.backgroundSecondary,
                      ),
                      Text(
                        '${(usedFraction * 100).toStringAsFixed(0)}%\nused',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Benefits', style: BdsTextStyle.displaySmall()),
                      const SizedBox(height: 4),
                      Text(
                        'Available balance: \$${available.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BdsColors.onSurfaceTextVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _recentActivity(lsa),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.green),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton(
                          onPressed: () {
                            const TabSwitchNotification(1).dispatch(context);
                          },
                          child: const Text('Manage Benefits'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _recentActivity(LsaBenefit lsa) {
    if (lsa.transactions.isEmpty) return 'No recent activity';
    final tx = lsa.transactions.first;
    final amount = (tx.centsAmount / 100.0).toStringAsFixed(2);
    return '${tx.merchant}: ${tx.centsAmount < 0 ? '-\$' : '+\$'}$amount • ${_formatDate(tx.date)}';
  }

  static String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$mm/$dd/$yyyy';
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: BdsColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: BdsColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Unable to load benefits summary',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
