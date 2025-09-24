import 'package:flutter/material.dart';

class ButtonsShowcase extends StatelessWidget {
  const ButtonsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Elevated Buttons',
            [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Enabled'),
              ),
              const SizedBox(width: 12),
              const ElevatedButton(
                onPressed: null,
                child: Text('Disabled'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('With Icon'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Filled Buttons',
            [
              FilledButton(
                onPressed: () {},
                child: const Text('Enabled'),
              ),
              const SizedBox(width: 12),
              const FilledButton(
                onPressed: null,
                child: Text('Disabled'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('With Icon'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Filled Tonal Buttons',
            [
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('Enabled'),
              ),
              const SizedBox(width: 12),
              const FilledButton.tonal(
                onPressed: null,
                child: Text('Disabled'),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('With Icon'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Outlined Buttons',
            [
              OutlinedButton(
                onPressed: () {},
                child: const Text('Enabled'),
              ),
              const SizedBox(width: 12),
              const OutlinedButton(
                onPressed: null,
                child: Text('Disabled'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('With Icon'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Text Buttons',
            [
              TextButton(
                onPressed: () {},
                child: const Text('Enabled'),
              ),
              const SizedBox(width: 12),
              const TextButton(
                onPressed: null,
                child: Text('Disabled'),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('With Icon'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Icon Buttons',
            [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.favorite),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.bookmark),
              ),
              const SizedBox(width: 12),
              IconButton.outlined(
                onPressed: () {},
                icon: const Icon(Icons.share),
              ),
            ],
          ),
          _buildSection(
            context,
            'Floating Action Buttons',
            [
              FloatingActionButton.small(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 12),
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Extended'),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.large(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}