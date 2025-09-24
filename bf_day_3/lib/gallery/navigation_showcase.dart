import 'package:flutter/material.dart';

class NavigationShowcase extends StatefulWidget {
  const NavigationShowcase({super.key});

  @override
  State<NavigationShowcase> createState() => _NavigationShowcaseState();
}

class _NavigationShowcaseState extends State<NavigationShowcase> {
  int _selectedIndex = 0;
  int _railIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Navigation Bar',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  height: 300,
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: Text(
                      'Page ${_selectedIndex + 1}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.search_outlined),
                      selectedIcon: Icon(Icons.search),
                      label: 'Search',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_outline),
                      selectedIcon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Navigation Rail',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 400,
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _railIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _railIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    leading: FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.add),
                    ),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.search_outlined),
                        selectedIcon: Icon(Icons.search),
                        label: Text('Search'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite_outline),
                        selectedIcon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Profile'),
                      ),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Page ${_railIndex + 1}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'App Bar',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                AppBar(
                  title: const Text('Standard App Bar'),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(
                    child: Text('Content'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                AppBar(
                  title: const Text('Center Title'),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                Container(
                  height: 100,
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(
                    child: Text('Content'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Tab Bar',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  AppBar(
                    title: const Text('Tabs'),
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'Tab 1'),
                        Tab(text: 'Tab 2'),
                        Tab(text: 'Tab 3'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      children: [
                        Center(child: Text('Tab 1 Content', style: Theme.of(context).textTheme.titleLarge)),
                        Center(child: Text('Tab 2 Content', style: Theme.of(context).textTheme.titleLarge)),
                        Center(child: Text('Tab 3 Content', style: Theme.of(context).textTheme.titleLarge)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}