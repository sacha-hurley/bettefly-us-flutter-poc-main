import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DailyChallengeCard extends StatelessWidget {
  final String challengeTitle;
  final String challengeDescription;
  final int currentProgress;
  final int targetGoal;
  final int rewardAmount;
  final String challengeType;

  const DailyChallengeCard({
    super.key,
    this.challengeTitle = 'Daily Step Goal',
    this.challengeDescription = 'Complete 10,000 steps today',
    this.currentProgress = 1500,
    this.targetGoal = 10000,
    this.rewardAmount = 100,
    this.challengeType = 'Challenge',
  });

  double get _progressFraction {
    if (targetGoal <= 0) return 0;
    final f = currentProgress / targetGoal;
    if (f.isNaN || f.isInfinite) return 0;
    return f.clamp(0.0, 1.0);
  }

  String _formatNumber(int value) {
    final fmt = NumberFormat.decimalPattern();
    return fmt.format(value);
  }

  // Styling constants (Roboto everywhere per project rule)
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color headerText = Color(0xFF101828);
  static const Color titleText = Color(0xFF0A0A0A);
  static const Color descriptionText = Color(0xFF717182);
  static const Color progressLabel = Color(0xFF4A5565);
  static const Color progressValue = Color(0xFF101828);
  static const Color neutralBadgeBackground = Color(0xFFF5F5F5);
  static const Color neutralBadgeText = Color(0xFF737373);
  static const Color greenBadgeBackground = Color(0xFFDCFCE7);
  static const Color greenBadgeText = Color(0xFF016630);
  static const Color progressTrack = Color(0x33171717); // rgba(23,23,23,0.2)
  static const Color progressFill = Color(0xFF22C55E);

  TextStyle get _headerStyle => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: headerText,
  );

  TextStyle get _challengeTitleStyle => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    color: titleText,
  );

  TextStyle get _descriptionStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: descriptionText,
  );

  TextStyle get _badgeStyle => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
  );

  TextStyle get _progressLabelStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: progressLabel,
  );

  TextStyle get _progressValueStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: progressValue,
  );

  @override
  Widget build(BuildContext context) {
    final formattedCurrent = _formatNumber(currentProgress);
    final formattedTarget = _formatNumber(targetGoal);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 384),
        child: Semantics(
          container: true,
          label: 'Daily challenge card',
          child: Container(
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: cardBorder, width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Daily Challenge', style: _headerStyle),
                const SizedBox(height: 24),

                // Title + badges row (vertically centered)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(challengeTitle, style: _challengeTitleStyle),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Badge(
                          background: neutralBadgeBackground,
                          textColor: neutralBadgeText,
                          label: challengeType,
                          textStyle: _badgeStyle,
                        ),
                        const SizedBox(width: 4),
                        _Badge(
                          background: greenBadgeBackground,
                          textColor: greenBadgeText,
                          label: '+$rewardAmount',
                          textStyle: _badgeStyle,
                        ),
                      ],
                    ),
                  ],
                ),

                // Description directly under title row (no extra spacing above)
                Text(challengeDescription, style: _descriptionStyle),

                const SizedBox(height: 8),

                // Progress header row
                Row(
                  children: [
                    Text('Progress', style: _progressLabelStyle),
                    const Spacer(),
                    Text(
                      '$formattedCurrent / $formattedTarget steps',
                      style: _progressValueStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Progress bar with semantics
                Semantics(
                  label: 'Daily steps progress',
                  value: '$formattedCurrent of $formattedTarget steps',
                  maxValueLength: targetGoal,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final fullWidth = constraints.maxWidth;
                        final filledWidth = fullWidth * _progressFraction;
                        return Stack(
                          children: [
                            Container(
                              height: 8,
                              width: fullWidth,
                              color: progressTrack,
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              height: 8,
                              width: filledWidth,
                              color: progressFill,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final Color background;
  final Color textColor;
  final String label;
  final TextStyle textStyle;

  const _Badge({
    required this.background,
    required this.textColor,
    required this.label,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
      child: Text(label, style: textStyle.copyWith(color: textColor)),
    );
  }
}
