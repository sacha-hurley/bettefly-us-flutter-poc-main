import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../currency/models.dart';
import 'currency_service.dart';

/// ChallengeService - minimal scaffold for Social Page challenges
/// - Evergreen daily challenge: default 10,000 steps
/// - Monthly company challenge: opt-in flag only (progress counters placeholders)
/// - Persistence via SharedPreferences
class ChallengeService extends ChangeNotifier {
  static final ChallengeService _instance = ChallengeService._internal();
  factory ChallengeService() => _instance;
  ChallengeService._internal();

  static const String _kOptInKey = 'challenge_opt_in';
  static const String _kDailyCompletionsKey = 'challenge_daily_count_week';
  static const String _kWeeklyCompletionsKey = 'challenge_weekly_count_month';
  static const String _kLastDailyDateKey = 'challenge_last_daily_date';
  static const String _kDailyTargetKey = 'challenge_daily_steps_target';

  SharedPreferences? _prefs;
  bool _loaded = false;

  bool _optedIn = false;
  int _dailyCompletionsThisWeek = 0;
  int _weeklyCompletionsThisMonth = 0;
  DateTime? _lastDailyCompletionDate;
  int _dailyStepTarget = 10000; // default per PRD

  bool get isLoaded => _loaded;
  bool get isOptedIn => _optedIn;
  int get dailyCompletionsThisWeek => _dailyCompletionsThisWeek;
  int get weeklyCompletionsThisMonth => _weeklyCompletionsThisMonth;
  DateTime? get lastDailyCompletionDate => _lastDailyCompletionDate;
  int get dailyStepTarget => _dailyStepTarget;

  Future<void> initialize() async {
    if (_loaded) return;
    _prefs = await SharedPreferences.getInstance();
    _optedIn = _prefs?.getBool(_kOptInKey) ?? false;
    _dailyCompletionsThisWeek = _prefs?.getInt(_kDailyCompletionsKey) ?? 0;
    _weeklyCompletionsThisMonth = _prefs?.getInt(_kWeeklyCompletionsKey) ?? 0;
    final last = _prefs?.getString(_kLastDailyDateKey);
    _lastDailyCompletionDate = last != null ? DateTime.tryParse(last) : null;
    _dailyStepTarget = _prefs?.getInt(_kDailyTargetKey) ?? 10000;
    _loaded = true;
    notifyListeners();
  }

  Future<void> ensureLoaded() async {
    if (!_loaded) await initialize();
  }

  Future<void> optIn() async {
    await ensureLoaded();
    _optedIn = true;
    await _prefs?.setBool(_kOptInKey, true);
    notifyListeners();
  }

  /// Set the evergreen daily steps target (kept configurable)
  Future<void> setDailyStepTarget(int steps) async {
    await ensureLoaded();
    _dailyStepTarget = steps;
    await _prefs?.setInt(_kDailyTargetKey, steps);
    notifyListeners();
  }

  /// Idempotent daily completion based on calendar day. Awards 100 Better Flies once per day.
  /// Returns true if award granted today.
  Future<bool> completeDailyIfEligible({required int currentSteps}) async {
    await ensureLoaded();
    if (!_optedIn) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = _lastDailyCompletionDate == null
        ? null
        : DateTime(
            _lastDailyCompletionDate!.year,
            _lastDailyCompletionDate!.month,
            _lastDailyCompletionDate!.day,
          );

    if (last == today) return false; // already completed today
    if (currentSteps < _dailyStepTarget) return false; // not yet reached target

    // Award daily challenge
    await CurrencyService().awardBetterFlies(
      amount: 100,
      source: BFSource.challengeDaily,
      description: 'Daily challenge completed',
      actionId: 'daily-${today.toIso8601String()}',
    );

    _lastDailyCompletionDate = today;
    await _prefs?.setString(_kLastDailyDateKey, today.toIso8601String());

    // Increment weekly counter; reset when week changes (simplified: Mon-Sun)
    final weekday = today.weekday; // 1=Mon..7=Sun
    if (weekday == DateTime.monday &&
        _lastDailyCompletionDate != null &&
        _lastDailyCompletionDate != today) {
      // New week boundary heuristic; for robustness we could store week number
      _dailyCompletionsThisWeek = 0;
    }
    _dailyCompletionsThisWeek += 1;
    await _prefs?.setInt(_kDailyCompletionsKey, _dailyCompletionsThisWeek);

    // Award weekly if threshold reached (5 daily completions)
    if (_dailyCompletionsThisWeek >= 5) {
      _dailyCompletionsThisWeek = 0;
      _weeklyCompletionsThisMonth += 1;
      await _prefs?.setInt(_kDailyCompletionsKey, _dailyCompletionsThisWeek);
      await _prefs?.setInt(_kWeeklyCompletionsKey, _weeklyCompletionsThisMonth);

      await CurrencyService().awardBetterFlies(
        amount: 500,
        source: BFSource.challengeWeekly,
        description: 'Weekly challenge completed',
      );

      // Award monthly if weekly threshold reached (4 weeks)
      if (_weeklyCompletionsThisMonth >= 4) {
        _weeklyCompletionsThisMonth = 0;
        await _prefs?.setInt(
          _kWeeklyCompletionsKey,
          _weeklyCompletionsThisMonth,
        );
        await CurrencyService().awardBetterFlies(
          amount: 1000,
          source: BFSource.challengeMonthly,
          description: 'Monthly challenge completed',
        );
      }
    }

    notifyListeners();
    return true;
  }
}
