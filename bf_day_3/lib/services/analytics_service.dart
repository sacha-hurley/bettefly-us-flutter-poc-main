import 'dart:developer' as dev;

/// Lightweight analytics logger for the prototype.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  void logEvent(String name, {Map<String, Object?> parameters = const {}}) {
    dev.log('event=$name params=$parameters', name: 'analytics');
  }
}
