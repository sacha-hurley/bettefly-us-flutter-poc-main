# Social Page - Product Requirements Document

## Overview
The Social Page is a key feature of our health app that gamifies wellness through competition and challenges. It serves as the central hub for company-wide engagement, personal goal achievement, and social connection within the workplace wellness ecosystem.

## Core Features

### 1. Leaderboard (Primary Tab)
A company-wide ranking system that displays all employees within the organization.

**Display Elements:**
- Employee name and avatar
- Current rank position
- Sortable metrics with clear labeling:
  - **Total Lifetime Currency Earned** (default sort)
  - Challenge Completions
  - Total Step Count

**Technical Requirements:**
- App-based refresh (no real-time updates)
- Sortable by any of the three metrics
- Clear indication of current sort method
- Placeholder avatars for users without custom images
- MVP data source: mock/local dataset with client-side sorting (no backend required initially)

### 2. Challenges (Secondary Tab)

#### 2.1 Evergreen Daily Challenges
**Structure:**
- One challenge per day, weekdays only
- Simple step-based goals (e.g., "Complete 10,000 steps today")
- Rewards: 100 Better Flies per completion
- Default daily step target: 10,000 steps (configurable in future iterations)

**UI Elements:**
- Progress tracking with visual indicators (progress bars, counters)
- Clear completion status (checkmarks)
- Integration with step tracking functionality

#### 2.2 Company Monthly Challenges
**Structure:**
- Created by HR/wellness coordinator
- One active monthly challenge at a time
- Hierarchy: Daily → Weekly → Monthly completion
  - Complete 5 daily challenges = Weekly completion (500 Better Flies)
  - Complete 4 weekly challenges = Monthly completion (1000 Better Flies)

**Opt-in Requirements:**
- Users must opt-in before accessing company challenges
- Simple opt-in button with confirmation toast
- Animated challenge appearance after opt-in
- Mid-month opt-ins start from current week position

**Progress Tracking:**
- Visual progress indicators for daily, weekly, and monthly goals
- Clear completion status for each tier

### 3. Friend Connection (Future Feature)
- Friend icon with plus symbol
- Located top-right under navigation
- Currently placeholder only - no functionality required

## User Interface Structure

### Tab Navigation
- **Tab 1: Leaderboard** (default)
- **Tab 2: Challenges**

### Empty States
- New user state with onboarding context
- No active challenges state
- Loading states for data refresh

### Challenge History
- Dedicated view for completed challenges
- Display elements:
  - Challenge name and completion date
  - Currency awarded
  - Challenge type (daily/weekly/monthly)

## Currency Integration

### Better Flies System
- **Lifetime Total**: Used for leaderboard ranking
- Lifetime Total includes all earned currency from any source (challenge and non-challenge)
- **Current Wallet**: Available currency for redemption
- **Award Structure**:
  - Daily Challenge: 100 Better Flies
  - Weekly Challenge: 500 Better Flies  
  - Monthly Challenge: 1000 Better Flies

### Integration Points
- Currency awards automatically added to user wallet
- Lifetime totals updated for leaderboard ranking
- Integration with existing redemption system

## Technical Specifications

### Platform
- Flutter mobile application
- iOS and Android compatibility

### Data Requirements
- User profiles (name, avatar, currency totals)
- Challenge definitions and progress tracking
- Company challenge configuration
- Step count integration
- Historical challenge completion data

### Key Interactions
- Tab switching between Leaderboard and Challenges
- Leaderboard sorting functionality
- Challenge opt-in flow
- Progress tracking updates
- Challenge completion confirmation

## Future Considerations
- Weekend challenge options
- Multiple daily challenge choices
- Difficulty scaling and personalization
- Team-based company challenges
- Enhanced friend connection features
- Real-time leaderboard updates
- Push notification integration
- Privacy settings for profile visibility

## Success Metrics
- User engagement with daily challenges
- Company challenge opt-in rates
- Leaderboard interaction frequency
- Currency accumulation and redemption correlation

---

*This PRD serves as the foundation for implementing the Social Page within the existing health app prototype. All currency integration should connect with the established Better Flies redemption system already present in the application.*


