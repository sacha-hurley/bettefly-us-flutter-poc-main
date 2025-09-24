import 'package:flutter/material.dart';
import '../detailed_metric_card.dart';
import '../metric_chart.dart';

class HeartRateMetricCard extends StatelessWidget {
  const HeartRateMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    const theme = Color(0xFFEF4444);
    return const HealthMetricCardBase(
      themeColor: theme,
      pillBgColor: Color.fromRGBO(239, 68, 68, 0.08),
      icon: Icons.favorite,
      title: 'Heart Rate',
      subtitle: 'Today',
      valueText: '72',
      unitText: 'bpm',
      contextText: 'Avg: 78 bpm   Highest: 85 bpm',
      trailingVisualization: HeartRateLineChart(),
    );
  }
}


