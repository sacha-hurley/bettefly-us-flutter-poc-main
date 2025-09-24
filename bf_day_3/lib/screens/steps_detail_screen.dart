import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/health/details_card.dart';
import '../widgets/overview_card.dart';
import '../widgets/chip_navigation_bar.dart';
import '../state/app_state.dart';

/// Steps Detail Screen showing detailed metrics
/// This screen displays when user taps "See Details" on the StepsMetricCard
class StepsDetailScreen extends StatefulWidget {
  const StepsDetailScreen({super.key});

  @override
  State<StepsDetailScreen> createState() => _StepsDetailScreenState();
}

class _StepsDetailScreenState extends State<StepsDetailScreen> {
  int _selectedTimePeriod = 0; // 0: Today, 1: Week, 2: Month
  final List<String> _timePeriods = ['Today', 'Week', 'Month'];

  void _onTimePeriodChanged(int index) {
    setState(() {
      _selectedTimePeriod = index;
    });
    // TODO: Update data based on selected time period
    // This could trigger API calls or filter local data
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      body: Column(
        children: [
          // Chip navigation bar at the top - flush to edges
          ChipNavigationBar(
            labels: _timePeriods,
            selectedIndex: _selectedTimePeriod,
            onSelectionChanged: _onTimePeriodChanged,
          ),

          // Content with proper horizontal padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 16),

                  // Overview card showing step progress
                  OverviewCard(
                    currentSteps: app.currentSteps,
                    totalSteps: app.dailyGoal,
                  ),

                  const SizedBox(height: 16),

                  // Details card matching Figma design
                  const DetailsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
