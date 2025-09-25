import 'package:flutter/material.dart';
import 'package:bf_design_system/bf_design_system.dart';
import '../navigation/bottom_navigation.dart';
import 'home_shortcut_card.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../services/currency_service.dart';
import '../modals/currency_details_modal.dart';

class HomeShortcutsSection extends StatelessWidget {
  const HomeShortcutsSection({super.key});

  void _gotoTab(BuildContext context, int index) {
    TabSwitchNotification(index).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final currency = CurrencyService().currencyNotifier.value;
    return Column(
      children: [
        HomeShortcutCard(
          headerIconBg: const Color(0xFFAFF3E9),
          headerIcon: Icons.credit_card,
          title: 'Benefits',
          leftValue: '\$${app.lsaBalance.toStringAsFixed(0)}',
          leftCaption: 'LSA remaining',
          rightValue: '1',
          rightCaption: 'Active benefits',
          ctaLabel: 'View Details',
          onTap: () => _gotoTab(context, 1),
        ),
        const SizedBox(height: 16),
        HomeShortcutCard(
          headerIconBg: const Color(0xFFF8C6F9),
          headerIcon: Icons.favorite,
          title: 'Health',
          leftValue: '${app.currentSteps}',
          leftCaption: 'Steps today',
          rightValue: '72 bpm',
          rightCaption: 'Resting heart rate',
          ctaLabel: 'View Dashboard',
          onTap: () => _gotoTab(context, 2),
        ),
        const SizedBox(height: 16),
        HomeShortcutCard(
          headerIconBg: const Color(0xFFEBF660),
          headerIcon: Icons.people,
          title: 'Social',
          leftValue: app.hasJoinedCompany ? '#12' : '#—',
          leftCaption: 'Company leaderboard',
          rightValue: app.hasJoinedCompany ? '1' : '0',
          rightCaption: 'Active challenges',
          ctaLabel: 'View Leaderboard',
          onTap: () => _gotoTab(context, 3),
        ),
        const SizedBox(height: 16),
        HomeShortcutCard(
          headerIconBg: const Color(0xFF75F1A8),
          headerIcon: Icons.savings,
          title: 'Currency',
          leftValue: '$currency',
          leftCaption: 'Current balance',
          rightValue: '+350',
          rightCaption: 'This month',
          ctaLabel: 'Redeem Rewards',
          onTap: () {
            showBFModal(
              context: context,
              title: 'Your Currency',
              child: const BFModalContent(child: CurrencyDetailsModal()),
              isScrollControlled: true,
              useRootNavigator: true,
              extraTopPadding: 16,
            );
          },
        ),
      ],
    );
  }
}
