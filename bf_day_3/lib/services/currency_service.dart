import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../currency/models.dart';

/// CurrencyService - Singleton service for managing app currency
///
/// Features:
/// - Singleton pattern for global access
/// - Persistent storage using SharedPreferences
/// - Reactive updates via ValueNotifier
/// - Thread-safe operations
/// - Integration with existing app state
class CurrencyService extends ChangeNotifier {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  // Private fields
  static const String _kCurrencyKey = 'currency';
  static const String _kTransactionsKey = 'bf_transactions';

  int _currentCurrency = 300; // Default starting currency as per PRD
  bool _isLoaded = false;
  SharedPreferences? _prefs;

  // Transaction history (persisted)
  final List<BFTransaction> _transactions = <BFTransaction>[];

  // Optional callback to inform UI layers of an award event (for toasts)
  void Function(BFTransaction tx)? onAward;

  // Public getters
  int get currentCurrency => _currentCurrency;
  bool get isLoaded => _isLoaded;

  /// Lifetime total across all earned transactions (challenge and non-challenge)
  int get lifetimeTotalEarned {
    int sum = 0;
    for (final t in _transactions) {
      if (t.type == BFTransactionType.earned && t.amount > 0) {
        sum += t.amount;
      }
    }
    return sum;
  }

  // ValueNotifier for reactive UI updates
  ValueNotifier<int>? _currencyNotifier;
  ValueNotifier<int> get currencyNotifier {
    if (_currencyNotifier == null) {
      throw StateError(
        'CurrencyService not initialized. Call ensureLoaded() first.',
      );
    }
    return _currencyNotifier!;
  }

  /// Initialize the service - must be called before first use
  /// This loads the persisted currency value from storage
  Future<void> initialize() async {
    if (_isLoaded) return; // Already initialized

    try {
      _prefs = await SharedPreferences.getInstance();

      // Load transactions if present
      _loadTransactionsFromPrefs();

      if (_transactions.isNotEmpty) {
        // Compute balance from transactions if available
        _currentCurrency = _computeBalanceFromTransactions();
      } else {
        // Load persisted currency or use default
        _currentCurrency = _prefs?.getInt(_kCurrencyKey) ?? 300;
      }

      // Initialize the ValueNotifier
      _currencyNotifier = ValueNotifier<int>(_currentCurrency);

      _isLoaded = true;
      notifyListeners();

      debugPrint('CurrencyService initialized with $_currentCurrency currency');
    } catch (e) {
      debugPrint('Failed to initialize CurrencyService: $e');
      // Fall back to default values
      _currentCurrency = 300;
      _currencyNotifier = ValueNotifier<int>(_currentCurrency);
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Ensure the service is loaded - call this before accessing currency
  Future<void> ensureLoaded() async {
    if (!_isLoaded) {
      await initialize();
    }
  }

  /// Add currency to the current balance
  ///
  /// [amount] - The amount to add (must be positive)
  /// Returns the new currency balance
  Future<int> addCurrency(int amount) async {
    if (amount <= 0) {
      debugPrint('Warning: Attempted to add non-positive currency: $amount');
      return _currentCurrency;
    }

    await ensureLoaded();

    _currentCurrency += amount;
    await _persistCurrency();

    // Append a transaction for history
    final tx = BFTransaction(
      id: _generateId(),
      amount: amount,
      timestamp: DateTime.now(),
      type: BFTransactionType.earned,
      source: BFSource.manualEntry,
      description: 'Added via addCurrency()',
    );
    _transactions.add(tx);
    await _persistTransactions();
    try {
      onAward?.call(tx);
    } catch (_) {}

    // Update reactive notifier
    currencyNotifier.value = _currentCurrency;
    notifyListeners();

    debugPrint('Added $amount currency. New balance: $_currentCurrency');
    return _currentCurrency;
  }

  /// Subtract currency from the current balance
  ///
  /// [amount] - The amount to subtract (must be positive)
  /// [allowNegative] - Whether to allow negative balances (default: false)
  /// Returns the new currency balance, or null if insufficient funds
  Future<int?> subtractCurrency(
    int amount, {
    bool allowNegative = false,
  }) async {
    if (amount <= 0) {
      debugPrint(
        'Warning: Attempted to subtract non-positive currency: $amount',
      );
      return _currentCurrency;
    }

    await ensureLoaded();

    if (!allowNegative && _currentCurrency < amount) {
      debugPrint(
        'Insufficient currency. Current: $_currentCurrency, Requested: $amount',
      );
      return null; // Insufficient funds
    }

    _currentCurrency -= amount;
    await _persistCurrency();

    // Append a spend transaction (negative amount)
    final tx = BFTransaction(
      id: _generateId(),
      amount: -amount,
      timestamp: DateTime.now(),
      type: BFTransactionType.spent,
      source: BFSource.redemption,
      description: 'Subtracted via subtractCurrency()',
    );
    _transactions.add(tx);
    await _persistTransactions();

    // Update reactive notifier
    currencyNotifier.value = _currentCurrency;
    notifyListeners();

    debugPrint('Subtracted $amount currency. New balance: $_currentCurrency');
    return _currentCurrency;
  }

  /// Reset currency to the default amount (300)
  /// Useful for demo resets or testing
  Future<void> resetCurrency() async {
    await ensureLoaded();

    _currentCurrency = 300;
    await _persistCurrency();

    // Update reactive notifier
    currencyNotifier.value = _currentCurrency;
    notifyListeners();

    debugPrint('Currency reset to default: $_currentCurrency');
  }

  /// Set currency to a specific amount
  ///
  /// [amount] - The new currency amount
  /// [allowNegative] - Whether to allow negative amounts (default: false)
  Future<bool> setCurrency(int amount, {bool allowNegative = false}) async {
    if (!allowNegative && amount < 0) {
      debugPrint('Warning: Attempted to set negative currency: $amount');
      return false;
    }

    await ensureLoaded();

    _currentCurrency = amount;
    await _persistCurrency();

    // Update reactive notifier
    currencyNotifier.value = _currentCurrency;
    notifyListeners();

    debugPrint('Currency set to: $_currentCurrency');
    return true;
  }

  /// Persist the current currency value to storage
  Future<void> _persistCurrency() async {
    try {
      await _prefs?.setInt(_kCurrencyKey, _currentCurrency);
    } catch (e) {
      debugPrint('Failed to persist currency: $e');
    }
  }

  /// Persist transactions to storage
  Future<void> _persistTransactions() async {
    try {
      final jsonStr = BFTransaction.encodeList(_transactions);
      await _prefs?.setString(_kTransactionsKey, jsonStr);
    } catch (e) {
      debugPrint('Failed to persist transactions: $e');
    }
  }

  /// Load transactions from storage
  void _loadTransactionsFromPrefs() {
    try {
      final jsonStr = _prefs?.getString(_kTransactionsKey);
      if (jsonStr == null || jsonStr.isEmpty) return;
      final items = BFTransaction.decodeList(jsonStr);
      _transactions
        ..clear()
        ..addAll(items);
    } catch (e) {
      debugPrint('Failed to load transactions: $e');
      _transactions.clear();
    }
  }

  int _computeBalanceFromTransactions() {
    var total = 0;
    for (final t in _transactions) {
      total += t.amount;
    }
    return total;
  }

  /// Get BF transaction history
  List<BFTransaction> getTransactionHistory() =>
      List.unmodifiable(_transactions);

  /// Award BetterFlies with metadata, creating a transaction and updating balance
  Future<BFTransaction> awardBetterFlies({
    required int amount,
    BFSource source = BFSource.manualEntry,
    String description = '',
    String? actionId,
  }) async {
    if (amount <= 0) throw ArgumentError('amount must be positive');
    await ensureLoaded();
    _currentCurrency += amount;
    final tx = BFTransaction(
      id: _generateId(),
      amount: amount,
      timestamp: DateTime.now(),
      type: BFTransactionType.earned,
      source: source,
      description: description,
      actionId: actionId,
    );
    _transactions.add(tx);
    await _persistCurrency();
    await _persistTransactions();
    currencyNotifier.value = _currentCurrency;
    notifyListeners();
    try {
      onAward?.call(tx);
    } catch (_) {}
    return tx;
  }

  /// Spend BetterFlies, returns the created transaction or null if insufficient
  Future<BFTransaction?> spendBetterFlies({
    required int amount,
    String description = '',
    bool allowNegative = false,
  }) async {
    if (amount <= 0) throw ArgumentError('amount must be positive');
    await ensureLoaded();
    if (!allowNegative && _currentCurrency < amount) return null;
    _currentCurrency -= amount;
    final tx = BFTransaction(
      id: _generateId(),
      amount: -amount,
      timestamp: DateTime.now(),
      type: BFTransactionType.spent,
      source: BFSource.redemption,
      description: description,
    );
    _transactions.add(tx);
    await _persistCurrency();
    await _persistTransactions();
    currencyNotifier.value = _currentCurrency;
    notifyListeners();
    return tx;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}';

  @override
  void dispose() {
    _currencyNotifier?.dispose();
    super.dispose();
  }
}

/// Represents a currency transaction for future transaction history feature
class CurrencyTransaction {
  final int amount;
  final String description;
  final DateTime timestamp;
  final CurrencyTransactionType type;

  const CurrencyTransaction({
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}

enum CurrencyTransactionType { earned, spent, reset }

/// Extension on the existing AppState to integrate currency service
/// This allows the existing app state to work with the new currency system
extension AppStateCurrencyIntegration on ChangeNotifier {
  /// Helper method to award currency for completing tasks
  /// This can be called from existing task completion methods
  Future<void> awardCurrency(int amount, String reason) async {
    await CurrencyService().addCurrency(amount);
    debugPrint('Awarded $amount currency for: $reason');
  }
}
