import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialPageTabNav extends StatefulWidget {
  final void Function(int) onTabChanged;
  final int activeTab; // 0 for Leaderboard, 1 for Challenges
  final VoidCallback onFriendIconTap;
  final bool useFigmaEdgePadding; // if true, applies 57/70/58/24 outer padding
  final double bottomPadding; // controls bottom spacing under the tab nav

  const SocialPageTabNav({
    super.key,
    required this.onTabChanged,
    this.activeTab = 0,
    required this.onFriendIconTap,
    this.useFigmaEdgePadding = false,
    this.bottomPadding = 24.0,
  });

  @override
  State<SocialPageTabNav> createState() => _SocialPageTabNavState();
}

class _SocialPageTabNavState extends State<SocialPageTabNav> {
  static const Color primaryGreen = Color(0xFF0F1C14);
  static const Color white = Colors.white;

  static const double tabHeight = 40.0;
  static const double tapTargetMin = 44.0; // accessibility target
  static const double tabBorderRadius = 32.0;
  static const double horizontalPadding = 32.0;
  static const double iconSize = 36.0;
  static const double innerIconSize = 16.0;
  static const double gap = 8.0;

  TextStyle get _tabTextStyle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    final EdgeInsets outerPadding = widget.useFigmaEdgePadding
        ? EdgeInsets.fromLTRB(57, 70, 58, widget.bottomPadding)
        : EdgeInsets.fromLTRB(16, 0, 16, widget.bottomPadding);

    return Material(
      color: white,
      child: Padding(
        padding: outerPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _buildTab(label: 'Leaderboard', index: 0)),
            const SizedBox(width: gap),
            Expanded(child: _buildTab(label: 'Challenges', index: 1)),
            const SizedBox(width: gap),
            _buildFriendIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({required String label, required int index}) {
    final bool isActive = widget.activeTab == index;
    return Semantics(
      button: true,
      selected: isActive,
      label: '$label tab',
      child: SizedBox(
        height: tapTargetMin, // ensure 44px minimum target while visual is 40
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: tabHeight,
            decoration: BoxDecoration(
              color: isActive ? primaryGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(tabBorderRadius),
              border: isActive
                  ? null
                  : Border.all(color: primaryGreen, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(tabBorderRadius),
              onTap: () => widget.onTabChanged(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Center(
                  child: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: _tabTextStyle.copyWith(
                      color: isActive ? white : primaryGreen,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendIcon() {
    return Semantics(
      label: 'Add friend',
      button: true,
      child: SizedBox(
        width: iconSize,
        height: tapTargetMin, // maintain larger tap area; visual remains 36
        child: Center(
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onFriendIconTap,
            child: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.04), // light/transparent bg
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person_add_alt,
                  size: innerIconSize,
                  color: primaryGreen,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
