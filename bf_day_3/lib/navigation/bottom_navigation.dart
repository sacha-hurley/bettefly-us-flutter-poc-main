import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bubble_ds/bubble_ds.dart';
import 'package:bf_design_system/bf_design_system.dart';
import '../screens/home_screen.dart';
import '../screens/health_dashboard_screen.dart';
import '../screens/steps_detail_screen.dart';
import '../screens/lsa_details_screen.dart';
import '../screens/benefits_browser_screen.dart';
import '../screens/benefits_screen.dart';
import '../screens/challenges_screen.dart';
import '../screens/company_challenge_detail_screen.dart';
import '../services/currency_service.dart';
import '../modals/profile_settings_modal.dart';
import '../modals/buddy_chat_modal.dart';
import '../modals/currency_details_modal.dart';
import '../widgets/animated_currency_graphic.dart';
// import '../debug_top_nav.dart';
import '../widgets/secondary_page_nav_bar.dart';

/// Custom notification for switching tabs from child widgets
class TabSwitchNotification extends Notification {
  const TabSwitchNotification(this.tabIndex);
  final int tabIndex;
}

/// SetSocialSubTabNotification - allows switching to Social tab with a specific sub-tab active
class SetSocialSubTabNotification extends Notification {
  const SetSocialSubTabNotification(this.subTabIndex);
  final int subTabIndex; // 0: Leaderboard, 1: Challenges
}

/// Main bottom navigation using bubble_ds BdsNavbar component
/// Implements persistent 4-tab navigation: Home, Benefits, Health, Social
/// Each tab maintains its own navigation stack for detail screens
class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  // Controller for bubble_ds navbar
  late final BdsNavbarController _navbarController;

  // Observe route changes inside the Benefits tab's nested navigator
  late final RouteObserver<PageRoute<dynamic>> _benefitsRouteObserver;
  String? _benefitsDetailTitle; // dynamic title from route args

  // Observe route changes inside the Health tab's nested navigator
  late final RouteObserver<PageRoute<dynamic>> _healthRouteObserver;
  String? _healthDetailTitle; // dynamic title from route args

  // Optional desired sub-tab for Social page when switching tabs programmatically
  int? _desiredSocialSubTab;

  // Navigation keys for each tab to maintain separate navigation stacks
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Benefits
    GlobalKey<NavigatorState>(), // Health
    GlobalKey<NavigatorState>(), // Social
  ];

  // 4 tab navigators with their own routing
  List<Widget> get _pages => [
    _buildTabNavigator(0, const HomeScreen(showAppBar: false)), // Tab 0: Home
    _buildTabNavigator(
      1,
      const BenefitsScreen(),
    ), // Tab 1: Benefits (list & cards)
    _buildTabNavigator(2, const HealthDashboardScreen()), // Tab 2: Health
    _buildTabNavigator(
      3,
      const ChallengesScreen(),
    ), // Tab 3: Social (start with Challenges)
  ];

  @override
  void initState() {
    super.initState();
    // Initialize navbar controller with Home as default
    _navbarController = BdsNavbarController(currentIndex: 0);
    _benefitsRouteObserver = _DetailRouteObserver(
      onTitleChanged: (title) {
        if (!mounted) return;
        // Defer state update to avoid setState during build/init
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _benefitsDetailTitle = title;
          });
        });
      },
    );
    _healthRouteObserver = _HealthDetailRouteObserver(
      onTitleChanged: (title) {
        if (!mounted) return;
        // Defer state update to avoid setState during build/init
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _healthDetailTitle = title;
          });
        });
      },
    );
  }

  @override
  void dispose() {
    _navbarController.dispose();
    super.dispose();
  }

  /// Build a tab navigator with its own navigation stack
  Widget _buildTabNavigator(int tabIndex, Widget initialScreen) {
    return Navigator(
      key: _navigatorKeys[tabIndex],
      initialRoute: '/',
      onGenerateRoute: (settings) => _generateRoute(settings, tabIndex),
      observers: tabIndex == 1
          ? <NavigatorObserver>[_benefitsRouteObserver]
          : tabIndex == 2
          ? <NavigatorObserver>[_healthRouteObserver]
          : const <NavigatorObserver>[],
    );
  }

  /// Generate routes for each tab's navigator
  Route<dynamic> _generateRoute(RouteSettings settings, int tabIndex) {
    Widget screen;

    switch (tabIndex) {
      case 0: // Home tab
        screen = const HomeScreen(showAppBar: false);
        break;
      case 1: // Benefits tab
        switch (settings.name) {
          case '/':
            screen = const BenefitsScreen();
            break;
          case '/eligible':
            screen = const BenefitsBrowserScreen();
            break;
          case '/lsa':
            // Pass a dynamic title via arguments if provided
            screen = const LSADetailsScreen();
            break;
          default:
            screen = const BenefitsScreen();
        }
        break;
      case 2: // Health tab
        switch (settings.name) {
          case '/':
            screen = const HealthDashboardScreen();
            break;
          case '/steps':
            screen = const StepsDetailScreen();
            break;
          default:
            screen = const HealthDashboardScreen();
        }
        break;
      case 3: // Social tab
        switch (settings.name) {
          case '/':
            final initial = _desiredSocialSubTab ?? 0;
            _desiredSocialSubTab = null; // consume once
            screen = ChallengesScreen(initialTab: initial);
            break;
          case '/challengesTab':
            screen = const ChallengesScreen(initialTab: 1);
            break;
          case '/leaderboardTab':
            screen = const ChallengesScreen(initialTab: 0);
            break;
          case '/company':
            screen = const CompanyChallengeDetailScreen();
            break;
          default:
            screen = const ChallengesScreen();
        }
        break;
      default:
        screen = const HomeScreen(showAppBar: false);
    }

    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }

  /// Handle navigation tab selection
  void _onNavigationChanged(int index) {
    setState(() {
      _navbarController.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we're inside a Benefits detail route by checking if the
    // Benefits tab's nested navigator can pop (i.e., not on its root route).
    final benefitsNavigator = _navigatorKeys[1].currentState;
    final isBenefitsDetail =
        _navbarController.currentIndex == 1 &&
        (benefitsNavigator?.canPop() ?? false);

    // Determine if we're inside a Health detail route by checking if the
    // Health tab's nested navigator can pop (i.e., not on its root route).
    final healthNavigator = _navigatorKeys[2].currentState;
    final isHealthDetail =
        _navbarController.currentIndex == 2 &&
        (healthNavigator?.canPop() ?? false);

    return NotificationListener<SetSocialSubTabNotification>(
      onNotification: (n) {
        _desiredSocialSubTab = n.subTabIndex;
        return true;
      },
      child: NotificationListener<TabSwitchNotification>(
        onNotification: (notification) {
          _onNavigationChanged(notification.tabIndex);
          // If switching to Social and a desired sub-tab is queued, rebuild that tab's root
          if (notification.tabIndex == 3 && _desiredSocialSubTab != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final socialNav = _navigatorKeys[3].currentState;
              // Reset to root and navigate explicitly to the Challenges tab route
              socialNav?.popUntil((route) => route.isFirst);
              final targetRoute = _desiredSocialSubTab == 1
                  ? '/challengesTab'
                  : '/leaderboardTab';
              socialNav?.pushReplacementNamed(targetRoute);
              _desiredSocialSubTab = null;
            });
          }
          return true;
        },
        child: Scaffold(
          // Route-aware top navigation: simplified on detail pages, else standard
          appBar: isBenefitsDetail
              ? _SecondaryNavAppBar(
                  title: _benefitsDetailTitle ?? 'Benefit Details',
                  onBack: () => benefitsNavigator?.maybePop(),
                )
              : isHealthDetail
              ? _SecondaryNavAppBar(
                  title: _healthDetailTitle ?? 'Step Details',
                  onBack: () => healthNavigator?.maybePop(),
                )
              : _LoadingAwareTopNavigation(
                  onAvatarTap: () => _showProfileSettings(context),
                  onCurrencyTap: () => _showCurrencyDetails(context),
                  onBuddyTap: () => _showBuddyChat(context),
                ),
          // Use IndexedStack to preserve state across tabs
          body: IndexedStack(
            index: _navbarController.currentIndex,
            children: _pages,
          ),
          // Use bubble_ds BdsNavbar component
          bottomNavigationBar: BdsNavbar(
            controller: _navbarController,
            onChanged: _onNavigationChanged,
            navbarItems: [
              // Home tab
              BdsNavbarItem(
                label: 'Home',
                icon: BdsNavbarIcons.home,
                onTapEnabled: ({required isCurrentItem}) {
                  // Handle home tab selection
                  if (!isCurrentItem) {
                    _onNavigationChanged(0);
                  }
                },
              ),
              // Benefits tab
              BdsNavbarItem(
                label: 'Benefits',
                icon: BdsNavbarIcons.benefits,
                onTapEnabled: ({required isCurrentItem}) {
                  // Handle benefits tab selection
                  if (!isCurrentItem) {
                    _onNavigationChanged(1);
                  }
                },
              ),
              // Health tab - using journey icon as closest match
              BdsNavbarItem(
                label: 'Health',
                icon: BdsNavbarIcons.journey,
                onTapEnabled: ({required isCurrentItem}) {
                  // Handle health tab selection
                  if (!isCurrentItem) {
                    _onNavigationChanged(2);
                  }
                },
              ),
              // Social tab
              BdsNavbarItem(
                label: 'Social',
                icon: BdsNavbarIcons.social,
                onTapEnabled: ({required isCurrentItem}) {
                  // Handle social tab selection
                  if (!isCurrentItem) {
                    _onNavigationChanged(3);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show profile settings modal
  void _showProfileSettings(BuildContext context) {
    showBFModal(
      context: context,
      title: 'Profile & Settings',
      child: const BFModalContent(child: ProfileSettingsModal()),
      // Force to top by using root navigator route and full-screen container
      isScrollControlled: true,
      useRootNavigator: true,
      extraTopPadding: 16,
    );
  }

  /// Show buddy chat modal
  void _showBuddyChat(BuildContext context) {
    showBFModal(
      context: context,
      title: 'Health Buddy',
      headerLeading: SvgPicture.asset('assets/icons/IxBuddy.svg', width: 40),
      child: const BFModalContent(child: BuddyChatModal()),
      isScrollControlled: true,
      useRootNavigator: true,
      extraTopPadding: 16,
    );
  }

  /// Show currency details modal
  void _showCurrencyDetails(BuildContext context) {
    showBFModal(
      context: context,
      title: 'Your Currency',
      // Removed headerLeading icon per request
      child: const BFModalContent(child: CurrencyDetailsModal()),
      isScrollControlled: true,
      useRootNavigator: true,
      extraTopPadding: 16,
    );
  }
}

/// Custom AppBar that handles currency service loading
class _LoadingAwareTopNavigation extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onAvatarTap;
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onBuddyTap;

  const _LoadingAwareTopNavigation({
    this.onAvatarTap,
    this.onCurrencyTap,
    this.onBuddyTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: CurrencyService().ensureLoaded(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Keep layout stable without a separate app bar tint
          return const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: SizedBox.shrink(),
          );
        }

        if (snapshot.hasError) {
          return const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: SizedBox.shrink(),
          );
        }

        return BFReactiveTopNavigation(
          userInitials: 'JD', // TODO: Get from user state
          currencyNotifier: CurrencyService().currencyNotifier,
          onAvatarTap: onAvatarTap,
          onCurrencyTap: onCurrencyTap,
          onBuddyTap: onBuddyTap,
          buddyGraphic: SvgPicture.asset('assets/icons/IxBuddy.svg', width: 40),
          currencyGraphic: ValueListenableBuilder<int>(
            valueListenable: CurrencyService().currencyNotifier,
            builder: (context, amount, _) {
              return AnimatedCurrencyGraphic(
                amount: amount,
                child: SvgPicture.asset(
                  'assets/icons/betteflies-graphic.svg',
                  height: 20,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// AppBar wrapper that hosts the exact SecondaryPageNavBar.
class _SecondaryNavAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const _SecondaryNavAppBar({required this.title, this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Use a Container to match AppBar size and background, but render the
    // provided exact SecondaryPageNavBar inside without altering its structure.
    return Container(
      color: BdsColors.backgroundSecondary,
      child: SecondaryPageNavBar(title: title, onBack: onBack),
    );
  }
}

/// Route observer that extracts a human-readable title for the benefits detail
/// route. It listens to pushes on the Benefits tab navigator and updates the
/// title when entering `'/lsa'`.
class _DetailRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final void Function(String? title) onTitleChanged;

  _DetailRouteObserver({required this.onTitleChanged});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _maybeUpdateTitle(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _maybeUpdateTitle(previousRoute);
  }

  void _maybeUpdateTitle(Route? route) {
    if (route is PageRoute) {
      final name = route.settings.name ?? '';
      if (name == '/lsa') {
        // If arguments include a title, use it; else default to LSA Benefits
        final args = route.settings.arguments;
        String? title;
        if (args is Map && args['title'] is String) {
          title = args['title'] as String;
        } else {
          title = 'Details';
        }
        onTitleChanged(title);
        return;
      }
    }
    // Not a detail route → clear title so we show standard nav
    onTitleChanged(null);
  }
}

/// Route observer that extracts a human-readable title for the health detail
/// route. It listens to pushes on the Health tab navigator and updates the
/// title when entering '/steps'.
class _HealthDetailRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final void Function(String? title) onTitleChanged;

  _HealthDetailRouteObserver({required this.onTitleChanged});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _maybeUpdateTitle(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _maybeUpdateTitle(previousRoute);
  }

  void _maybeUpdateTitle(Route? route) {
    if (route is PageRoute) {
      final name = route.settings.name ?? '';
      if (name == '/steps') {
        // If arguments include a title, use it; else default to Step Details
        final args = route.settings.arguments;
        String? title;
        if (args is Map && args['title'] is String) {
          title = args['title'] as String;
        } else {
          title = 'Step Details';
        }
        onTitleChanged(title);
        return;
      }
    }
    // Not a detail route → clear title so we show standard nav
    onTitleChanged(null);
  }
}
