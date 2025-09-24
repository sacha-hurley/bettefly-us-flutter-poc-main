import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble_ds/bubble_ds.dart';
import '../state/app_state.dart';

class CompanyChallengeDetailScreen extends StatelessWidget {
  const CompanyChallengeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final canComplete = app.joinChallenge && !app.completeChallenge;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Challenge'),
        backgroundColor: BdsColors.backgroundSecondary,
        foregroundColor: BdsColors.onSurfaceText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today: ${app.currentSteps}/${app.dailyGoal} steps',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: BdsColors.onSurfaceText),
            ),
            const SizedBox(height: 8),
            Text(
              'Company Goal: ${app.companyGoal} steps',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: BdsColors.onSurfaceText),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canComplete
                    ? () {
                        context.read<AppState>().completeFirstChallenge();
                        Navigator.pop(context); // Go back to challenges screen
                      }
                    : null,
                child: Text(
                  app.completeChallenge
                      ? 'Completed'
                      : 'Complete first daily challenge (+50 coins)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
