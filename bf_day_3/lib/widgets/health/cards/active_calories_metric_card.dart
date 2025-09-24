import 'package:flutter/material.dart';
import '../detailed_metric_card.dart';
import '../metric_chart.dart';

class ActiveCaloriesMetricCard extends StatelessWidget {
  const ActiveCaloriesMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    const theme = Color(0xFFF97316);
    return const HealthMetricCardBase(
      themeColor: theme,
      pillBgColor: Color.fromRGBO(249, 115, 22, 0.08),
      icon: Icons.local_fire_department,
      title: 'Active Calories',
      subtitle: 'Today',
      valueText: '284',
      unitText: 'cal',
      contextText: 'Goal: 400 cal',
      trailingVisualization: ProgressRing(
        targetPercent: 0.78,
        gradientColors: [Color(0xFFFECBA1), Color(0xFFF97316)],
      ),
    );
  }
}


