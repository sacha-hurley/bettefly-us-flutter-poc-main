/// Simple model for a health metric summary.
class HealthMetricSummary {
  HealthMetricSummary({
    required this.title,
    required this.value,
    required this.unit,
  });

  final String title;
  final String value; // values as strings for UI binding simplicity
  final String unit;
}
