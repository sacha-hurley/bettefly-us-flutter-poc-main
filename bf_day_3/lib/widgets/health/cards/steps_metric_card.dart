import 'package:flutter/material.dart';
import '../detailed_metric_card.dart';
import '../metric_chart.dart';

class StepsMetricCard extends StatelessWidget {
  const StepsMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    const theme = Color(0xFF0EA5E9);
    return HealthMetricCardBase(
      themeColor: theme,
      pillBgColor: const Color.fromRGBO(14, 165, 233, 0.08),
      icon: Icons.directions_walk,
      title: 'Steps',
      subtitle: 'Today',
      valueText: '7,842',
      unitText: 'steps',
      contextText: 'Goal: 10,000 steps',
      trailingVisualization: const ProgressRing(
        targetPercent: 0.78,
        gradientColors: [Color(0xFF7DD3FC), Color(0xFF0EA5E9)],
      ),
      onSeeDetails: () {
        // Navigate to the steps detail page
        // Using the current context to push the /steps route
        Navigator.of(context).pushNamed('/steps');
      },
    );
  }
}
