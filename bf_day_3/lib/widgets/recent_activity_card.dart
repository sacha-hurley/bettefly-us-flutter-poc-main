import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityItem {
  final String title;
  final String timestamp;
  final int rewardAmount;

  const ActivityItem({
    required this.title,
    required this.timestamp,
    required this.rewardAmount,
  });
}

class RecentActivityCard extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivityCard({super.key, required this.activities});

  // Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color headerText = Color(0xFF101828);
  static const Color titleText = Color(0xFF0A0A0A);
  static const Color timestampText = Color(0xFF717182);
  static const Color badgeBackground = Color(0xFFDCFCE7);
  static const Color badgeText = Color(0xFF016630);
  static const Color dividerColor = Color(0x0D000000); // rgba(0,0,0,0.05)

  // Text styles (Roboto)
  TextStyle get _headerStyle => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: headerText,
  );

  TextStyle get _activityTitleStyle => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    color: titleText,
  );

  TextStyle get _timestampStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: timestampText,
  );

  TextStyle get _badgeStyle => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: badgeText,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // No external margin; page provides 16px padding
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border.all(color: cardBorder, width: 1.0),
        borderRadius: BorderRadius.circular(32.0),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Recent Activity', style: _headerStyle),
          const SizedBox(height: 24),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final isLast = index == activities.length - 1;

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          bottom: BorderSide(color: dividerColor, width: 1.0),
                        ),
                ),
                padding: const EdgeInsets.only(top: 12, bottom: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            activity.title,
                            style: _activityTitleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(activity.timestamp, style: _timestampStyle),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 9,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBackground,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Text(
                        '+${activity.rewardAmount}',
                        style: _badgeStyle,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
