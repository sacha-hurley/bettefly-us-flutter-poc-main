import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum LeaderboardSortType { lifetime, challenges, totalSteps }

class LeaderboardUser {
  final String name;
  final String initials;
  final int rank;
  final int lifetimeFlies;
  final int challengesCompleted;
  final int totalSteps;

  const LeaderboardUser({
    required this.name,
    required this.initials,
    required this.rank,
    required this.lifetimeFlies,
    required this.challengesCompleted,
    required this.totalSteps,
  });
}

class LeaderboardCard extends StatelessWidget {
  final List<LeaderboardUser> users;
  final LeaderboardSortType activeSortType;
  final void Function(LeaderboardSortType) onSortChanged;
  final VoidCallback onLoadMore;

  const LeaderboardCard({
    super.key,
    required this.users,
    this.activeSortType = LeaderboardSortType.lifetime,
    required this.onSortChanged,
    required this.onLoadMore,
  });

  // Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color primaryGreen = Color(0xFF0F1C14);
  static const Color lightGreen = Color(0xFFDCFCE7);
  static const Color darkGreen = Color(0xFF016630);
  static const Color headerText = Color(0xFF101828);
  static const Color bodyText = Color(0xFF0A0A0A);
  static const Color grayText = Color(0xFF717182);
  static const Color avatarBackground = Color(0xFFECECF0);
  static const Color dividerColor = Color(0x1A000000); // 10% black

  // Dimensions
  static const double cardRadius = 32.0;
  static const double chipHeight = 40.0;
  static const double chipRadius = 20.0;
  static const double chipGap = 8.0;
  static const double itemVPad = 12.0;
  static const double sectionGap = 24.0;
  static const double cardPadding = 24.0;
  static const double maxCardWidth = 384.0;

  TextStyle get _headerStyle => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
    color: headerText,
  );

  TextStyle get _chipActiveText => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Colors.white,
  );

  TextStyle get _chipInactiveText => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: primaryGreen,
  );

  TextStyle get _nameStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 24 / 14,
    color: bodyText,
  );

  TextStyle get _statsStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: grayText,
  );

  TextStyle get _scoreStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: primaryGreen,
  );

  @override
  Widget build(BuildContext context) {
    // Maintain uniform 16px page margins and max width 384, responsive.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxCardWidth),
          child: _buildCard(context),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: cardBorder, width: 1),
      ),
      padding: const EdgeInsets.all(cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Leaderboard', style: _headerStyle),
          const SizedBox(height: sectionGap),
          _buildFilterChips(),
          const SizedBox(height: 16),
          _buildList(),
          const SizedBox(height: 16),
          _buildLoadMoreButton(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    // Force three equal-width chips; no horizontal scroll
    final List<_ChipSpec> chips = [
      _ChipSpec('Lifetime', LeaderboardSortType.lifetime),
      _ChipSpec('Challenges', LeaderboardSortType.challenges),
      _ChipSpec('Steps', LeaderboardSortType.totalSteps),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          for (int i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: chipGap),
            Expanded(child: _buildChip(chips[i])),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(_ChipSpec spec) {
    final bool isActive = activeSortType == spec.type;
    final EdgeInsets padding = isActive
        ? const EdgeInsets.fromLTRB(12, 4, 8, 4)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 4);

    Widget label = Text(
      spec.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: isActive ? _chipActiveText : _chipInactiveText,
    );

    if (isActive) {
      label = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 24, color: Colors.white),
          const SizedBox(width: 4),
          Flexible(child: label),
        ],
      );
    }

    final child = Container(
      constraints: const BoxConstraints(minHeight: chipHeight),
      height: chipHeight,
      decoration: BoxDecoration(
        color: isActive ? primaryGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(chipRadius),
        border: isActive ? null : Border.all(color: primaryGreen, width: 1),
      ),
      padding: padding,
      child: Center(child: label),
    );

    return Semantics(
      button: true,
      selected: isActive,
      label: '${spec.label} filter',
      child: InkWell(
        borderRadius: BorderRadius.circular(chipRadius),
        onTap: () => onSortChanged(spec.type),
        child: child,
      ),
    );
  }

  Widget _buildList() {
    final NumberFormat numFmt = NumberFormat.decimalPattern();
    final List<LeaderboardUser> visible = users; // show all provided users
    return Column(
      children: [
        for (int i = 0; i < visible.length; i++) ...[
          _buildItem(visible[i], numFmt, i + 1),
          const SizedBox(height: 4),
          if (i != visible.length - 1)
            const Divider(height: 1, color: dividerColor),
          if (i != visible.length - 1) const SizedBox(height: 4),
        ],
      ],
    );
  }

  Widget _buildItem(LeaderboardUser u, NumberFormat numFmt, int rank) {
    String rightText;
    String statLine1;
    String statLine2;
    switch (activeSortType) {
      case LeaderboardSortType.lifetime:
        rightText = '${numFmt.format(u.lifetimeFlies)} flies';
        statLine1 = '${numFmt.format(u.challengesCompleted)} challenges';
        statLine2 = '${numFmt.format(u.totalSteps)} steps';
        break;
      case LeaderboardSortType.challenges:
        rightText = '${numFmt.format(u.challengesCompleted)} challenges';
        statLine1 = '${numFmt.format(u.lifetimeFlies)} flies';
        statLine2 = '${numFmt.format(u.totalSteps)} steps';
        break;
      case LeaderboardSortType.totalSteps:
        rightText = '${numFmt.format(u.totalSteps)} steps';
        statLine1 = '${numFmt.format(u.lifetimeFlies)} flies';
        statLine2 = '${numFmt.format(u.challengesCompleted)} challenges';
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: itemVPad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRankBadge(rank),
          const SizedBox(width: 8),
          _buildAvatar(u.initials),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  u.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _nameStyle,
                ),
                const SizedBox(height: 2),
                Text(
                  statLine1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _statsStyle,
                ),
                Text(
                  statLine2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _statsStyle,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 124,
            child: Text(
              rightText,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _scoreStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    return Container(
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      child: Text(
        '$rank',
        style: GoogleFonts.roboto(
          // Approximating SF Pro Text Medium at 12 on non-iOS with Roboto Medium
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          color: darkGreen,
        ),
      ),
    );
  }

  Widget _buildAvatar(String initials) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: avatarBackground,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: bodyText,
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
        ),
        onPressed: onLoadMore,
        child: Text(
          'Load more',
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: primaryGreen,
          ),
        ),
      ),
    );
  }
}

class _ChipSpec {
  final String label;
  final LeaderboardSortType type;
  const _ChipSpec(this.label, this.type);
}
