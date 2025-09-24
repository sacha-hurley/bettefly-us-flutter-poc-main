import 'package:flutter/material.dart';

/// Details Card widget matching Figma design exactly
/// Shows health tracking details with pixel-perfect accuracy
class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // #e5e7eb
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Text(
            'Details',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Color(0xFF101828), // #101828
              height: 28 / 18, // line-height: 28px
            ),
          ),

          const SizedBox(height: 24),

          // Details List (5 rows)
          Column(
            children: [
              _buildDetailRow('Total steps', '7,233', isFirstRow: true),
              const SizedBox(height: 16),
              _buildDetailRow('Steps goal', '10,000'),
              const SizedBox(height: 16),
              _buildDetailRow('Goal progress', '72.3%', useSfProText: true),
              const SizedBox(height: 16),
              _buildDetailRow('Distance', '3.2 mi'),
              const SizedBox(height: 16),
              _buildDetailRow('Active time', '1h 23m'),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a single detail row with label and value
  Widget _buildDetailRow(
    String label,
    String value, {
    bool isFirstRow = false,
    bool useSfProText = false,
  }) {
    return Row(
      children: [
        // Left column: Label (flex-grow, left-aligned)
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: useSfProText ? 'SF Pro Text' : 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF717182), // #717182
              height: 20 / 14, // line-height: 20px
            ),
          ),
        ),

        const SizedBox(width: 4), // 4px gap between columns
        // Right column: Value (flex-grow, right-aligned)
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: useSfProText ? 'SF Pro Text' : 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: isFirstRow
                  ? const Color(0xFF4A5565) // #4a5565 for first row
                  : const Color(0xFF0A0A0A), // #0a0a0a for others
              height: 20 / 14, // line-height: 20px
            ),
          ),
        ),
      ],
    );
  }
}
