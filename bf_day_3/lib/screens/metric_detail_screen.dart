import 'package:flutter/material.dart';

/// Metric Detail (MVP) shell screen.
///
/// Displays a simple scaffold; metric-specific content will be added later.
class MetricDetailScreen extends StatelessWidget {
  final String metricTitle;

  const MetricDetailScreen({super.key, required this.metricTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(metricTitle)),
      body: const Center(child: Text('Metric Detail – MVP Placeholder')),
    );
  }
}


