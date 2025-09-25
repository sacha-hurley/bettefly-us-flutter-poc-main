import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyMonthlyChallengeCard extends StatelessWidget {
  final String challengeTitle;
  final String challengeDescription;
  final String extendedDescription;
  final int rewardAmount;
  final VoidCallback? onOptIn;

  const CompanyMonthlyChallengeCard({
    super.key,
    this.challengeTitle = 'January Wellness Challenge',
    this.challengeDescription = "Join your company's monthly challenge",
    this.extendedDescription =
        'Complete daily goals to earn weekly and monthly rewards',
    this.rewardAmount = 5000,
    this.onOptIn,
  });

  // Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color headerText = Color(0xFF101828);
  static const Color titleText = Color(0xFF0A0A0A);
  static const Color descriptionText = Color(0xFF717182);
  static const Color badgeBackground = Color(0xFFDCFCE7);
  static const Color badgeText = Color(0xFF016630);
  static const Color buttonBackground = Color(0xFF0F1C14);
  static const Color buttonText = Color(0xFFFFFFFF);

  // Text styles - Roboto only
  TextStyle get _headerStyle => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: headerText,
  );

  TextStyle get _titleStyle => GoogleFonts.roboto(
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
    color: badgeText,
  );

  TextStyle get _buttonTextStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: buttonText,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          // Header
          Text('Company Monthly Challenge', style: _headerStyle),
          const SizedBox(height: 24),

          // Info section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      challengeTitle,
                      style: _titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                      '+${rewardAmount.toString()}',
                      style: _badgeStyle,
                    ),
                  ),
                ],
              ),

              // Description (no extra spacing)
              Text(challengeDescription, style: _descriptionStyle),

              const SizedBox(height: 8),

              // Extended description
              Text(extendedDescription, style: _descriptionStyle),
            ],
          ),

          const SizedBox(height: 16),

          // CTA button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: onOptIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32),
                elevation: 0,
              ),
              child: Text('Opt-in to Challenge', style: _buttonTextStyle),
            ),
          ),
        ],
      ),
    );
  }
}
