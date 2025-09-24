## PRD: Health LSA App — Day 3 User Experience (Flutter)

### 1) Purpose & Scope
This PRD refines your implementation-focused brief into a Flutter-first, navigation-led specification. It prioritizes system-level structure (navigation, screens, and state) before individual features and styles. It adapts the provided React-style examples to Flutter conventions, using named routes, Material components, and Provider-style state management. Emoji icons are replaced with Material Icons per project preferences.

---

### 2) App Navigation & Screens (Top Priority)

Named routes with a single-source-of-truth router. Initial route is `/`.

- `/` → `HomeScreen`
  - Shows: greeting, `MainTodoCard`, and four `SnapshotCard`s: LSA, Health, Challenge, Currency
- `/health-dashboard` → `HealthDashboardScreen`
  - Shows: yesterday steps, sleep, active minutes; CTA to mark dashboard reviewed
- `/challenges` → `ChallengesScreen`
  - Shows: available challenges, join CTA; if joined, shows progress
- `/challenges/company` → `CompanyChallengeDetailScreen`
  - Shows: current steps, daily goal, company goal; CTA to complete first challenge (enabled only if joined)
- `/lsa/details` → `LSADetailsScreen`
  - Shows: balance, recent transaction, link to eligible benefits
- `/lsa/benefits` → `BenefitsBrowserScreen`
  - Shows: benefits categories and items; CTA to mark browsing complete

Navigation rules and guards:
- `completeChallenge` action must be disabled until `joinChallenge` is true.
- All task-completion CTAs navigate back to `/` after updating state.
- State must persist across navigation and when returning home.

Deep linking (optional later): Map route names for potential platform deep links without altering in-app navigation.

**Bottom Navigation Bar:**
- Currently implements 4 tabs for the initial release
- **Future Enhancement:** Planned to expand to 5 tabs in subsequent versions
- Tab structure should be designed to accommodate the additional tab without major UI restructuring

**Persistent Navigation Pattern:**
- Bottom navigation bar remains visible on ALL screens (main and detail/secondary screens)
- Active tab highlighting shows current section context
- Tab organization (left→right):
  - **Home**: HomeScreen
  - **Benefits**: LSADetailsScreen, BenefitsBrowserScreen  
  - **Health**: HealthDashboardScreen
  - **Social**: ChallengesScreen, CompanyChallengeDetailScreen
- Users maintain navigation context and can switch between main sections from any screen

---

### 3) Information Architecture (per screen)

- Home
  - Header: user name
  - `MainTodoCard`: 4 tasks with prerequisite logic
  - `SnapshotCard` x4: LSA, Health, Challenge, Currency
- Health Dashboard
  - KPIs: steps, sleep, active minutes
  - Action: mark "Health dashboard reviewed" (awards coins)
- Challenges
  - If not joined: overview + CTA to join company challenge
  - If joined: show daily progress and link to company challenge detail
- Company Challenge Detail
  - Show progress meters and CTA to complete first challenge (awards coins)
- LSA Details
  - Show balance, last transaction, and link to benefits browser
- Benefits Browser
  - Category list (cards) → category detail items
  - Action: mark browsing complete

---

### 4) Global State Model (Dart)

Single app-wide state exposed via Provider. For Day 3, use `ChangeNotifier` for simplicity.

```dart
class AppState extends ChangeNotifier {
  String userName = 'Sarah';
  int coins = 350;
  int earningStreak = 3;

  bool reviewHealth = false;
  bool joinChallenge = false;
  bool completeChallenge = false;
  bool browseBenefits = false;

  double lsaBalance = 247.50;
  String lsaRecentTransaction = '+$25 receipt approved';

  int yesterdaySteps = 9247;
  String yesterdaySleep = '7h 32m';
  int yesterdayActiveMinutes = 45;

  bool hasJoinedCompany = false;
  int currentSteps = 1247;
  int dailyGoal = 8000;
  int companyGoal = 10000;

  // Task completion actions
  void completeHealthReview() {
    reviewHealth = true;
    coins += 25;
    notifyListeners();
  }

  void joinCompanyChallenge() {
    joinChallenge = true;
    hasJoinedCompany = true;
    coins += 25;
    notifyListeners();
  }

  void completeFirstChallenge() {
    if (!joinChallenge) return; // guard
    completeChallenge = true;
    coins += 50;
    notifyListeners();
  }

  void completeBenefitsBrowsing() {
    browseBenefits = true;
    notifyListeners();
  }
}
```

Notes:
- This mirrors your provided structure with idiomatic Dart fields.
- Guard clauses enforce prerequisites (e.g., cannot complete first challenge until joined).

---

### 5) Benefits Data (Flutter-friendly)

Replace emoji icons with Material Icons to meet project preferences.

```dart
enum BenefitCategory { wellness, fitness, medical, learning }

class BenefitItem { const BenefitItem(this.name, this.limit); final String name; final String limit; }

class BenefitGroup {
  const BenefitGroup({required this.title, required this.icon, required this.items});
  final String title;
  final IconData icon; // from Icons.*
  final List<BenefitItem> items;
}

const Map<BenefitCategory, BenefitGroup> eligibleBenefits = {
  BenefitCategory.wellness: BenefitGroup(
    title: 'Wellness & Mental Health',
    icon: Icons.self_improvement,
    items: [
      BenefitItem('Therapy sessions', '4 150 max/session'),
      BenefitItem('Meditation apps', '4 20/month'),
      BenefitItem('Stress management programs', 'Varies'),
    ],
  ),
  BenefitCategory.fitness: BenefitGroup(
    title: 'Fitness & Physical Health',
    icon: Icons.fitness_center,
    items: [
      BenefitItem('Gym memberships', '4 75/month'),
      BenefitItem('Personal training', '4 100/session'),
      BenefitItem('Massage therapy', '4 125/session'),
    ],
  ),
  BenefitCategory.medical: BenefitGroup(
    title: 'Medical & Preventive Care',
    icon: Icons.local_hospital,
    items: [
      BenefitItem('Annual physicals', 'Covered'),
      BenefitItem('Nutrition consultations', '4 80/session'),
      BenefitItem('Vision care', '4 200/year'),
    ],
  ),
  BenefitCategory.learning: BenefitGroup(
    title: 'Learning & Development',
    icon: Icons.menu_book,
    items: [
      BenefitItem('Health courses', '4 150/course'),
      BenefitItem('Wellness workshops', '4 50/workshop'),
    ],
  ),
};
```

---

### 6) UI Components & Styling (Flutter)

Reusable widgets:
- `SnapshotCard` (tap navigates to relevant screen)
- `MainTodoCard` (lists tasks; disables items with unmet prerequisites)
- `ProgressCounter` (shows completed/total with progress bar)

Styling guidelines (Flutter equivalents of provided CSS):
- `MainTodoCard`: gradient background (e.g., linear gradient from `Color(0xFF667EEA)` to `Color(0xFF764BA2)`), white text, 16–20 px padding, 16 px radius
- `SnapshotCard`: white background, 12 px radius, 16 px padding, subtle elevation/shadow
- `TodoItem`: row with leading status, label, and chevron; `Opacity` + `TextDecoration.lineThrough` for completed
- `ProgressCounter`: container with a background bar and a filled fraction based on completion

---

### 7) Task Logic (Navigation + State)

CTAs call state methods and then navigate home:
- Health Dashboard: `appState.completeHealthReview(); Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);`
- Challenges (join): `appState.joinCompanyChallenge(); Navigator.popUntil(context, ModalRoute.withName('/'));`
- Company Challenge (complete): guarded by `appState.joinChallenge`
- Benefits Browser: `appState.completeBenefitsBrowsing(); Navigator.popUntil(context, ModalRoute.withName('/'));`

Disabled states:
- `completeChallenge` list item is disabled if `!appState.joinChallenge`.

---

### 8) File Structure (Recommended)

```
lib/
  main.dart
  state/
    app_state.dart
  screens/
    home_screen.dart
    health_dashboard_screen.dart
    challenges_screen.dart
    company_challenge_detail_screen.dart
    lsa_details_screen.dart
    benefits_browser_screen.dart
  widgets/
    main_todo_card.dart
    snapshot_card.dart
    progress_counter.dart
```

This mirrors your component list while following Flutter conventions.

---

### 9) Acceptance Criteria

- Navigation
  - Named routes exist for all paths listed above
  - Returning home maintains updated state without app restart
- Tasks & State
  - Task prerequisites enforced (`completeChallenge` disabled until joined)
  - Coin counter updates immediately after each completion
  - Joining challenge flips UI from “join” to “progress” states
- UI
  - Cards present with gradient and elevation as described
  - ProgressCounter reflects completed/total tasks in Home
- Data
  - Benefits data rendered without emojis; uses Material Icons

---

### 10) Implementation Steps (Incremental)

1) Add `AppState` with `ChangeNotifier` and wire up `Provider` in `main.dart`.
2) Define named routes and empty screens for all paths.
3) Build `HomeScreen` layout: header, `MainTodoCard`, snapshot cards.
4) Implement `SnapshotCard` and link taps to the correct routes.
5) Implement each screen minimally with its CTA connected to `AppState` methods.
6) Enforce disabled state for `completeChallenge` until joined.
7) Style: gradient for `MainTodoCard`, elevation for `SnapshotCard`, progress bar.
8) Populate benefits data and list UI using Material Icons.
9) Verify acceptance criteria and adjust interactions/labels.

---

### 11) Risks & Notes

- Keep changes incremental: create screens and routes first, then connect state, then style.
- Navigation stack management: prefer `pushNamed`/`pop` patterns and `popUntil('/')` for return-to-home after CTAs.
- Consider extracting constants for route names to avoid typos.
- Future-proofing: If state grows, consider migrating from `ChangeNotifier` to Riverpod without changing screen contracts.


