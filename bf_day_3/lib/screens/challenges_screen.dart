import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble_ds/bubble_ds.dart';
import '../state/app_state.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      // AppBar removed - now using top navigation from MainBottomNavigation
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Social', style: BdsTextStyle.displayMedium()),
            const SizedBox(height: 16),
            Text(
              'Stay connected with your community and recent activity.',
              style: BdsTextStyle.bodyLarge(
                color: BdsColors.onSurfaceTextVariant,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),
            Text(
              app.hasJoinedCompany
                  ? 'You have joined the company challenge.'
                  : 'Join the company challenge to start earning coins.',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: BdsColors.onSurfaceText),
            ),
            const SizedBox(height: 16),
            if (!app.hasJoinedCompany)
              FilledButton(
                onPressed: () {
                  context.read<AppState>().joinCompanyChallenge();
                  // Stay on current screen - user can navigate to company details manually
                },
                child: const Text('Join company challenge (+25 coins)'),
              )
            else
              FilledButton.tonal(
                onPressed: () => Navigator.pushNamed(context, '/company'),
                child: const Text('View company challenge progress'),
              ),
          ],
        ),
      ),
    );
  }
}
