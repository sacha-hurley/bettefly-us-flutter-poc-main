import 'package:flutter/material.dart';
import 'package:bf_design_system/bf_design_system.dart';
import '../services/currency_service.dart';
import '../currency/models.dart';
import '../widgets/better_flies_card.dart';

/// CurrencyDetailsModal - Full-screen modal for currency information and history
///
/// Features:
/// - Uses BFModal base component for consistent styling
/// - Displays current currency balance with reactive updates
/// - Milestone / Tier progress
/// - Activity (last 30 days) with pagination (10 at a time + Load more)
/// - Follows bubble design system patterns
class CurrencyDetailsModal extends StatefulWidget {
  /// Currency icon (defaults to flutter_dash for butterfly-like appearance)
  final IconData currencyIcon;

  /// Currency name/title
  final String currencyName;

  const CurrencyDetailsModal({
    super.key,
    this.currencyIcon = Icons.flutter_dash,
    this.currencyName = 'Your Currency',
  });

  @override
  State<CurrencyDetailsModal> createState() => _CurrencyDetailsModalState();
}

class _CurrencyDetailsModalState extends State<CurrencyDetailsModal> {
  // Number of activity items currently visible; increases by 10 when loading more
  int _visibleCount = 10;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current balance section
          _buildBalanceSection(context),

          const SizedBox(height: 24),

          // Milestone / Tier progress
          _buildTierSection(context),

          const SizedBox(height: 24),

          // History header (segmented control removed)
          _buildHistoryHeader(context),

          const SizedBox(height: 8),

          // Transaction history (last 30 days by default) with pagination
          _buildTransactionHistorySection(context),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Build the current balance display section (Figma card replacement)
  Widget _buildBalanceSection(BuildContext context) {
    return FutureBuilder<void>(
      future: CurrencyService().ensureLoaded(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return ListenableBuilder(
          listenable: CurrencyService(),
          builder: (context, _) {
            return BetterFliesCard(
              currencyCount: CurrencyService().currentCurrency,
            );
          },
        );
      },
    );
  }

  /// Build the milestone/tier section with progress to next tier
  Widget _buildTierSection(BuildContext context) {
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;
    final balance = CurrencyService().currentCurrency;
    final tier = MilestoneTierThreshold.fromBalance(balance);
    final next = MilestoneTierThreshold.toNextThreshold(balance);
    final int floor = tier.threshold;
    final int ceil = next == tier.threshold ? tier.threshold : next;
    final double progress = (ceil == floor)
        ? 1.0
        : ((balance - floor) / (ceil - floor)).clamp(0.0, 1.0);

    String tierLabel(MilestoneTier t) {
      switch (t) {
        case MilestoneTier.explorer:
          return 'Explorer';
        case MilestoneTier.champion:
          return 'Champion';
        case MilestoneTier.master:
          return 'Master';
        case MilestoneTier.legend:
          return 'Legend';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.textSecondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Milestone: ${tierLabel(tier)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                next == tier.threshold
                    ? 'Max tier reached'
                    : '${next - balance} to next',
                style: TextStyle(fontSize: 12, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 8,
              color: colors.background.withOpacity(0.7),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(color: colors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// History header (segmented control removed)
  Widget _buildHistoryHeader(BuildContext context) {
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;
    return Text(
      'Activity',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      ),
    );
  }

  /// Build the transaction history section (last 30 days, paginated in 10s)
  Widget _buildTransactionHistorySection(BuildContext context) {
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;
    final all = CurrencyService().getTransactionHistory().reversed.toList();
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    // Default to last 30 days (segmented control removed)
    final items = all.where((t) => t.timestamp.isAfter(cutoff)).toList();
    final visibleItems = _visibleCount >= items.length
        ? items
        : items.take(_visibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.textSecondary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.history, color: colors.textSecondary, size: 32),
                const SizedBox(height: 12),
                Text(
                  'No recent activity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Earn BetterFlies by completing actions',
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.textSecondary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final t = visibleItems[index];
                final isEarn =
                    t.type == BFTransactionType.earned && t.amount > 0;
                final signAmount = isEarn ? '+${t.amount}' : '${t.amount}';
                final amountColor = isEarn ? colors.success : colors.error;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (isEarn ? colors.success : colors.warning)
                            .withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isEarn ? Icons.trending_up : Icons.shopping_bag,
                        size: 18,
                        color: isEarn ? colors.success : colors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.description.isEmpty ? 'Activity' : t.description,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatSourceAndDate(t),
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      signAmount,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

        // Load more CTA
        if (items.length > visibleItems.length) ...[
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => setState(() {
                _visibleCount += 10;
              }),
              child: const Text('Load more'),
            ),
          ),
        ],
      ],
    );
  }

  String _formatSourceAndDate(BFTransaction t) {
    String source;
    switch (t.source) {
      case BFSource.tourItem:
        source = 'Tour Item';
        break;
      case BFSource.manualEntry:
        source = 'Manual';
        break;
      case BFSource.wearableSync:
        source = 'Wearable';
        break;
      case BFSource.bonus:
        source = 'Bonus';
        break;
      case BFSource.redemption:
        source = 'Redemption';
        break;
    }
    final now = DateTime.now();
    final date = t.timestamp.toLocal();
    final difference = now
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;
    String rel;
    if (difference == 0) {
      rel = 'Today';
    } else if (difference == 1) {
      rel = 'Yesterday';
    } else if (difference < 7) {
      rel = '$difference days ago';
    } else {
      // Fallback to short date for older items
      rel = date.toIso8601String().split('T').first;
    }
    return '$source · $rel';
  }
}

// (Removed old _CurrencyCountText; replaced by BetterFliesCard)
