import 'dart:async';
import 'models.dart';

/// Mock repository for Benefits data used in the prototype.
class BenefitsRepository {
  static final BenefitsRepository _instance = BenefitsRepository._internal();
  factory BenefitsRepository() => _instance;
  BenefitsRepository._internal();

  /// Return a single LSA benefit for MVP.
  Future<LsaBenefit> fetchLsaBenefit() async {
    // Simulate a small delay like a network call
    await Future<void>.delayed(const Duration(milliseconds: 150));

    return LsaBenefit(
      id: 'lsa-1',
      category: 'LSA',
      providerName: 'Acme Benefits',
      expirationDate: DateTime(DateTime.now().year + 1, 12, 31),
      maskedCardNumber: '**** **** **** 1234',
      last4: 1234,
      isActive: true,
      planYear: DateTime.now().year,
      centsAvailable: 150000, // $1,500 available
      centsUsed: 45000, // $450 used
      transactions: [
        BenefitTransaction(
          id: 't1',
          date: DateTime.now().subtract(const Duration(days: 3)),
          merchant: 'Pharmacy Co',
          centsAmount: -2500,
          status: 'posted',
        ),
        BenefitTransaction(
          id: 't2',
          date: DateTime.now().subtract(const Duration(days: 10)),
          merchant: 'Wellness Gym',
          centsAmount: -7500,
          status: 'posted',
        ),
      ],
    );
  }

  /// Mock eligible expenses list for Learn More search.
  Future<List<EligibleExpense>> fetchEligibleExpenses() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _eligibleExpensesData;
  }

  /// Simple, case-insensitive in-memory search across title, description, tags, and code.
  Future<List<EligibleExpense>> searchEligibleExpenses(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _eligibleExpensesData;
    return _eligibleExpensesData
        .where((e) {
          final inTitle = e.title.toLowerCase().contains(q);
          final inDesc = e.description.toLowerCase().contains(q);
          final inCode = e.code.toLowerCase().contains(q);
          final inTags = e.tags.any((t) => t.toLowerCase().contains(q));
          return inTitle || inDesc || inCode || inTags;
        })
        .toList(growable: false);
  }

  // --- Mock dataset ---
  static const List<EligibleExpense> _eligibleExpensesData = [
    EligibleExpense(
      code: 'EE-001',
      title: 'Over-the-counter medications',
      description:
          'Certain OTC medications are reimbursable when medically necessary.',
      tags: ['lsa', 'otc', 'medical'],
    ),
    EligibleExpense(
      code: 'EE-002',
      title: 'Gym memberships',
      description: 'Monthly fitness center dues for eligible plans.',
      tags: ['fitness', 'gym', 'wellness'],
    ),
    EligibleExpense(
      code: 'EE-003',
      title: 'Therapy sessions',
      description: 'Licensed counseling and therapy visits.',
      tags: ['mental health', 'therapy'],
    ),
    EligibleExpense(
      code: 'EE-004',
      title: 'Personal training',
      description: 'One-on-one sessions with certified trainers.',
      tags: ['fitness', 'training'],
    ),
    EligibleExpense(
      code: 'EE-005',
      title: 'Massage therapy',
      description: 'Therapeutic massage with licensed professionals.',
      tags: ['recovery', 'wellness', 'massage'],
    ),
    EligibleExpense(
      code: 'EE-006',
      title: 'Vision care',
      description: 'Glasses, contacts, and routine vision exams.',
      tags: ['vision', 'optometry'],
    ),
    EligibleExpense(
      code: 'EE-007',
      title: 'Nutrition consultations',
      description: 'Sessions with licensed nutritionists/dietitians.',
      tags: ['nutrition', 'diet', 'health'],
    ),
    EligibleExpense(
      code: 'EE-008',
      title: 'Meditation apps',
      description: 'Subscriptions to eligible mindfulness applications.',
      tags: ['mindfulness', 'app', 'subscription'],
    ),
    EligibleExpense(
      code: 'EE-009',
      title: 'Wellness workshops',
      description: 'Group classes and seminars focused on health topics.',
      tags: ['workshop', 'learning', 'wellness'],
    ),
    EligibleExpense(
      code: 'EE-010',
      title: 'Annual physicals',
      description: 'Routine preventive care visits.',
      tags: ['preventive', 'medical'],
    ),
  ];
}
