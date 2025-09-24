import 'package:flutter/material.dart';
import '../models/hourly_steps_data.dart';
import 'steps_bar_chart.dart';

/// A responsive Flutter widget that displays step progress overview
/// matching the exact Figma design specifications.
///
/// This widget shows:
/// - Overview header
/// - Current steps vs total steps
/// - Progress bar with calculated percentage
/// - Percentage text display
/// - Chart placeholder
class OverviewCard extends StatelessWidget {
  /// Current number of steps completed
  final int currentSteps;

  /// Total number of steps goal
  final int totalSteps;

  const OverviewCard({
    super.key,
    required this.currentSteps,
    required this.totalSteps,
  }) : assert(currentSteps >= 0, 'Current steps must be non-negative'),
       assert(totalSteps > 0, 'Total steps must be positive');

  /// Calculate the progress percentage (0.0 to 1.0)
  double get _progressPercentage {
    return (currentSteps / totalSteps).clamp(0.0, 1.0);
  }

  /// Format the percentage for display (e.g., "72.3%")
  String get _formattedPercentage {
    return '${(_progressPercentage * 100).toStringAsFixed(1)}%';
  }

  /// Format the steps display (e.g., "7,233 of 10,000")
  String get _formattedSteps {
    return '${_formatNumber(currentSteps)} of ${_formatNumber(totalSteps)}';
  }

  /// Format large numbers with commas
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  /// Generate sample hourly steps data for demonstration
  /// In a real app, this would come from a health service or API
  List<HourlyStepsData> _generateSampleData() {
    // Sample data representing steps taken throughout the day
    // This simulates someone who started walking around 9 AM
    final Map<int, int> stepsByHour = {
      9: 150, // 9 AM - Morning walk
      10: 320, // 10 AM - Commute
      11: 180, // 11 AM - Office movement
      12: 250, // 12 PM - Lunch break
      13: 120, // 1 PM - Back to office
      14: 90, // 2 PM - Office work
      15: 200, // 3 PM - Coffee break
      16: 160, // 4 PM - Office work
      17: 400, // 5 PM - Commute home
      18: 280, // 6 PM - Evening activities
      19: 350, // 7 PM - Dinner prep
      20: 180, // 8 PM - Evening walk
    };

    return HourlyStepsData.fromStepsMap(stepsByHour);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Light gray border
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Overview"
          Text(
            'Overview',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w500, // Medium weight
              color: Color(0xFF101828), // Dark gray
              height: 1.56, // 28px line height for 18px font
            ),
          ),

          const SizedBox(height: 24),

          // Progress section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with "Total Steps" and step count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Steps',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400, // Regular weight
                      color: Color(0xFF4A5565), // Medium gray
                      height: 1.43, // 20px line height for 14px font
                    ),
                  ),
                  Text(
                    _formattedSteps,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500, // Medium weight
                      color: Color(0xFF101828), // Dark gray
                      height: 1.43, // 20px line height for 14px font
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Progress bar
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB), // Light gray background
                  borderRadius: BorderRadius.circular(100), // Fully rounded
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6), // Blue fill
                      borderRadius: BorderRadius.circular(100), // Fully rounded
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Percentage text
              Text(
                _formattedPercentage,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w400, // Regular weight
                  color: Color(0xFF717182), // Light gray
                  height: 1.33, // 16px line height for 12px font
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Steps bar chart
          StepsBarChart(
            hourlyData: _generateSampleData(),
            height: 145,
            animate: true,
          ),
        ],
      ),
    );
  }
}
