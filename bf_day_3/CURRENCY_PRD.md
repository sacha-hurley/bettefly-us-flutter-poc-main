# BetterFlies Currency Feature - Product Specification

## Overview
The BetterFlies (BFs) currency system is a fully implemented gamified reward mechanism that incentivizes healthy behaviors within the Betterfly app. Users earn BetterFlies by completing various health-related actions and can spend them on employer-sponsored rewards with real monetary value. The system is currently operational with advanced animation features and persistent storage.

## Core Objectives
- Motivate users to complete health-improving actions through meaningful rewards
- Provide persistent feedback on user progress and achievements
- Create a bridge between healthy behaviors and tangible benefits
- Integrate seamlessly with the existing Tour (todo list) feature

## Currency Mechanics

### Earning Structure
| Action Type | BF Value | Examples |
|-------------|----------|----------|
| Small | 5-10 BFs | Stand for 1 minute, drink water reminder |
| Medium | 100 BFs | Connect wearable, complete questionnaire |
| Large | 300 BFs | Complete weekly action set |
| Major | 500 BFs | Complete monthly action set |

### Value Conversion
- **Exchange Rate**: Defined in one centralized constant used by all features (see implementation notes). Subject to change based on employer partnerships and validation.

### Currency Properties
- **Accumulation**: Unlimited (no cap)
- **Persistence**: Indefinite (no expiration)
- **Repeatability**: Same action types can be completed multiple times as separate instances
- **Eligibility**: Only actions with assigned `bfRewardValue` > 0 generate BFs

## User Interface Components

### 1. Currency Counter (Persistent) ✅ IMPLEMENTED
**Location**: Navigation bar on all app screens (via toolbar)
**Visibility**: All screens except overlays/modals
**Display**: Total BF balance as integer with blue circle icon

**States**:
- Default: Shows current balance with gray background
- Updated: Triggers three-phase animation when new BFs earned
- Interactive: Taps to open CurrencyDetailsModal

### 2. Earning Animations ✅ IMPLEMENTED
**Advanced Three-Phase Animation System**:
- **Phase 1**: Counter expansion with color change (0.2s)
- **Phase 2**: Number roll animation to new balance (0.3s)  
- **Phase 3**: Counter contraction back to normal (0.2s)
- **Total Duration**: 0.7 seconds with smooth easing

**Animation Types by Amount (current implementation)**:
- **Small**: Default for most amounts, including 5–10 BFs and other non-matching values
- **Medium**: Exactly 100 BFs
- **Large**: 300–500 BFs

**Toast Notifications**:
- Slide-in animation from top of screen (0.6s spring animation)
- Shows "+X [ladybug symbol] earned" message (uses SF Symbol `ladybug`)
- Auto-dismisses after 3 seconds
- Manual dismiss with X button

### 3. Currency Details Modal ✅ IMPLEMENTED
**Trigger**: Tap on currency counter
**Implementation**: SwiftUI sheet presentation with navigation

**Content Sections**:

1. **Current Balance** ✅
   - Large, prominent display (48pt bold font) of total BFs
   - "Your BetterFlies" header with secondary text color
   - Clean, centered layout

2. **Recent Activity** ✅
   - Last 30 days of BF earnings (automatically filtered)
   - Each entry shows:
     - Action description (e.g., "Complete your next challenge")
     - Source display name (e.g., "Tour Item")
     - Date in relative format
     - BFs earned with green color and + prefix
   - Plain list style with proper spacing

3. **Empty State** ✅
   - "No recent activity" message when no earnings
   - Proper secondary text styling

4. **Navigation** ✅
   - "Done" button in navigation bar
   - Proper modal dismissal handling

**Implemented Features** (Phase 3 Completed):
- ✅ Extended history beyond 30 days (All Time view)
- ✅ Milestone/tier progress visualization with 4 tiers
- ✅ Educational content about BetterFlies
- ✅ Rewards catalog integration (placeholder UI)
- ✅ Enhanced visual design with cards and shadows
- ✅ Milestone tier system: Explorer, Champion, Master, Legend

## Technical Implementation

### Data Model ✅ IMPLEMENTED
```swift
struct BetterFly: Identifiable, Codable {
    let id: UUID
    let amount: Int
    let earnedDate: Date
    let source: BFSource
    let actionDescription: String
    let actionId: String?
}

enum BFSource: String, CaseIterable, Codable {
    case tourItem = "tour_item"
    case manualEntry = "manual_entry"
    case wearableSync = "wearable_sync"
    case bonus = "bonus"
    
    var displayName: String { /* Implementation provided */ }
}

struct BFBalance: Codable {
    let totalBalance: Int
    let lastUpdated: Date
    let recentEarnings: [BetterFly]
    
    var last30DaysEarnings: [BetterFly] { /* Auto-filtered */ }
    var calculatedTotal: Int { /* Validation helper */ }
}
```

### Tour Integration ✅ IMPLEMENTED
- Each tour step has `currencyReward: Int` property (not optional)
- When user marks tour item complete:
  1. ✅ Award BFs through CurrencyService.awardBetterFlies()
  2. ✅ Create BetterFly record with tour item details
  3. ✅ Trigger three-phase counter animation based on amount
  4. ✅ Show toast notification with earned amount
  5. ✅ Update persistent storage automatically

### Data Persistence ✅ IMPLEMENTED
- ✅ UserDefaults for local storage (JSON encoding/decoding)
- ✅ Store individual BetterFly records for history
- ✅ Automatic balance calculation and caching
- ✅ Persistent across app launches
- ⏳ Backend sync (future enhancement)

### Animation System ✅ IMPLEMENTED
```swift
enum BFAnimationType {
    case small(amount: Int)    // 5-50 BFs
    case medium(amount: Int)   // 51-100 BFs  
    case large(amount: Int)    // 101+ BFs
    
    var config: CounterAnimationConfig { /* Three-phase config */ }
}

struct CounterAnimationConfig {
    let expansionScale: CGFloat
    let expansionDuration: Double
    let rollDuration: Double
    let contractionDuration: Double
    let colorAccent: Color?
}
```

## User Experience Flow

### Earning BetterFlies
1. User completes action (e.g., marks tour item as done)
2. System checks if action has BF reward
3. If yes:
   - Add BFs to balance
   - Show appropriate animation
   - Update counter display
   - Create history record
4. User sees updated balance in nav bar counter

### Viewing Details
1. User taps currency counter in nav bar
2. Modal slides up showing detailed view
3. User can scroll through recent activity
4. User can access extended history if needed
5. User taps outside or close button to dismiss

## Edge Cases & Considerations

### Duplicate Actions
- Same action types on different days = separate instances
- Each instance awards BFs independently
- History shows each completion separately

### Network Connectivity
- All BF operations work offline
- Sync to backend when connection restored
- Show loading states during sync

### Data Migration
- Plan for future changes to BF values
- Historical data remains unchanged
- New rates apply to future earnings only

### Performance
- Lazy load extended history
- Cache recent data for quick modal display
- Optimize counter updates for smooth animations

## Future Enhancements (Out of Scope)
- Leaderboard integration
- BF redemption backend sync and configuration management
- Milestone/tier system with specific thresholds
- Social sharing of achievements
- Push notifications for BF earnings
- Employer dashboard integration

## Success Metrics
- BF earning frequency per user
- Modal engagement rates
- Tour completion rates (post-BF implementation)
- User retention correlation with BF activity
- Average time between app sessions

## Implementation Status

### ✅ Phase 1: COMPLETED
- ✅ Basic counter with persistent display
- ✅ Earning system with tour integration
- ✅ Advanced three-phase animations
- ✅ Toast notifications with slide animations

### ✅ Phase 2: COMPLETED  
- ✅ Detailed modal with recent history
- ✅ 30-day activity filtering
- ✅ Proper navigation and dismissal

### ✅ Phase 3: COMPLETED
- ✅ Extended history beyond 30 days (All Time view)
- ✅ Educational content about BetterFlies (expandable section)
- ✅ Milestone/tier progress visualization (4-tier system)
- ✅ Rewards catalog integration (placeholder UI ready for backend)

### ✅ Phase 4: COMPLETED
- ✅ Enhanced animations with three-phase system
- ✅ Visual polish with proper design system integration
- ✅ Smooth transitions and professional feel

## Current Architecture

### Key Files
- `CurrencyService.swift` - Main service with @MainActor
- `CurrencyCounter.swift` - Animated counter component
- `CurrencyDetailsModal.swift` - History and details view
- `BetterFly.swift` - Data models with Codable
- `BFBalance.swift` - Balance management
- `BFAnimationType.swift` - Animation configuration

### Integration Points
- Tour system integration via TourState
- Design system integration (colors, typography, spacing)
- Persistent storage via UserDefaults
- SwiftUI animation system

## Milestone System (Phase 3 - IMPLEMENTED)

### Tier Structure
The milestone system includes 4 user tiers based on total BetterFly balance:

| Tier | Threshold | Color | Description |
|------|-----------|-------|-------------|
| **Explorer** | 0 BFs | Secondary | Starting tier for new users |
| **Champion** | 1,000 BFs | Primary | First milestone achievement |
| **Master** | 5,000 BFs | Success | Advanced user level |
| **Legend** | 10,000 BFs | Warning | Maximum achievement level |

### Progress Tracking
- **Current Tier**: Automatically calculated based on total balance
- **Progress Bar**: Visual indicator showing progress to next tier
- **BFs to Next**: Shows exact amount needed for next milestone
- **Tier Colors**: Each tier has distinct color coding for visual recognition

### Implementation Details
- **BFBalance.swift**: Contains `MilestoneTier` enum with thresholds and calculations
- **CurrencyDetailsModal.swift**: Displays tier progress and educational content
- **Dynamic Updates**: Progress automatically updates as user earns more BFs
- **Visual Design**: Cards with shadows and proper spacing for professional appearance

---

*This specification reflects the current fully implemented BetterFlies currency system. The system is operational and ready for production use with advanced animation features and persistent storage.*

## Addendum: BF → LSA Redemption (Prototype)

### Overview
Users can redeem BetterFlies for LSA credits. Redemption occurs within the existing Currency Details experience.

### Exchange Rate (Single Source of Truth)
- A single exchange rate constant is referenced by both currency and benefits features.

### Transaction Modeling (prototype)
- Activity history uses “transactions” for both earnings and redemptions.
- **BF Transaction (Spend/Redemption)**
  - Negative BF amount (e.g., −1000).
  - Type: `redemption`.
  - No cross-reference `linkedId` in the prototype scope.
- **LSA Transaction (Credit from Redemption)**
  - Positive USD amount (e.g., +$10.00).
  - Type: `redemption`.
  - No cross-reference `linkedId` in the prototype scope.

### UI Surface
- Redemption UI appears in the Currency Details modal under the Rewards/Catalog section as "LSA Credit".

### State & Updates
- Redemption operation is atomic: create BF spend (−BFs) and LSA credit (+$) together.
- Immediately update Currency UI (reduced BFs) and Benefits UI (increased LSA balance).

### Expiry
- LSA top‑ups from BF redemptions share the same year‑end expiry policy as employer allocations.

### Prototype Scope
- Local-only (no backend). No server integration is implied in this prototype.
- Validation: fixed increments and sufficient balance checks.
