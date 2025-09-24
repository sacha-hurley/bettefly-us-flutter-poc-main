# Implementation PRD: Flutter Health LSA App - Bottom Navigation System

See also: [Notification Policy](NOTIFICATION_POLICY.md)

## 1. Navigation Structure & Components

### Required Flutter Files
```
/lib
├── main.dart (update)
├── navigation/
│   ├── bottom_navigation.dart
│   └── tab_controller.dart
└── screens/
    ├── home_screen.dart (USE EXISTING IF AVAILABLE)
    ├── health_screen.dart (USE EXISTING IF AVAILABLE)
    ├── benefits_screen.dart (USE EXISTING IF AVAILABLE)
    ├── challenges_screen.dart (USE EXISTING IF AVAILABLE)
    └── social_screen.dart (USE EXISTING IF AVAILABLE)
```

### Tab Configuration
```dart
// lib/navigation/tab_controller.dart
enum AppTab {
  home,
  benefits,
  health,
  challenges,
  social,
}

class TabConfig {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget screen;

  const TabConfig({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.screen,
  });
}

// Import existing screens - adjust imports based on what exists
import '../screens/home_screen.dart'; // Use existing if available
// Import other existing screens as needed

final Map<AppTab, TabConfig> tabConfigs = {
  AppTab.home: TabConfig(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    screen: HomeScreen(), // Use existing HomeScreen
  ),
  AppTab.benefits: TabConfig(
    label: 'Benefits',
    icon: Icons.card_giftcard_outlined,
    activeIcon: Icons.card_giftcard,
    screen: BenefitsBrowserScreen(), // Prefer existing concrete screen name
  ),
  AppTab.health: TabConfig(
    label: 'Health',
    icon: Icons.favorite_border,
    activeIcon: Icons.favorite,
    screen: HealthDashboardScreen(), // Prefer existing concrete screen name
  ),
  AppTab.challenges: TabConfig(
    label: 'Challenges',
    icon: Icons.emoji_events_outlined,
    activeIcon: Icons.emoji_events,
    screen: ChallengesScreen(), // Use existing if available, create placeholder if not
  ),
  AppTab.social: TabConfig(
    label: 'Social',
    icon: Icons.people_outline,
    activeIcon: Icons.people,
    screen: SocialScreen(), // Use existing if available, create placeholder if not
  ),
};
```

## 2. Implementation Requirements

### 2.1 Screen Detection & Import Strategy
```dart
// Check existing file structure first, then:

// PRIORITY 1: Use existing screens if they exist
// Look for these patterns in existing codebase:
// - home_screen.dart, home_page.dart, HomePage, HomeView, etc.
// - health_screen.dart, health_page.dart, HealthPage, HealthView, etc.
// - benefits_screen.dart, benefits_page.dart, BenefitsPage, LSAPage, etc.
// - challenges_screen.dart, challenges_page.dart, ChallengesPage, etc.
// - social_screen.dart, social_page.dart, SocialPage, etc.

// PRIORITY 2: Create placeholder ONLY for missing screens
```

### 2.2 Bottom Navigation Widget
```dart
// lib/navigation/bottom_navigation.dart
import 'package:flutter/material.dart';
import 'tab_controller.dart';

class MainBottomNavigation extends StatefulWidget {
  @override
  _MainBottomNavigationState createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: AppTab.values
            .map((tab) => tabConfigs[tab]!.screen)
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Material 3: prefer colorScheme.primary over primaryColor
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: AppTab.values.map((tab) {
          final config = tabConfigs[tab]!;
          return BottomNavigationBarItem(
            icon: Icon(config.icon),
            activeIcon: Icon(config.activeIcon),
            label: config.label,
          );
        }).toList(),
      ),
    );
  }
}
```

### 2.3 Placeholder Screen Template (ONLY for missing screens)
```dart
// Use this template ONLY if a screen doesn't already exist
// Example: lib/screens/health_screen.dart (if not existing)

import 'package:flutter/material.dart';

class [SCREEN_NAME]Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('[TAB_NAME]'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              [APPROPRIATE_ICON],
              size: 64,
              color: [APPROPRIATE_COLOR],
            ),
            SizedBox(height: 16),
            Text(
              '[TAB_NAME]',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              '[DESCRIPTION] will go here',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2.4 Main App Integration
```dart
// lib/main.dart (update existing)
// IMPORTANT: Check if main.dart already has navigation setup
// If it does, modify existing structure rather than replacing

import 'package:flutter/material.dart';
import 'navigation/bottom_navigation.dart';

// Update existing runApp call to use MainBottomNavigation
// or modify existing MaterialApp to use MainBottomNavigation as home

void main() {
  runApp(HealthLSAApp());
}

class HealthLSAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health LSA App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainBottomNavigation(), // Replace existing home if needed
      debugShowCheckedModeBanner: false,
    );
  }
}
```

## 3. Integration Strategy

### 3.1 Existing Screen Detection
```dart
// Before creating any new screens, check for existing:

// Common existing screen patterns to look for:
// - screens/, pages/, views/ folders
// - Files ending in _screen.dart, _page.dart, _view.dart
// - Classes named HomePage, HomeScreen, HomeView, etc.

// Existing routing to preserve:
// - If app already uses named routes, maintain them
// - If app uses Navigator.push patterns, preserve them
// - If app has existing state management, integrate with it
```

### 3.2 Import Resolution
```dart
// Dynamic import strategy in tab_controller.dart:

// Try importing existing screens first:
try {
  import '../screens/home_screen.dart';
  // Use existing HomeScreen
} catch (e) {
  // Create placeholder if not found
}

// Alternative approach - conditional screen creation:
Widget _getScreenForTab(AppTab tab) {
  switch (tab) {
    case AppTab.home:
      // Return existing HomeScreen if available, placeholder if not
      return _getExistingOrPlaceholder('Home', Icons.home, Colors.blue);
    // ... other cases
  }
}
```

### 3.3 Existing Navigation Preservation
```dart
// If app already has navigation:
// - Wrap existing navigation with bottom navigation
// - Preserve existing sub-page navigation
// - Maintain existing route names and parameters
// - Keep existing state management intact
```

## 4. Implementation Commands

### 4.1 Setup Steps
1. FIRST: Scan existing codebase for screen files
2. IDENTIFY: Which screens already exist and their import paths
3. IMPORT: Existing screens into tab configuration
4. CREATE: Placeholder screens ONLY for missing ones
5. INTEGRATE: Bottom navigation with existing app structure
6. PRESERVE: Existing routing and state management
7. TEST: Tab switching with existing screens

### 4.2 Validation Requirements
- All existing screens properly imported and functional
- No duplicate screen files created
- Existing screen functionality preserved
- Only missing screens get placeholder treatment
- Existing navigation patterns maintained
- Home tab uses existing HomeScreen implementation

### 4.3 Conditional Implementation
```dart
// Implementation priority:
// 1. Use existing HomeScreen (required - mentioned as existing)
// 2. Use existing Health/Benefits/Challenges screens if available
// 3. Create minimal placeholders only for missing screens
// 4. Maintain all existing functionality and routing
// 5. Add bottom navigation as enhancement, not replacement
```

This PRD ensures cursor will utilize existing screens rather than creating redundant implementations while providing a clean bottom navigation structure for the app.
