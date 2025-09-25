import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyMonthlyChallengeOptedInCard extends StatefulWidget {
  final String challengeTitle;
  final String challengeDescription;
  final int monthlyReward;
  final int dailyReward;
  final int weeklyReward;
  final double dailyProgress; // 0..1
  final double weeklyProgress; // 0..1
  final int completedDays;
  final int totalDays;
  final int completedWeeks;
  final int totalWeeks;

  const CompanyMonthlyChallengeOptedInCard({
    super.key,
    this.challengeTitle = 'January Wellness Challenge',
    this.challengeDescription = 'Stay active and healthy throughout the month',
    this.monthlyReward = 5000,
    this.dailyReward = 100,
    this.weeklyReward = 1000,
    this.dailyProgress = 0.6,
    this.weeklyProgress = 0.5,
    this.completedDays = 3,
    this.totalDays = 5,
    this.completedWeeks = 2,
    this.totalWeeks = 4,
  });

  @override
  State<CompanyMonthlyChallengeOptedInCard> createState() =>
      _CompanyMonthlyChallengeOptedInCardState();
}

class _CompanyMonthlyChallengeOptedInCardState
    extends State<CompanyMonthlyChallengeOptedInCard> {
  bool _showRules = true;

  // Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color headerText = Color(0xFF101828);
  static const Color titleText = Color(0xFF0A0A0A);
  static const Color descriptionText = Color(0xFF717182);
  static const Color progressLabel = Color(0xFF4A5565);
  static const Color progressValue = Color(0xFF101828);
  static const Color badgeBackground = Color(0xFFDCFCE7);
  static const Color badgeText = Color(0xFF016630);
  static const Color activeBadgeBackground = Color(0xFFEFF6FF);
  static const Color activeBadgeText = Color(0xFF3B82F6);
  static const Color inactiveBadgeBackground = Color(0xFFF5F5F5);
  static const Color inactiveBadgeText = Color(0xFF737373);
  static const Color progressTrack = Color(0x33171717);
  static const Color progressFill = Color(0xFF22C55E);
  static const Color dividerColor = Color(0x08000000);
  static const Color rulesBackground = Color(0xFFF5F5F5);
  static const Color rulesText = Color(0xFF525252);

  // Text styles - Roboto
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

  TextStyle get _badgeTextStyle => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: badgeText,
  );

  @override
  Widget build(BuildContext context) {
    final dailyPct = widget.dailyProgress.clamp(0.0, 1.0);
    final weeklyPct = widget.weeklyProgress.clamp(0.0, 1.0);

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
          Text('Company Monthly Challenge', style: _headerStyle),
          const SizedBox(height: 24),

          // Challenge info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.challengeTitle,
                      style: _titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildRewardBadge(widget.monthlyReward),
                ],
              ),
              Text(widget.challengeDescription, style: _descriptionStyle),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatusBadge('Active', isActive: true),
                  const SizedBox(width: 4),
                  _buildStatusBadge('Challenge', isActive: false),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
          Container(height: 1, width: double.infinity, color: dividerColor),
          const SizedBox(height: 24),

          _buildProgressSection(
            title: 'Daily Progress',
            reward: widget.dailyReward,
            progressText:
                'This week: ${widget.completedDays}/${widget.totalDays} days',
            percentage: '${(dailyPct * 100).toInt()}%',
            progress: dailyPct,
          ),

          const SizedBox(height: 24),

          _buildProgressSection(
            title: 'Weekly Progress',
            reward: widget.weeklyReward,
            progressText:
                'This month: ${widget.completedWeeks}/${widget.totalWeeks} weeks',
            percentage: '${(weeklyPct * 100).toInt()}%',
            progress: weeklyPct,
          ),

          const SizedBox(height: 24),

          // Rules toggle and list
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: GestureDetector(
                  onTap: () => setState(() => _showRules = !_showRules),
                  child: Text(
                    _showRules
                        ? 'Hide Challenge Rules'
                        : 'Show Challenge Rules',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: const Color(0xFF737373),
                    ),
                  ),
                ),
              ),
              if (_showRules) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: rulesBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRuleItem(
                        'Complete 5 daily challenges to earn weekly completion',
                      ),
                      _buildRuleItem(
                        'Complete 4 weekly challenges to earn monthly completion',
                      ),
                      _buildRuleItem(
                        'Earn Better Flies for each tier completed',
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardBadge(int amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
      decoration: BoxDecoration(
        color: badgeBackground,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text('+${amount.toString()}', style: _badgeTextStyle),
    );
  }

  Widget _buildStatusBadge(String text, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
      decoration: BoxDecoration(
        color: isActive ? activeBadgeBackground : inactiveBadgeBackground,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          color: isActive ? activeBadgeText : inactiveBadgeText,
        ),
      ),
    );
  }

  Widget _buildProgressSection({
    required String title,
    required int reward,
    required String progressText,
    required String percentage,
    required double progress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: _titleStyle),
            _buildRewardBadge(reward),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(progressText, style: _progressLabelStyle),
            Text(percentage, style: _progressValueStyle),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final full = constraints.maxWidth;
              final fill = full * progress.clamp(0.0, 1.0);
              return Stack(
                children: [
                  Container(height: 8, width: full, color: progressTrack),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    height: 8,
                    width: fill,
                    color: progressFill,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: rulesText,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                color: rulesText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
