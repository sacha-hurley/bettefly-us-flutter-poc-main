## Health Dashboard PRD – Flutter iOS (MVP)

### Overview
Create a comprehensive health dashboard page for a Flutter iOS health app that displays data from Apple Health (iPhone + Apple Watch). The dashboard provides quick insights into key metrics and motivates continued engagement.

### MVP Decisions (Locked)
- **Data source**: HealthKit only (no CoreMotion fallback in MVP)
- **Phase 1 metrics**: Steps, Heart Rate, Active Calories
- **Charts**: `fl_chart` for lightweight visualizations
- **Refresh behavior**: On app launch/foreground and pull-to-refresh (real-time observers are V2)
- **CTA copy**: Use "Enable Health Access" (opens Settings) instead of "Connect Wearable"
- **Distance visualization (future)**: Use charts; map/route view deferred beyond MVP
- **Sleep detail (future)**: Basic asleep/awake first; detailed staging (REM/Deep/Light) is V2

---

### Technical Requirements
- **Platform**: iOS (Flutter)
- **Integration**: Flutter `health` package for HealthKit
- **Design System**: Use existing `bf_design_system` tokens and components

```yaml
dependencies:
  health: ^latest_version
  fl_chart: ^latest_version
```

#### iOS Permissions (Info.plist)
```xml
<key>NSHealthShareUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We will sync your data with the Apple Health app to give you better insights</string>
```

#### Capabilities
- Enable HealthKit capability in Xcode (`com.apple.developer.healthkit` entitlement) for the Runner target.

---

### Feature Specifications

#### Health Dashboard Main Page
Layout:
```
┌─────────────────────────────────────┐
│ Summary Row (Horizontal)            │
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
│ │ Met │ │ Met │ │ Met │ │ Met │   │
│ │ ric │ │ ric │ │ ric │ │ ric │   │
│ │  1  │ │  2  │ │  3  │ │  4  │   │
│ └─────┘ └─────┘ └─────┘ └─────┘   │
├─────────────────────────────────────┤
│ Detailed Metric Cards (Scrollable)  │
│ ┌─────────────────────────────────┐ │
│ │ Steps Card                      │ │
│ │ [Chart/Visual] [Today's Count]  │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Heart Rate Card                 │ │
│ │ [Chart/Visual] [Current/Avg]    │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Active Calories Card            │ │
│ │ [Chart/Visual] [Today's Total]  │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

Summary Row:
- Horizontal scroll of metric highlights
- Metric name, current value, unit
- Tap → navigate to metric detail page

Detailed Metric Cards (MVP):
1. Steps (iPhone + Apple Watch via HealthKit)
2. Heart Rate (Apple Watch)
3. Active Calories (Apple Watch)

Card content:
- Metric name and icon
- Primary visualization (chart)
- Current/latest value with unit
- Brief insight (e.g., relative to yesterday)
- Tap target → detail page

States & Error Handling:
- Connected (permissions granted): show metrics
- No permissions: explain + "Enable Health Access" (open Settings)
- Empty/no data: friendly message and guidance

#### Metric Detail Pages (Template)
```
┌─────────────────────────────────────┐
│ [Back] Metric Name           [Menu] │
├─────────────────────────────────────┤
│ Current Value & Unit                │
│ Trend indicator (↑↓=)              │
├─────────────────────────────────────┤
│ Primary Chart/Visualization         │
├─────────────────────────────────────┤
│ Time Period Selector                │
│ [Today] [Week] [Month]              │
├─────────────────────────────────────┤
│ Insights Section                    │
│ • Key statistics                    │
│ • Comparisons to previous periods   │
│ • Health tips/context               │
├─────────────────────────────────────┤
│ Data Source Info                    │
│ "From Apple Health"                 │
└─────────────────────────────────────┘
```

MVP visualizations:
- Steps: bar (hourly or daily)
- Heart Rate: line (current/avg)
- Active Calories: stacked bar (active vs resting if available; else active only)

---

### Data Integration

HealthKit data types (requested for MVP):
```dart
final types = <HealthDataType>[
  HealthDataType.STEPS,
  HealthDataType.HEART_RATE,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  // (Future phases)
  // HealthDataType.RESTING_ENERGY_BURNED,
  // HealthDataType.SLEEP_IN_BED,
  // HealthDataType.SLEEP_ASLEEP,
  // HealthDataType.SLEEP_AWAKE,
  // HealthDataType.FLIGHTS_CLIMBED,
  // HealthDataType.WALKING_RUNNING_DISTANCE,
  // HealthDataType.CYCLING_DISTANCE,
  // HealthDataType.WORKOUT,
];
```

Data refresh strategy:
- Trigger: app launch and when returning to foreground
- Fallback: pull-to-refresh gesture
- Future: real-time via HealthKit observers (out of scope for MVP)

Processing:
- Time range: Today (midnight → now), local device timezone
- Aggregation: sum for cumulative (steps, calories); avg for instantaneous (heart rate)
- Source handling: rely on HealthKit-aggregated totals to avoid double-counting
- Caching: simple on-device cache for offline viewing (today’s data)

---

### Navigation & UX
- Entry: Health tab in main navigation
- Back navigation: standard iOS back gesture/button; preserve dashboard scroll
- Accessibility: VoiceOver labels, sufficient contrast, 44pt targets, Dynamic Type
- Performance: smooth scrolling, lazy chart rendering, lightweight charts (`fl_chart`)

---

### Acceptance Criteria (MVP)
- HealthKit integration working with required permissions
- Summary row and three metric cards render with appropriate charts
- Detail pages accessible via taps; show current value and simple chart
- No-permissions state displays with "Enable Health Access" and opens Settings
- Empty states are friendly and consistent with design system
- App loads dashboard within ~2s on target devices

---

### Risks & Constraints
- HealthKit capability and entitlements must be enabled in Xcode (Runner target)
- Testing requires real iPhone; HealthKit isn’t available on Simulator
- No CoreMotion fallback in MVP (copy guides users to enable Health access)
- Map routes and detailed sleep staging deferred to later phases

---

### Implementation Notes (for this repo)

Recommended file structure additions:
```
lib/
├── screens/
│   ├── health_dashboard_screen.dart
│   └── metric_detail_screen.dart
├── widgets/
│   ├── health/
│   │   ├── summary_metric_card.dart
│   │   ├── detailed_metric_card.dart
│   │   ├── metric_chart.dart
│   │   └── empty_state_widget.dart
├── services/
│   ├── health_service.dart
│   └── health_data_processor.dart
├── models/
│   └── health_metric.dart
└── utils/
    └── health_permissions.dart
```

Phased plan:
1) Setup & permissions scaffolding; verify on device
2) Dashboard shell + Steps card
3) Add Heart Rate, Active Calories + detail pages
4) Polish (insights text, accessibility, performance)


