import 'package:flutter/material.dart';
import '../navigation/bottom_navigation.dart';
import '../modals/currency_details_modal.dart';
import 'metric_card.dart';
import 'package:bf_design_system/bf_design_system.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../services/currency_service.dart';

/// HomepageMetricCards
/// Renders the four health app metric cards with exact data and interactions.
class HomepageMetricCards extends StatelessWidget {
  const HomepageMetricCards({super.key});

  String _formatNumber(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return buf.toString();
  }

  String _formatSigned(int value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${_formatNumber(value)}';
  }

  void _switchToTab(BuildContext context, int index) {
    TabSwitchNotification(index).dispatch(context);
  }

  void _openCurrencyModal(BuildContext context) {
    showBFModal(
      context: context,
      title: 'Your Currency',
      child: const BFModalContent(child: CurrencyDetailsModal()),
      isScrollControlled: true,
      useRootNavigator: true,
      extraTopPadding: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetricCard(
          title: 'Benefits',
          icon: Icons.card_giftcard,
          iconBackgroundColor: const Color(0xFFE2FFFB),
          primaryValue: '\$${app.lsaBalance.toStringAsFixed(0)}',
          primaryLabel: 'LSA remaining',
          secondaryValue: '4',
          secondaryLabel: 'Active benefits',
          onSeeDetails: () => _switchToTab(context, 1),
        ),
        MetricCard(
          title: 'Health',
          icon: Icons.favorite_outline, // closest match available
          iconBackgroundColor: const Color(0xFFFFECFF),
          primaryValue: '8,247',
          primaryLabel: 'Steps today',
          secondaryValue: '72',
          secondaryUnit: 'bpm',
          secondaryLabel: 'Resting heart rate',
          onSeeDetails: () => _switchToTab(context, 2),
        ),
        MetricCard(
          title: 'Social',
          icon: Icons.groups,
          iconBackgroundColor: const Color(0xFFFAFFBB),
          primaryValue: '#12',
          primaryLabel: 'Company leaderboard',
          secondaryValue: '3',
          secondaryLabel: 'Active challenges',
          onSeeDetails: () => _switchToTab(context, 3),
        ),
        ValueListenableBuilder<int>(
          valueListenable: CurrencyService().currencyNotifier,
          builder: (context, amount, _) {
            // Compute this-month delta from transaction history
            final now = DateTime.now();
            final startOfMonth = DateTime(now.year, now.month, 1);
            final txs = CurrencyService().getTransactionHistory();
            int monthDelta = 0;
            for (final t in txs) {
              if (t.timestamp.isAfter(startOfMonth) ||
                  t.timestamp.isAtSameMomentAs(startOfMonth)) {
                monthDelta += t.amount; // spent are negative already
              }
            }
            return MetricCard(
              title: 'Currency',
              icon: Icons.monetization_on_outlined, // coin/dollar symbol
              iconBackgroundColor: const Color(0xFFDFFFEC),
              primaryValue: _formatNumber(amount),
              primaryLabel: 'Current balance',
              secondaryValue: _formatSigned(monthDelta),
              secondaryLabel: 'This month',
              onSeeDetails: () => _openCurrencyModal(context),
            );
          },
        ),
      ],
    );
  }
}
