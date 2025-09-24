import 'package:flutter/material.dart';
import '../benefits/models.dart';

/// BenefitDetailsCard
///
/// Pixel-precise card for Limited Spending Account (LSA) benefit details.
/// This widget is self-contained and renders purely from the provided
/// LsaBenefit data and computed display values.
class BenefitDetailsCard extends StatelessWidget {
  final LsaBenefit lsa;

  /// Fraction used, e.g. 0.231 for 23.1% used.
  /// If not provided, computed from [lsa.usedFraction].
  final double? usedFractionOverride;

  /// Optional override for available dollars to reflect live app state
  /// (e.g., credits from BetterFlies redemptions). When provided, the
  /// displayed Available and Usage values will derive from this amount
  /// and remain consistent with the progress bar.
  final double? availableOverrideDollars;

  const BenefitDetailsCard({
    super.key,
    required this.lsa,
    this.usedFractionOverride,
    this.availableOverrideDollars,
  });

  static const Color primaryText = Color(0xFF101828);
  static const Color secondaryText = Color(0xFF4A5565);
  static const Color tertiaryText = Color(0xFF717182);
  static const Color blueBadgeBackground = Color(0xFFDBEAFE);
  static const Color blueBadgeText = Color(0xFF193CB8);
  static const Color greenBadgeBackground = Color(0xFFDCFCE7);
  static const Color greenBadgeText = Color(0xFF016630);
  static const Color progressGreen = Color(0xFF22C55E);
  static const Color borderGray = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    // Compute display values
    final double total = lsa.totalDollars; // e.g. 1950.00
    final double available = (availableOverrideDollars ?? lsa.availableDollars)
        .clamp(0, double.infinity);
    final double used = (availableOverrideDollars != null)
        ? (total - available).clamp(0, double.infinity)
        : lsa.usedDollars; // keep consistent when overriding available

    // Used fraction (0..1). The spec gives 0.231 specifically.
    final double usedFraction =
        (usedFractionOverride ?? (total == 0 ? 0 : (total - available) / total))
            .clamp(0.0, 1.0);

    // Formatters
    String formatMoney(double amount) => '\$${amount.toStringAsFixed(2)}';

    String formatPercent(double fraction) =>
        '${(fraction * 100).toStringAsFixed(1)}%';

    return Container(
      width: double.infinity,
      // Height wraps content by default
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: borderGray, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Limited Spending Account',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    height: 28 / 18,
                    color: primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
                decoration: BoxDecoration(
                  color: blueBadgeBackground,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'LSA',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 1.0,
                    color: blueBadgeText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // BALANCE SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Available Balance',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  height: 1.25,
                  color: secondaryText,
                ),
              ),
              Flexible(
                child: Text(
                  '${formatMoney(available)} of ${formatMoney(total)}',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.25,
                    color: primaryText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              height: 8,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(23, 23, 23, 0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: usedFraction, // fraction used
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: progressGreen,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Usage text
          Text(
            '${formatMoney(used)} of ${formatMoney(total)} used (${formatPercent(usedFraction)})',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
              fontSize: 12,
              height: 1.2,
              color: tertiaryText,
            ),
          ),

          const SizedBox(height: 17),

          // Divider
          const Divider(
            height: 1,
            thickness: 1,
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),

          const SizedBox(height: 16),

          // DETAILS SECTION
          _detailRow(
            label: 'Status',
            valueWidget: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
              decoration: BoxDecoration(
                color: greenBadgeBackground,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Text(
                'Active',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  height: 1.25,
                  color: greenBadgeText,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          _detailRow(label: 'Benefit number', valueText: lsa.maskedCardNumber),

          const SizedBox(height: 16),

          _detailRow(label: 'Employer', valueText: lsa.providerName),

          const SizedBox(height: 16),

          _detailRow(
            label: 'Employer Contribution',
            valueText: formatMoney(total),
          ),

          const SizedBox(height: 16),

          _detailRow(
            label: 'Plan Year',
            valueText: _formatPlanYear(
              DateTime(lsa.planYear, 1, 1),
              DateTime(lsa.planYear, 12, 31),
            ),
          ),

          const SizedBox(height: 16),

          _detailRow(
            label: 'Expires',
            valueText: _formatExpiry(lsa.expirationDate),
          ),
        ],
      ),
    );
  }

  static Widget _detailRow({
    required String label,
    String? valueText,
    Widget? valueWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
              fontSize: 14,
              height: 1.25,
              color: tertiaryText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child:
                valueWidget ??
                Text(
                  valueText ?? '',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.25,
                    color: primaryText,
                  ),
                ),
          ),
        ),
      ],
    );
  }

  static String _formatExpiry(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final yy = (date.year % 100).toString().padLeft(2, '0');
    return '$mm/$yy';
  }

  static String _formatPlanYear(DateTime start, DateTime end) {
    String monthName(int m) => _monthNames[m - 1];
    return '${monthName(start.month)} ${start.day}, ${start.year} - '
        '${monthName(end.month)} ${end.day}, ${end.year}';
  }

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}
