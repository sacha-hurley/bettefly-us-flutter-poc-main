import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:bubble_ds/bubble_ds.dart';
import '../widgets/social_page_tab_nav.dart';
import '../widgets/leaderboard_card.dart';
import '../widgets/daily_challenge_card.dart';
import '../widgets/secondary_todo_card.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/company_monthly_challenge_card.dart';
import '../widgets/company_monthly_challenge_opted_in_card.dart';
import '../widgets/notification_host.dart';
import '../widgets/recent_activity_card.dart';

/// Social tab root screen (placeholder evolving toward a two-tab UI)
class ChallengesScreen extends StatefulWidget {
  final int initialTab;
  const ChallengesScreen({super.key, this.initialTab = 0});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  int _activeTab = 0; // 0: Leaderboard, 1: Challenges
  LeaderboardSortType _sortType = LeaderboardSortType.lifetime;
  final List<LeaderboardUser> _users = [];
  final math.Random _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
    _appendRandomUsers(10);
    _sortUsers();
  }

  void _appendRandomUsers(int count) {
    const firstNames = [
      'Ava',
      'Noah',
      'Liam',
      'Emma',
      'Olivia',
      'Sophia',
      'Mason',
      'Isabella',
      'Lucas',
      'Mia',
      'Ethan',
      'Amelia',
      'James',
      'Harper',
      'Benjamin',
      'Evelyn',
    ];
    const lastNames = [
      'Johnson',
      'Owly',
      'Kibbler',
      'Smith',
      'Brown',
      'Taylor',
      'Wilson',
      'Davis',
      'Clark',
      'Lewis',
      'Walker',
      'Young',
      'Hall',
      'Allen',
      'King',
    ];

    List<LeaderboardUser> generated = List.generate(count, (i) {
      final first = firstNames[_rng.nextInt(firstNames.length)];
      final last = lastNames[_rng.nextInt(lastNames.length)];
      final name = '$first $last';
      final initials =
          ((first.isNotEmpty ? first[0] : '') +
                  (last.isNotEmpty ? last[0] : ''))
              .toUpperCase();
      final flies = 5000 + _rng.nextInt(200000 - 5000);
      final challenges = 5 + _rng.nextInt(120);
      final steps = 20000 + _rng.nextInt(900000);
      return LeaderboardUser(
        name: name,
        initials: initials,
        rank: 0,
        lifetimeFlies: flies,
        challengesCompleted: challenges,
        totalSteps: steps,
      );
    });
    _users.addAll(generated);
  }

  void _sortUsers() {
    switch (_sortType) {
      case LeaderboardSortType.lifetime:
        _users.sort((a, b) => b.lifetimeFlies.compareTo(a.lifetimeFlies));
        break;
      case LeaderboardSortType.challenges:
        _users.sort(
          (a, b) => b.challengesCompleted.compareTo(a.challengesCompleted),
        );
        break;
      case LeaderboardSortType.totalSteps:
        _users.sort((a, b) => b.totalSteps.compareTo(a.totalSteps));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Social', style: BdsTextStyle.displayMedium()),
            ),
            const SizedBox(height: 24),
            // New pixel-perfect Social tab navigation under the title
            SocialPageTabNav(
              onTabChanged: (i) => setState(() => _activeTab = i),
              activeTab: _activeTab,
              onFriendIconTap: () {
                final snack = const SnackBar(
                  content: Text('Add friend tapped'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snack);
              },
              useFigmaEdgePadding: false, // sits directly under the title
              bottomPadding: 0, // exact control; we add 16 below per spec
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _activeTab == 0
                  // Leaderboard
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Secondary To-Do for Leaderboard
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const SecondaryTodoCard(
                              todoIds: ['leaderboard'],
                              pageContext: 'social_leaderboard',
                              titleOverride: 'Explore leaderboard',
                              subtitleOverride:
                                  'Scroll down and check the leaderboard rankings.',
                            ),
                          ),
                          const SizedBox(height: 16),
                          LeaderboardCard(
                            users: _users,
                            activeSortType: _sortType,
                            onSortChanged: (t) {
                              setState(() {
                                _sortType = t;
                                _sortUsers();
                              });
                            },
                            onLoadMore: () {
                              setState(() {
                                _appendRandomUsers(10);
                                _sortUsers();
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  // Challenges content (only two cards per spec)
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Secondary To-Do for Challenges tab
                            const SecondaryTodoCard(
                              todoIds: ['challenge'],
                              pageContext: 'social_challenges',
                              titleOverride: 'Opt-in to company challenge',
                              subtitleOverride:
                                  'Join the monthly challenge and start earning more.',
                            ),
                            const SizedBox(height: 16),
                            // Daily Challenge Card should be the first element
                            const DailyChallengeCard(),
                            const SizedBox(height: 16),
                            // Monthly card (opt-in vs opted-in)
                            Builder(
                              builder: (context) {
                                final hasJoined = context
                                    .watch<AppState>()
                                    .hasJoinedCompany;
                                if (hasJoined) {
                                  return const CompanyMonthlyChallengeOptedInCard();
                                }
                                return CompanyMonthlyChallengeCard(
                                  onOptIn: () {
                                    context
                                        .read<AppState>()
                                        .joinCompanyChallenge();
                                    NotificationHost.showToast(
                                      context,
                                      message:
                                          "You've opted into a monthly challenge",
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Recent Activity Card at the bottom
                            RecentActivityCard(
                              activities: const [
                                ActivityItem(
                                  title: 'Daily Step Goal',
                                  timestamp: 'Yesterday',
                                  rewardAmount: 100,
                                ),
                                ActivityItem(
                                  title: 'Weekly Challenge',
                                  timestamp: '2 days ago',
                                  rewardAmount: 1000,
                                ),
                                ActivityItem(
                                  title: 'Daily Step Goal',
                                  timestamp: 'Last week',
                                  rewardAmount: 100,
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mock leaderboard placeholder (no backend, simple local list)
class _MockLeaderboard extends StatefulWidget {
  @override
  State<_MockLeaderboard> createState() => _MockLeaderboardState();
}

enum _SortMetric { lifetime, completions, steps }

class _MockLeaderboardState extends State<_MockLeaderboard> {
  _SortMetric _sortBy = _SortMetric.lifetime;

  @override
  Widget build(BuildContext context) {
    final items = [
      _UserRow('Christina M.', 1, 5400, 18, 124_000),
      _UserRow('Noah R.', 2, 4300, 15, 117_500),
      _UserRow('Ava L.', 3, 3900, 12, 96_200),
      _UserRow('Oliver K.', 4, 3100, 9, 88_400),
      _UserRow('Sophia W.', 5, 2900, 8, 80_150),
    ];
    items.sort((a, b) {
      switch (_sortBy) {
        case _SortMetric.lifetime:
          return b.lifetime.compareTo(a.lifetime);
        case _SortMetric.completions:
          return b.completions.compareTo(a.completions);
        case _SortMetric.steps:
          return b.steps.compareTo(a.steps);
      }
    });
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaderboard',
            style: BdsTextStyle.displaySmall().copyWith(
              color: BdsColors.onSurfaceText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Sort by:'),
              const SizedBox(width: 8),
              DropdownButton<_SortMetric>(
                value: _sortBy,
                onChanged: (v) => setState(() => _sortBy = v ?? _sortBy),
                items: const [
                  DropdownMenuItem(
                    value: _SortMetric.lifetime,
                    child: Text('Lifetime'),
                  ),
                  DropdownMenuItem(
                    value: _SortMetric.completions,
                    child: Text('Completions'),
                  ),
                  DropdownMenuItem(
                    value: _SortMetric.steps,
                    child: Text('Steps'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final it = items[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(it.name.split(' ').first.characters.first),
                  ),
                  title: Text('${it.rank}. ${it.name}'),
                  subtitle: Text(
                    'Lifetime: ${it.lifetime} · Completions: ${it.completions} · Steps: ${it.steps}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserRow {
  final String name;
  final int rank;
  final int lifetime;
  final int completions;
  final int steps;
  _UserRow(this.name, this.rank, this.lifetime, this.completions, this.steps);
}
