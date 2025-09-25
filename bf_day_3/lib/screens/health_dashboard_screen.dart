import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';
// Base/Charts are imported by concrete card files
import 'package:bf_day_3/widgets/health/cards/steps_metric_card.dart';
import 'package:bf_day_3/widgets/health/cards/heart_rate_metric_card.dart';
import 'package:bf_day_3/widgets/health/cards/active_calories_metric_card.dart';
// import 'package:bf_day_3/services/health_service.dart';
import 'package:bf_day_3/widgets/secondary_todo_card.dart';

class HealthDashboardScreen extends StatefulWidget {
  const HealthDashboardScreen({super.key});

  @override
  State<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends State<HealthDashboardScreen> {
  // Placeholder mode: simulate connecting, then show static demo values.
  bool _isLoading = true;
  bool _authorized = true;

  @override
  void initState() {
    super.initState();
    _simulateConnect();
  }

  Future<void> _simulateConnect() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _authorized = true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Health', style: BdsTextStyle.displayMedium()),
              const SizedBox(height: 16),
              Text(
                'Your daily health insights and trends at a glance.',
                style: BdsTextStyle.bodyLarge(
                  color: BdsColors.onSurfaceTextVariant,
                ),
              ),
              const SizedBox(height: 24),
              // Secondary To-dos card: under header and above steps
              const SecondaryTodoCard(
                todoIds: ['dashboard'],
                pageContext: 'health',
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (!_authorized)
                _PermissionDenied(onRetry: _simulateConnect)
              else ...[
                const StepsMetricCard(),
                const HeartRateMetricCard(),
                const ActiveCaloriesMetricCard(),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionDenied extends StatelessWidget {
  final VoidCallback onRetry;
  const _PermissionDenied({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enable Health Access',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'To see your health data, please allow access to Apple Health in Settings.',
          style: BdsTextStyle.bodyLarge(color: BdsColors.onSurfaceTextVariant),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: onRetry,
          child: const Text('Retry Permissions'),
        ),
      ],
    );
  }
}
