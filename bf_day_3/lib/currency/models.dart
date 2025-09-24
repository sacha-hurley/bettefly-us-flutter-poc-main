import 'dart:convert';

/// Currency domain models for BetterFlies (BFs)

/// Source of a BetterFly earning or spend event
enum BFSource { tourItem, manualEntry, wearableSync, bonus, redemption }

/// Transaction type: earned or spent (negative amount for spent)
enum BFTransactionType { earned, spent }

/// Represents a single BF transaction (earn or spend)
class BFTransaction {
  final String id;
  final int amount; // positive for earn, negative for spend
  final DateTime timestamp;
  final BFTransactionType type;
  final BFSource source;
  final String description;
  final String? actionId;

  const BFTransaction({
    required this.id,
    required this.amount,
    required this.timestamp,
    required this.type,
    required this.source,
    required this.description,
    this.actionId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
    'type': type.name,
    'source': source.name,
    'description': description,
    'actionId': actionId,
  };

  factory BFTransaction.fromJson(Map<String, dynamic> json) => BFTransaction(
    id: json['id'] as String,
    amount: json['amount'] as int,
    timestamp: DateTime.parse(json['timestamp'] as String),
    type: BFTransactionType.values.firstWhere(
      (e) => e.name == (json['type'] as String),
    ),
    source: BFSource.values.firstWhere(
      (e) => e.name == (json['source'] as String),
    ),
    description: json['description'] as String? ?? '',
    actionId: json['actionId'] as String?,
  );

  static String encodeList(List<BFTransaction> items) =>
      jsonEncode(items.map((t) => t.toJson()).toList());

  static List<BFTransaction> decodeList(String jsonStr) {
    final data = jsonDecode(jsonStr) as List<dynamic>;
    return data
        .map((e) => BFTransaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// Balance/value helpers
class BFBalance {
  final int totalBalance;
  final DateTime lastUpdated;
  final List<BFTransaction> recentTransactions;

  const BFBalance({
    required this.totalBalance,
    required this.lastUpdated,
    required this.recentTransactions,
  });
}

/// Milestone tiers as per PRD
enum MilestoneTier { explorer, champion, master, legend }

extension MilestoneTierThreshold on MilestoneTier {
  int get threshold {
    switch (this) {
      case MilestoneTier.explorer:
        return 0;
      case MilestoneTier.champion:
        return 1000;
      case MilestoneTier.master:
        return 5000;
      case MilestoneTier.legend:
        return 10000;
    }
  }

  static MilestoneTier fromBalance(int balance) {
    if (balance >= MilestoneTier.legend.threshold) return MilestoneTier.legend;
    if (balance >= MilestoneTier.master.threshold) return MilestoneTier.master;
    if (balance >= MilestoneTier.champion.threshold)
      return MilestoneTier.champion;
    return MilestoneTier.explorer;
  }

  static int toNextThreshold(int balance) {
    if (balance < MilestoneTier.champion.threshold)
      return MilestoneTier.champion.threshold;
    if (balance < MilestoneTier.master.threshold)
      return MilestoneTier.master.threshold;
    if (balance < MilestoneTier.legend.threshold)
      return MilestoneTier.legend.threshold;
    return MilestoneTier.legend.threshold; // already at or above legend
  }
}
