/// Data model for representing hourly steps data
/// This model helps structure step data by hour for the bar chart
class HourlyStepsData {
  /// The hour in 24-hour format (0-23)
  final int hour;

  /// Number of steps taken in this hour
  final int steps;

  /// Display label for the hour (e.g., "10 AM", "2 PM")
  final String label;

  const HourlyStepsData({
    required this.hour,
    required this.steps,
    required this.label,
  });

  /// Create a list of hourly steps data from a map of hour -> steps
  /// Only includes hours where steps > 0 (active hours)
  static List<HourlyStepsData> fromStepsMap(Map<int, int> stepsByHour) {
    final List<HourlyStepsData> data = [];

    // Sort by hour to ensure proper order
    final sortedHours = stepsByHour.keys.toList()..sort();

    for (final hour in sortedHours) {
      final steps = stepsByHour[hour] ?? 0;
      if (steps > 0) {
        // Only include hours with steps
        data.add(
          HourlyStepsData(
            hour: hour,
            steps: steps,
            label: _formatHourLabel(hour),
          ),
        );
      }
    }

    return data;
  }

  /// Format hour number into readable label
  /// Examples: 9 -> "9 AM", 14 -> "2 PM", 0 -> "12 AM"
  static String _formatHourLabel(int hour) {
    if (hour == 0) return "12 AM";
    if (hour < 12) return "$hour AM";
    if (hour == 12) return "12 PM";
    return "${hour - 12} PM";
  }

  /// Get the maximum steps from a list of hourly data
  static int getMaxSteps(List<HourlyStepsData> data) {
    if (data.isEmpty) return 0;
    return data.map((d) => d.steps).reduce((a, b) => a > b ? a : b);
  }

  /// Get the total steps from a list of hourly data
  static int getTotalSteps(List<HourlyStepsData> data) {
    return data.fold(0, (sum, d) => sum + d.steps);
  }
}
