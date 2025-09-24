import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MetricCard
/// Reusable card matching the Figma spec:
/// - White background, 32 radius, 1px rgba(0,0,0,0.05) border
/// - Internal padding 25, vertical gaps 16
/// - Header: 36x36 colored box (radius 10, padding 8) with 20px icon
/// - Title: Roboto 16/24, color #0A0A0A
/// - Metrics row: two columns, 16 gap
///   - Value: Roboto SemiBold 24/36, #0A0A0A
///   - Label: Roboto Regular 14/20, #717182
/// - Footer: top border 1px rgba(0,0,0,0.03), 17 top padding
///   - "See details" label: Roboto Regular 14/20, #717182 and trailing chevron icon 16px
class MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBackgroundColor;
  final String primaryValue;
  final String primaryLabel;
  final String secondaryValue;
  final String secondaryLabel;
  final String?
  secondaryUnit; // e.g., "bpm" for Health; baseline-aligned when provided
  final VoidCallback? onSeeDetails;

  const MetricCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconBackgroundColor,
    required this.primaryValue,
    required this.primaryLabel,
    required this.secondaryValue,
    required this.secondaryLabel,
    this.secondaryUnit,
    this.onSeeDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0x0D000000), // rgba(0,0,0,0.05)
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: const Color(0xFF0A0A0A)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF0A0A0A),
                      height: 24 / 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        primaryValue,
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A0A0A),
                          height: 36 / 24,
                        ),
                      ),
                      Text(
                        primaryLabel,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF717182),
                          height: 20 / 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((secondaryUnit ?? '').isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              secondaryValue,
                              style: GoogleFonts.roboto(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0A0A0A),
                                height: 36 / 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              secondaryUnit!,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF717182),
                                height: 20 / 14,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          secondaryValue,
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0A0A0A),
                            height: 36 / 24,
                          ),
                        ),
                      Text(
                        secondaryLabel,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF717182),
                          height: 20 / 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(top: 17),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0x08000000), // rgba(0,0,0,0.03)
                    width: 1,
                  ),
                ),
              ),
              child: InkWell(
                onTap: onSeeDetails,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'See details',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF717182),
                        height: 20 / 14,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Color(0xFF717182),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
