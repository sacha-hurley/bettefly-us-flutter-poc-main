import 'package:flutter/foundation.dart';

/// Base model for any employee benefit.
@immutable
class Benefit {
  final String id;
  final String category; // e.g., "LSA", "HSA"
  final String providerName;
  final DateTime expirationDate;
  final String maskedCardNumber; // e.g., **** **** **** 1234
  final int last4; // e.g., 1234
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

/// LSA-specific benefit with balance and transactions.
@immutable
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

  double get availableDollars => centsAvailable / 100.0;
  double get usedDollars => centsUsed / 100.0;
  double get totalDollars => (centsAvailable + centsUsed) / 100.0;
  double get usedFraction => totalDollars == 0 ? 0 : usedDollars / totalDollars;
}

/// Transaction associated with a benefit account.
@immutable
class BenefitTransaction {
  final String id;
  final DateTime date;
  final String merchant;
  final int centsAmount; // negative for debit
  final String status; // e.g., posted, pending

  const BenefitTransaction({
    required this.id,
    required this.date,
    required this.merchant,
    required this.centsAmount,
    required this.status,
  });
}

/// Eligible expense entry for Learn More search.
@immutable
class EligibleExpense {
  final String code;
  final String title;
  final String description;
  final List<String> tags;

  const EligibleExpense({
    required this.code,
    required this.title,
    required this.description,
    required this.tags,
  });
}
