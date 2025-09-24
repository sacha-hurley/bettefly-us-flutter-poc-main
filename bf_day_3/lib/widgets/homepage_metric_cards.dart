import 'package:flutter/material.dart';
import '../navigation/bottom_navigation.dart';
import '../modals/currency_details_modal.dart';
import 'metric_card.dart';
import 'package:bf_design_system/bf_design_system.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

/// HomepageMetricCards
/// Renders the four health app metric cards with exact data and interactions.
class HomepageMetricCards extends StatelessWidget {
  const HomepageMetricCards({super.key});

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
          primaryValue: '\$${app.lsaBalance.toStringAsFixed(2)}',
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
        MetricCard(
          title: 'Currency',
          icon: Icons.monetization_on_outlined, // coin/dollar symbol
          iconBackgroundColor: const Color(0xFFDFFFEC),
          primaryValue: '9,850',
          primaryLabel: 'Current balance',
          secondaryValue: '+350',
          secondaryLabel: 'This month',
          onSeeDetails: () => _openCurrencyModal(context),
        ),
      ],
    );
  }
}
