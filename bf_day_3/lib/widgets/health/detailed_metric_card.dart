import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';

/// Base health metric card per spec (32px radius, 25px padding, subtle border).
class HealthMetricCardBase extends StatelessWidget {
  final Color themeColor;
  final Color pillBgColor;
  final IconData icon;
  final String title;
  final String subtitle; // usually "Today"
  final String valueText;
  final String unitText;
  final String contextText; // goal or context line
  final Widget trailingVisualization; // ring or sparkline
  final VoidCallback? onSeeDetails;

  const HealthMetricCardBase({
    super.key,
    required this.themeColor,
    required this.pillBgColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.valueText,
    required this.unitText,
    required this.contextText,
    required this.trailingVisualization,
    this.onSeeDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pillBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: themeColor, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: BdsTextStyle.bodyLarge()), // 16px
                    Text(
                      subtitle,
                      style: BdsTextStyle.bodyMedium(
                        color: const Color(0xFF717182),
                      ),
                    ), // 14px
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Main content
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            valueText,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ), // ~24px semi-bold
                          const SizedBox(width: 8),
                          Text(
                            unitText,
                            style: BdsTextStyle.bodyMedium(
                              color: const Color(0xFF717182),
                            ),
                          ), // 14px
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contextText,
                        style: BdsTextStyle.bodyMedium(
                          color: const Color(0xFF717182),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                trailingVisualization,
              ],
            ),
            const SizedBox(height: 17),
            // Bottom section
            const Divider(
              height: 1,
              thickness: 1,
              color: Color.fromRGBO(0, 0, 0, 0.03),
            ),
            const SizedBox(height: 17),
            GestureDetector(
              onTap: onSeeDetails,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'See details',
                    style: BdsTextStyle.bodyMedium(
                      color: const Color(0xFF717182),
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
          ],
        ),
      ),
    );
  }
}
