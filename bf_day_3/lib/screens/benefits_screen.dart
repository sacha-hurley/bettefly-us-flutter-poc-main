import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';
import '../benefits/repository.dart';
import '../widgets/benefit_card.dart';
import '../widgets/chip_navigation_bar.dart';
import '../widgets/notification_host.dart';
import '../widgets/empty_benefits_state.dart';
import '../services/analytics_service.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

/// Basic scaffold for the Benefits tab. This will host:
/// - Category filters (stubbed)
/// - List of benefit cards (LSA-first)
/// - Empty state when no benefits are connected
class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  State<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen> {
  // 0 = All (pressed), 1 = LSA, 2 = HSA, 3 = Vision, 4 = Dental
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar provided by parent top navigation; keep body only
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Benefits', style: BdsTextStyle.displayMedium()),
            const SizedBox(height: 8),
            Text(
              'View and manage your available benefits.',
              style: BdsTextStyle.bodyLarge(
                color: BdsColors.onSurfaceTextVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Category filter chips — reuse Steps Detail chip design (hug + horizontal scroll)
            ChipNavigationBar(
              labels: const ['All', 'LSA', 'HSA', 'Vision', 'Dental'],
              selectedIndex: _selectedFilter,
              onSelectionChanged: (index) {
                setState(() => _selectedFilter = index);
                final label = ['All', 'LSA', 'HSA', 'Vision', 'Dental'][index];
                AnalyticsService().logEvent(
                  'benefits_filter_selected',
                  parameters: {'label': label},
                );
              },
              layout: ChipLayout.hugScrollable,
              // Parent already has ListView padding, so avoid double padding
              padding: const EdgeInsets.symmetric(vertical: 8),
              // Ensure all chips are at least as wide as the 'HSA' chip
              minWidthFromLabel: 'HSA',
            ),

            const SizedBox(height: 32),

            FutureBuilder(
              future: BenefitsRepository().fetchLsaBenefit(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Text(
                        'Failed to load benefits',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                final benefit = snapshot.data;
                if (benefit == null) {
                  return EmptyBenefitsState(
                    onConnect: () {
                      AnalyticsService().logEvent('benefits_connect_tapped');
                      NotificationHost.showToast(
                        context,
                        message: 'Connect flow coming soon',
                        icon: Icons.link,
                      );
                    },
                  );
                }
                AnalyticsService().logEvent(
                  'benefits_loaded',
                  parameters: {'category': benefit.category},
                );
                // Show LSA card only when All or LSA filter is selected
                final showLsa = _selectedFilter == 0 || _selectedFilter == 1;
                if (!showLsa) {
                  return const SizedBox.shrink();
                }

                // Use centralized AppState for live LSA available balance
                final app = context.watch<AppState>();
                final available = app.lsaBalance;
                final total = benefit.totalDollars;
                final percent = total == 0
                    ? 0.0
                    : (available / total).clamp(0.0, 1.0);
                final usedStr = available.toStringAsFixed(0);
                final totalStr = total.toStringAsFixed(0);
                final expiry = _formatExpiry(benefit.expirationDate);

                return BenefitCard(
                  title: 'Limited Spending Account',
                  badgeText: 'LSA',
                  balanceUsed: usedStr,
                  balanceTotal: totalStr,
                  progressPercentage: percent,
                  cardNumber: benefit.maskedCardNumber,
                  issuer: benefit.providerName,
                  expirationDate: expiry,
                  onUploadReceipt: () {
                    AnalyticsService().logEvent('upload_receipt_tapped');
                    NotificationHost.showToast(
                      context,
                      message: 'Receipt upload coming soon',
                      icon: Icons.upload_file,
                    );
                  },
                  onViewDetails: () {
                    AnalyticsService().logEvent('benefit_view_details');
                    Navigator.of(
                      context,
                    ).pushNamed('/lsa', arguments: {'title': 'LSA Benefits'});
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatExpiry(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final yy = (date.year % 100).toString().padLeft(2, '0');
    return '$mm/$yy';
  }

  // Deprecated: replaced by `ChipNavigationBar` to unify design with Steps Detail.
}
