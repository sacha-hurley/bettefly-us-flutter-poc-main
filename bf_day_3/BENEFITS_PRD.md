### Benefits Management (LSA-first) — PRD (Prototype)

#### Overview
This document summarizes the Benefits Management feature for a Flutter prototype with an LSA (Limited Spending Account) as the initial benefit. The feature enables users to see benefits at a glance on the homepage, manage them in a dedicated Benefits tab, view a rich benefit detail, and learn about eligible expenses via a searchable bottom sheet. The architecture should scale to multiple benefit types in the future while shipping a simple, testable MVP now.

#### Goals
- Provide a clear, card-based view of a user’s LSA card with balance and recent activity
- Offer quick actions (Upload Receipt, View Details) and a deep-dive detail page
- Educate users with an in-context, searchable "Learn More" sheet for eligible expenses
- Fit naturally into the app’s IA: Homepage summary → Benefits tab → Detail view

#### Non-Goals (MVP)
- Real provider integrations or real-time data sync
- Multiple benefits management beyond LSA (architecture should be extensible)
- Push notifications or advanced receipt upload workflows

---

### Information Architecture & Navigation
- Entry points:
  - Homepage summary card → CTA "Manage Benefits" → Benefits tab
  - Bottom navigation/tab for Benefits (dedicated page)
- Benefits tab content:
  - Header with page title "Benefits" and filter/sort controls
  - Categories list (HSA, LSA, Dependent Care, Transit, Vision, Dental, Mental Health/EAP, Wellness/Gym, Prescription Drugs, Life Insurance, Disability Insurance, Premium Contributions)
  - LSA card component as the primary focus for MVP

---

### Screens & Components (MVP)

#### 1) Homepage Benefits Summary Card
- Shows: progress ring/indicator, most recent activity, total available balance (across benefits or just LSA for MVP)
- CTA: "Manage Benefits" → navigates to Benefits tab

#### 2) Benefits Tab (Dedicated Page)
- Header: title "Benefits" + filter/sort controls (stubbed for MVP)
- Categories: list of benefit categories (non-interactive or simple filtering for MVP)
- LSA Benefit Card (primary):
  - Credit/debit card visual aesthetic
  - Masked card number (last 4 shown)
  - Provider name, expiration date
  - Spending visualization: progress bar used vs available
  - Text: "Used $X of $Y available"
  - Expiration/deadline information
  - Actions: "Upload Receipt" (placeholder), "View Details"
- Empty state (if no benefits): illustration + "Connect a Benefit" CTA + brief explanation

#### 3) Benefit Detail Page (for LSA)
- Card information section: full card visual, masked/unmasked with safe display behavior, expiration, provider, account number, activation status
- Spending overview: detailed breakdown, transaction history list, available balance
- Health/LSA info: terms, provider contact, key notes
- Learn More bottom sheet: searchable list of eligible expenses

---

### Data Model (Prototype-friendly)

Suggested minimal models to support MVP. Keep types simple, mockable, and serializable.

```dart
class Benefit {
  final String id;
  final String category; // e.g., "LSA", "HSA"
  final String providerName;
  final DateTime expirationDate;
  final String maskedCardNumber; // e.g., **** **** **** 1234
  final int last4; // 1234
  final bool isActive;

  const Benefit({
    required this.id,
    required this.category,
    required this.providerName,
    required this.expirationDate,
    required this.maskedCardNumber,
    required this.last4,
    required this.isActive,
  });
}

class LsaBenefit extends Benefit {
  final int planYear;
  final int centsAvailable;
  final int centsUsed;
  final List<BenefitTransaction> transactions;

  const LsaBenefit({
    required super.id,
    required super.category,
    required super.providerName,
    required super.expirationDate,
    required super.maskedCardNumber,
    required super.last4,
    required super.isActive,
    required this.planYear,
    required this.centsAvailable,
    required this.centsUsed,
    required this.transactions,
  });
}

class BenefitTransaction {
  final String id;
  final DateTime date;
  final String merchant;
  final int centsAmount; // negative for debit if needed
  final String status; // e.g., "posted", "pending"

  const BenefitTransaction({
    required this.id,
    required this.date,
    required this.merchant,
    required this.centsAmount,
    required this.status,
  });
}

class EligibleExpense {
  final String code; // simple ID
  final String title;
  final String description;
  final List<String> tags; // for search/filter

  const EligibleExpense({
    required this.code,
    required this.title,
    required this.description,
    required this.tags,
  });
}
```

Optional mock JSON shape (assets or inline):
```json
{
  "benefits": [
    {
      "type": "LSA",
      "id": "lsa-1",
      "providerName": "Acme Benefits",
      "expirationDate": "2026-12-31",
      "last4": 1234,
      "maskedCardNumber": "**** **** **** 1234",
      "isActive": true,
      "planYear": 2025,
      "centsAvailable": 150000,
      "centsUsed": 45000,
      "transactions": [
        {
          "id": "t1",
          "date": "2025-09-01",
          "merchant": "Pharmacy Co",
          "centsAmount": -2500,
          "status": "posted"
        }
      ]
    }
  ],
  "eligibleExpenses": [
    {
      "code": "EE-001",
      "title": "Eligible OTC meds",
      "description": "Certain over-the-counter medications are eligible...",
      "tags": ["lsa", "otc", "medical"]
    }
  ]
}
```

---

### UI Components (Leverage existing design system)
- BenefitSummaryCard (homepage)
- BenefitCategoryChips / Filters (stub for MVP)
- BenefitCard (LSA aesthetic, actions area)
- Progress visualization (linear or radial; start with linear for simplicity)
- EmptyState (illustration + CTA)
- BenefitDetailPage (sections: CardInfo, SpendingOverview, HealthInfo)
- EligibleExpensesSheet (modal bottom sheet with search)

Styling should follow the app theme and any shared components from `bf_design_system` where applicable.

---

### Implementation Plan (MVP)

1) Data & State
- Start with local mock data (hardcoded or JSON in assets). Keep API surfaces stable for future integration.
- Introduce a simple `BenefitsRepository` (mock) that returns LSA data and eligible expenses.
- Expose state via existing `state/app_state.dart` patterns (e.g., `ChangeNotifier` or similar) to avoid introducing a new state library for MVP.

2) Navigation
- Add a Benefits tab if not present; ensure homepage summary CTA navigates to it.
- Define routes: `benefits/` (tab), `benefits/detail/:id`.

3) Screens & Widgets
- Homepage: `BenefitSummaryCard` with total balance, last transaction, CTA
- Benefits Tab: header, optional category filters (non-functional or basic), LSA `BenefitCard`
- Detail Page: render card info, balances, transactions, and an action to open `EligibleExpensesSheet`
- Bottom Sheet: searchable list with simple in-memory filtering by title/description/tags

4) Search (Bottom Sheet)
- Implement a text field with debounce (optional) and local filtering over the `eligibleExpenses` list.
- Consider highlighting matches minimally (optional for MVP).

5) Accessibility
- Ensure sufficient contrast, scalable text, semantic roles for buttons/cards, and readable tap targets.

6) Analytics (Prototype)
- Track events (log only) for: open benefits tab, view detail, open/submit search in Learn More, tap upload receipt.

---

### Acceptance Criteria (MVP)
- Homepage shows a Benefits summary card with balance, recent activity, and a Manage CTA
- Benefits tab lists the LSA card with masked number, provider, expiration, progress bar, and usage text
- Actions below card: Upload Receipt (placeholder), View Details (navigates)
- Detail page displays card info, spending overview, transactions list, provider info
- Learn More bottom sheet opens from detail page; search filters eligible expenses results
- Empty state appears when no benefits are available with a "Connect a Benefit" CTA
- Layout responsive and accessible on common device sizes

---

### Future Phases
- Multiple benefits, richer filtering/sorting, real integrations and real-time updates
- Enhanced receipt upload (image picker, OCR, submission tracking)
- Notifications: low balance, expiring benefits, action-required receipts
- Provider integration (OAuth/token-based, webhook-driven updates)

---

### Risks & Mitigations
- Scope creep from multiple benefit types → Keep interfaces generic but ship LSA-first
- Visual complexity of card design → Start with a clean, simplified card and iterate
- Search performance for large lists → MVP is local/in-memory; optimize later

---

### Open Questions
- What exact card visual treatments should match brand (shadows, gradients, emboss)?
- Should homepage total include all benefits or LSA only in MVP?
- How should masking be toggled (always masked vs. tap-to-reveal with security affordance)?
- Do we need multiple plan years or rollover logic in MVP?

---

### Quick Dev Checklist
- [ ] Repository and model stubs for benefits and eligible expenses
- [ ] Homepage `BenefitSummaryCard` with CTA → Benefits tab
- [ ] Benefits tab page + `BenefitCard` with actions
- [ ] Detail page with sections + open Learn More sheet
- [ ] Searchable bottom sheet for eligible expenses
- [ ] Empty state UX
- [ ] Logging for basic analytics events (prototype)


