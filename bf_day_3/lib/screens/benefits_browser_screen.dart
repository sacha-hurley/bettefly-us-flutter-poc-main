import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bubble_ds/bubble_ds.dart';
import '../state/app_state.dart';

class BenefitsBrowserScreen extends StatelessWidget {
  const BenefitsBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = _eligibleBenefits;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eligible Benefits'),
        backgroundColor: BdsColors.backgroundSecondary,
        foregroundColor: BdsColors.onSurfaceText,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 1,
            color: BdsColors.surfaceContainer,
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: Icon(category.icon),
              title: Text(category.title),
              children: [
                for (final item in category.items)
                  ListTile(title: Text(item.name), trailing: Text(item.limit)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () {
            context.read<AppState>().completeBenefitsBrowsing();
            Navigator.pop(context); // Just go back to LSA details
          },
          child: const Text('Mark browsing complete'),
        ),
      ),
    );
  }
}

class BenefitItem {
  const BenefitItem(this.name, this.limit);
  final String name;
  final String limit;
}

class BenefitGroup {
  const BenefitGroup({
    required this.title,
    required this.icon,
    required this.items,
  });
  final String title;
  final IconData icon; // Material Icons
  final List<BenefitItem> items;
}

final List<BenefitGroup> _eligibleBenefits = [
  const BenefitGroup(
    title: 'Wellness & Mental Health',
    icon: Icons.self_improvement,
    items: [
      BenefitItem('Therapy sessions', '4 150 max/session'),
      BenefitItem('Meditation apps', '4 20/month'),
      BenefitItem('Stress management programs', 'Varies'),
    ],
  ),
  const BenefitGroup(
    title: 'Fitness & Physical Health',
    icon: Icons.fitness_center,
    items: [
      BenefitItem('Gym memberships', '4 75/month'),
      BenefitItem('Personal training', '4 100/session'),
      BenefitItem('Massage therapy', '4 125/session'),
    ],
  ),
  const BenefitGroup(
    title: 'Medical & Preventive Care',
    icon: Icons.local_hospital,
    items: [
      BenefitItem('Annual physicals', 'Covered'),
      BenefitItem('Nutrition consultations', '4 80/session'),
      BenefitItem('Vision care', '4 200/year'),
    ],
  ),
  const BenefitGroup(
    title: 'Learning & Development',
    icon: Icons.menu_book,
    items: [
      BenefitItem('Health courses', '4 150/course'),
      BenefitItem('Wellness workshops', '4 50/workshop'),
    ],
  ),
];
