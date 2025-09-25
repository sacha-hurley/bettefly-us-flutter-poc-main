import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../currency/models.dart';

class LsaCreditEvent {
  final double amount;
  final DateTime date;
  final String memo;

  LsaCreditEvent({
    required this.amount,
    required this.date,
    required this.memo,
  });
}

class AppState extends ChangeNotifier {
  String userName = 'Sarah';
  int earningStreak = 3;

  bool reviewHealth = false;
  bool joinChallenge = false;
  bool completeChallenge = false;
  bool browseBenefits = false;

  double lsaBalance = 248.0;
  String lsaRecentTransaction = '+\$25 receipt approved';
  List<LsaCreditEvent> lsaCredits = [];

  int yesterdaySteps = 9247;
  String yesterdaySleep = '7h 32m';
  int yesterdayActiveMinutes = 45;

  bool hasJoinedCompany = false;
  int currentSteps = 1247;
  int dailyGoal = 8000;
  int companyGoal = 10000;

  void completeHealthReview() {
    reviewHealth = true;
    // Route reward through BetterFlies currency service
    // Award a small bonus for completing the health review task
    CurrencyService().awardBetterFlies(
      amount: 25,
      source: BFSource.bonus,
      description: 'Reviewed health dashboard',
    );
    notifyListeners();
  }

  void joinCompanyChallenge() {
    joinChallenge = true;
    hasJoinedCompany = true;
    // Award BetterFlies for opting into the company challenge
    CurrencyService().awardBetterFlies(
      amount: 25,
      source: BFSource.bonus,
      description: 'Joined company challenge',
    );
    notifyListeners();
  }

  void completeFirstChallenge() {
    if (!joinChallenge) return;
    completeChallenge = true;
    // Award BetterFlies for completing the first challenge CTA
    CurrencyService().awardBetterFlies(
      amount: 50,
      source: BFSource.bonus,
      description: 'Completed first challenge',
    );
    notifyListeners();
  }

  void completeBenefitsBrowsing() {
    browseBenefits = true;
    notifyListeners();
  }

  void reset() {
    userName = 'Sarah';
    earningStreak = 3;

    reviewHealth = false;
    joinChallenge = false;
    completeChallenge = false;
    browseBenefits = false;

    lsaBalance = 248.0;
    lsaRecentTransaction = '+\$25 receipt approved';
    lsaCredits = [];

    yesterdaySteps = 9247;
    yesterdaySleep = '7h 32m';
    yesterdayActiveMinutes = 45;

    hasJoinedCompany = false;
    currentSteps = 1247;
    dailyGoal = 8000;
    companyGoal = 10000;

    notifyListeners();
  }

  // Simple credit for LSA (prototype). In a full app this would
  // be its own service with persistence and transaction history.
  void creditLsa(double amount, {String memo = 'BF redemption'}) {
    if (amount <= 0) return;
    lsaBalance += amount;
    lsaRecentTransaction = '+\$${amount.toStringAsFixed(2)} $memo';
    lsaCredits.add(
      LsaCreditEvent(amount: amount, date: DateTime.now(), memo: memo),
    );
    notifyListeners();
  }
}
