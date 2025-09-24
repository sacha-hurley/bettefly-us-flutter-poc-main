import 'package:flutter/material.dart';

/// Social screen for community features and social interactions
/// This screen will contain social features like posts, connections, and community activities
class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removed - now using top navigation from MainBottomNavigation
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Using Material Icons for consistency with existing codebase
              Icon(
                Icons.people_outline,
                size: 64,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 16),

              Text('Social', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),

              Text(
                'Connect with your community and share your wellness journey',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Placeholder content using Material components
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Community Features',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Share achievements, connect with colleagues, and participate in community challenges.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
