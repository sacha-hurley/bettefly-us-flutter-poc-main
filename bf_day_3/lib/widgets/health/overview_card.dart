import 'package:flutter/material.dart';

/// A responsive widget that displays an overview card with progress tracking
/// for health metrics like steps, with an auto-calculated progress percentage.
class OverviewCard extends StatelessWidget {
  /// Current number of steps achieved
  final int currentSteps;

  /// Total number of steps to achieve
  final int totalSteps;

  const OverviewCard({
    super.key,
    required this.currentSteps,
    required this.totalSteps,
  }) : assert(currentSteps >= 0, 'Current steps must be non-negative'),
       assert(totalSteps > 0, 'Total steps must be positive'),
       assert(
         currentSteps <= totalSteps,
         'Current steps cannot exceed total steps',
       );

  /// Calculates the progress percentage from current and total steps
  double get _progressPercentage {
    return totalSteps > 0 ? (currentSteps / totalSteps) * 100 : 0.0;
  }

  /// Formats the progress percentage to one decimal place
  String get _formattedPercentage {
    return '${_progressPercentage.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Makes it responsive with fluid width
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Light gray border
          width: 1,
        ),
        // No elevation or shadow as specified
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Text(
            'Overview',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500, // Medium weight
              color: Color(0xFF101828),
              fontFamily: 'Roboto',
            ),
          ),

          const SizedBox(height: 24), // 24px gap below header
          // Progress section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Steps row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Steps',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A5565),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    '$currentSteps of $totalSteps',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500, // Medium weight
                      color: Color(0xFF101828),
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8), // 8px gap
              // Progress bar
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB), // Light gray background
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressPercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6), // Blue fill
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8), // 8px gap
              // Percentage text
              Text(
                _formattedPercentage,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF717182),
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10), // 10px gap below progress
          // Chart placeholder
          Container(
            height: 145,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9), // Gray placeholder
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ],
      ),
    );
  }
}
