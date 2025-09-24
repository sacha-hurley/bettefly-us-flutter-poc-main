import 'package:health/health.dart';

/// HealthService encapsulates HealthKit (via `health` package) interactions.
///
/// MVP scope: permissions and "today" aggregates for steps, heart rate, active energy.
class HealthService {
  HealthService() : _health = Health();

  final Health _health;

  /// Requests authorization for the MVP data types.
  Future<bool> requestMvpAuthorization() async {
    final types = <HealthDataType>{
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    };
    return _health.requestAuthorization(types.toList());
  }

  /// Returns start-of-day for the device-local timezone.
  DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Fetches total steps for today.
  Future<num?> fetchTodaySteps() async {
    final total = await _health.getTotalStepsInInterval(
      todayStart,
      DateTime.now(),
    );
    return total;
  }

  /// Fetches average heart rate for today (beats per minute).
  Future<double?> fetchTodayAvgHeartRate() async {
    // Placeholder: will implement numeric aggregation using health package values
    // once UI wiring is ready. Returning null keeps API stable for now.
    return null;
  }

  /// Fetches active energy burned (kcal) for today.
  Future<double?> fetchTodayActiveEnergy() async {
    // Placeholder: will implement numeric aggregation using health package values
    // once UI wiring is ready. Returning null keeps API stable for now.
    return null;
  }
}
