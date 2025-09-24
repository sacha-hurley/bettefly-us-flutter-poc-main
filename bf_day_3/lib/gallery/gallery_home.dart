import 'package:flutter/material.dart';
import 'buttons_showcase.dart';
import 'cards_showcase.dart';
import 'inputs_showcase.dart';
import 'navigation_showcase.dart';
import 'dialogs_showcase.dart';
import 'chips_showcase.dart';

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Gallery'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryCard(
            context,
            'Buttons',
            'Elevated, Filled, Outlined, Text, and Icon buttons',
            Icons.smart_button,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ButtonsShowcase()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            'Cards',
            'Card variations with different elevations and styles',
            Icons.credit_card,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CardsShowcase()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            'Input Fields',
            'Text fields, dropdowns, and form inputs',
            Icons.input,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InputsShowcase()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            'Navigation',
            'Navigation bars, rails, and drawers',
            Icons.navigation,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NavigationShowcase()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            'Dialogs & Sheets',
            'Dialogs, bottom sheets, and snackbars',
            Icons.chat_bubble,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DialogsShowcase()),
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryCard(
            context,
            'Chips',
            'Input, filter, choice, and action chips',
            Icons.label,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChipsShowcase()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}