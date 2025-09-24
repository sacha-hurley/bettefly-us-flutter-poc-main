import 'package:flutter/material.dart';
// import 'package:bubble_ds/bubble_ds.dart';
import '../benefits/repository.dart';
import '../benefits/models.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
// import '../modals/eligible_expenses_sheet.dart';
import '../widgets/transaction_card.dart';
// import '../services/analytics_service.dart';
import '../widgets/benefit_details_card.dart';

class LSADetailsScreen extends StatelessWidget {
  const LSADetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removed - now using top navigation from MainBottomNavigation
      body: FutureBuilder<LsaBenefit>(
        future: BenefitsRepository().fetchLsaBenefit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final lsa = snapshot.data!;
          final app = context.watch<AppState>();
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // New unified benefit details card
                BenefitDetailsCard(
                  lsa: lsa,
                  usedFractionOverride: 0.231, // per spec 23.1%
                  availableOverrideDollars: app.lsaBalance,
                ),

                const SizedBox(height: 16),

                // Transaction card (replaces old transactions and CTA)
                const TransactionCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Legacy formatters removed; TransactionCard handles formatting
