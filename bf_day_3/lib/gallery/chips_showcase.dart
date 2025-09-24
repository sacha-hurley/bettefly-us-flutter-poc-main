import 'package:flutter/material.dart';

class ChipsShowcase extends StatefulWidget {
  const ChipsShowcase({super.key});

  @override
  State<ChipsShowcase> createState() => _ChipsShowcaseState();
}

class _ChipsShowcaseState extends State<ChipsShowcase> {
  final Set<String> _selectedFilters = {'Filter 1'};
  final Set<String> _selectedChoices = {'Choice 1'};
  final List<String> _inputChips = ['Chip 1', 'Chip 2', 'Chip 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chips'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Action Chips',
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.favorite),
                  label: const Text('Favorite'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Favorite action')),
                    );
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.share),
                  label: const Text('Share'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share action')),
                    );
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.bookmark),
                  label: const Text('Bookmark'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bookmark action')),
                    );
                  },
                ),
                const ActionChip(
                  avatar: Icon(Icons.block),
                  label: Text('Disabled'),
                  onPressed: null,
                ),
              ],
            ),
          ),
          _buildSection(
            context,
            'Filter Chips',
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Filter 1'),
                  selected: _selectedFilters.contains('Filter 1'),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add('Filter 1');
                      } else {
                        _selectedFilters.remove('Filter 1');
                      }
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Filter 2'),
                  selected: _selectedFilters.contains('Filter 2'),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add('Filter 2');
                      } else {
                        _selectedFilters.remove('Filter 2');
                      }
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Filter 3'),
                  selected: _selectedFilters.contains('Filter 3'),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add('Filter 3');
                      } else {
                        _selectedFilters.remove('Filter 3');
                      }
                    });
                  },
                ),
                FilterChip(
                  avatar: const Icon(Icons.category),
                  label: const Text('With Icon'),
                  selected: _selectedFilters.contains('With Icon'),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add('With Icon');
                      } else {
                        _selectedFilters.remove('With Icon');
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          _buildSection(
            context,
            'Choice Chips',
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Choice 1'),
                  selected: _selectedChoices.contains('Choice 1'),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChoices.clear();
                      if (selected) {
                        _selectedChoices.add('Choice 1');
                      }
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Choice 2'),
                  selected: _selectedChoices.contains('Choice 2'),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChoices.clear();
                      if (selected) {
                        _selectedChoices.add('Choice 2');
                      }
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Choice 3'),
                  selected: _selectedChoices.contains('Choice 3'),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChoices.clear();
                      if (selected) {
                        _selectedChoices.add('Choice 3');
                      }
                    });
                  },
                ),
                ChoiceChip(
                  avatar: const Icon(Icons.star),
                  label: const Text('Premium'),
                  selected: _selectedChoices.contains('Premium'),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedChoices.clear();
                      if (selected) {
                        _selectedChoices.add('Premium');
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          _buildSection(
            context,
            'Input Chips',
            Wrap(
              spacing: 8,
              children: _inputChips.map((String chip) {
                return InputChip(
                  label: Text(chip),
                  onDeleted: () {
                    setState(() {
                      _inputChips.remove(chip);
                    });
                  },
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$chip pressed')),
                    );
                  },
                );
              }).toList()
                ..add(
                  InputChip(
                    avatar: const Icon(Icons.add),
                    label: const Text('Add new'),
                    onPressed: () {
                      setState(() {
                        _inputChips.add('Chip ${_inputChips.length + 1}');
                      });
                    },
                  ),
                ),
            ),
          ),
          _buildSection(
            context,
            'Suggestion Chips',
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Suggestion 1'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Suggestion 1 selected')),
                    );
                  },
                ),
                ActionChip(
                  label: const Text('Suggestion 2'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Suggestion 2 selected')),
                    );
                  },
                ),
                ActionChip(
                  label: const Text('Suggestion 3'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Suggestion 3 selected')),
                    );
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.lightbulb),
                  label: const Text('Pro tip'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pro tip selected')),
                    );
                  },
                ),
              ],
            ),
          ),
          _buildSection(
            context,
            'Assist Chips',
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  label: const Text('Assist Chip'),
                ),
                const Chip(
                  avatar: Icon(Icons.account_circle),
                  label: Text('User Chip'),
                ),
                Chip(
                  avatar: const Icon(Icons.location_on),
                  label: const Text('Location'),
                  deleteIcon: const Icon(Icons.clear),
                  onDeleted: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
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
            child: content,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}