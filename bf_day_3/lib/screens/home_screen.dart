import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';
// import 'package:provider/provider.dart';
// import '../state/app_state.dart';
// import '../widgets/main_todo_card.dart';
import '../widgets/onboarding_todo_card.dart';
// import '../widgets/snapshot_card.dart';
// import '../widgets/progress_counter.dart'; // removed: progress moved into MainTodoCard
// import '../navigation/bottom_navigation.dart';
// import '../widgets/benefit_summary_card.dart';
// import '../widgets/home_shortcuts_section.dart';
import '../widgets/homepage_metric_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  // Navigation via TabSwitchNotification is used elsewhere on demand

  @override
  Widget build(BuildContext context) {
    // final app = context.watch<AppState>(); // kept for future top content

    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Hello, Christina', style: BdsTextStyle.displayMedium()),
          const SizedBox(height: 16),
          Text(
            'Your tasks and progress at a glance.',
            style: BdsTextStyle.bodyLarge(
              color: BdsColors.onSurfaceTextVariant,
            ),
          ),
          const SizedBox(height: 24),
          // ProgressCounter removed per design; progress now appears inside the card
          const OnboardingTodoCard(),
          const SizedBox(height: 32),
          Text(
            'Shortcuts',
            style: BdsTextStyle.displaySmall().copyWith(
              fontSize: (BdsTextStyle.displaySmall().fontSize ?? 24) - 4,
            ),
          ),
          const SizedBox(height: 16),
          // Shortcuts content removed per spec; show metric cards directly below
          const HomepageMetricCards(),
        ],
      ),
    );
  }
}
