import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String userName = 'Sarah';
  int coins = 350;
  int earningStreak = 3;

  bool reviewHealth = false;
  bool joinChallenge = false;
  bool completeChallenge = false;
  bool browseBenefits = false;

  double lsaBalance = 247.50;
  String lsaRecentTransaction = '+\$25 receipt approved';

  int yesterdaySteps = 9247;
  String yesterdaySleep = '7h 32m';
  int yesterdayActiveMinutes = 45;

  bool hasJoinedCompany = false;
  int currentSteps = 1247;
  int dailyGoal = 8000;
  int companyGoal = 10000;

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
    if (!joinChallenge) return;
    completeChallenge = true;
    coins += 50;
    notifyListeners();
  }

  void completeBenefitsBrowsing() {
    browseBenefits = true;
    notifyListeners();
  }

  void reset() {
    userName = 'Sarah';
    coins = 350;
    earningStreak = 3;

    reviewHealth = false;
    joinChallenge = false;
    completeChallenge = false;
    browseBenefits = false;

    lsaBalance = 247.50;
    lsaRecentTransaction = '+\$25 receipt approved';

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
    notifyListeners();
  }
}


