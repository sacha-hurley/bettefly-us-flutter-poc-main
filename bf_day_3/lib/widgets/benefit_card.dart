import 'package:flutter/material.dart';

/// Pixel-perfect BenefitCard widget per design spec.
///
/// This widget intentionally uses a Container (not Card) to avoid elevation/shadow
/// and adheres to exact spacings, colors, and typography specified.
class BenefitCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final String balanceUsed; // e.g., "450"
  final String balanceTotal; // e.g., "1950"
  final double progressPercentage; // 0.0 - 1.0 (available / total)
  final String cardNumber; // e.g., "**** **** **** 1234"
  final String issuer; // e.g., "Acme Benefits"
  final String expirationDate; // e.g., "12/26"
  final VoidCallback? onUploadReceipt;
  final VoidCallback? onViewDetails;

  const BenefitCard({
    super.key,
    required this.title,
    required this.badgeText,
    required this.balanceUsed,
    required this.balanceTotal,
    required this.progressPercentage,
    required this.cardNumber,
    required this.issuer,
    required this.expirationDate,
    this.onUploadReceipt,
    this.onViewDetails,
  });

  // Design tokens (local to this widget)
  static const Color _primaryText = Color(0xFF101828);
  static const Color _secondaryText = Color(0xFF4A5565);
  static const Color _tertiaryText = Color(0xFF6A7282);
  static const Color _badgeBackground = Color(0xFFF0F4FF);
  static const Color _badgeText = Color(0xFF193CB8);
  static const Color _progressFill = Color(0xFF22C55E); // remaining
  static const Color _buttonPrimary = Color(0xFF0F1C14);
  static const Color _borderColor = Color(0xFFE5E7EB);
  static const Color _progressBackground = Color(
    0xFF6B7280,
  ); // spent (neutral-500)

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Benefit card: $title',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: _borderColor, width: 1),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildAccountInfo(context),
            const SizedBox(height: 24),
            _buildCardInfo(context),
            const SizedBox(height: 24),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title: Roboto Regular, 18px, #101828, line-height 28px
        Flexible(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              height: 28 / 18,
              fontWeight: FontWeight.w400,
              color: _primaryText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Badge (fully rounded)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
          decoration: BoxDecoration(
            color: _badgeBackground,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              color: _badgeText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfo(BuildContext context) {
    final double availableFraction = progressPercentage.clamp(0.0, 1.0);
    final double usedFraction = (1.0 - availableFraction).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Balance info row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Balance',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w400,
                color: _secondaryText,
              ),
            ),
            Text(
              '\$${balanceUsed} of \$${balanceTotal}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
                color: _primaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Progress bar (green = remaining on the right, gray = spent on the left)
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            height: 8,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Base: remaining (green) full width
                Container(color: _progressFill),
                // Overlay: spent (neutral-500 gray) sized to usedFraction on the left
                FractionallySizedBox(
                  widthFactor: usedFraction,
                  alignment: Alignment.centerLeft,
                  child: Container(color: _progressBackground),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card number
        Text(
          cardNumber,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.w400,
            color: _secondaryText,
          ),
        ),
        const SizedBox(height: 4),
        // Issuer / Expiration row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              issuer,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w400,
                color: _tertiaryText,
              ),
            ),
            Text(
              'Expires $expirationDate',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w400,
                color: _tertiaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _borderColor, width: 1)),
      ),
      padding: const EdgeInsets.only(top: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Primary button (Upload receipt) — full width, centered label, stadium shape
          Semantics(
            button: true,
            label: 'Upload receipt',
            child: ElevatedButton(
              onPressed: onUploadReceipt,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: _buttonPrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 0,
                ),
                alignment: Alignment.center,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              child: const Text('Upload receipt', textAlign: TextAlign.center),
            ),
          ),
          const SizedBox(height: 8),
          // Secondary button (View details) — full width, centered label, stadium shape
          Semantics(
            button: true,
            label: 'View details',
            child: OutlinedButton(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 0,
                ),
                foregroundColor: _buttonPrimary,
                side: const BorderSide(color: _buttonPrimary, width: 1),
                alignment: Alignment.center,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              child: const Text('View details', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}
