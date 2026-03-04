/// A single wallet transaction (credit or debit).
class WalletTransaction {
  WalletTransaction({
    required this.reason,
    required this.amount,
    required this.isCredit,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String reason;
  final int amount;
  final bool isCredit;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'reason': reason,
        'amount': amount,
        'isCredit': isCredit,
        'timestamp': timestamp.toIso8601String(),
      };

  static WalletTransaction fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      reason: json['reason'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      isCredit: json['isCredit'] as bool? ?? true,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletTransaction &&
          reason == other.reason &&
          amount == other.amount &&
          isCredit == other.isCredit;

  @override
  int get hashCode => Object.hash(reason, amount, isCredit);
}

/// Wallet state: balance and transaction history.
class WalletState {
  const WalletState({
    this.pointsBalance = 0,
    this.transactions = const [],
  });

  final int pointsBalance;
  final List<WalletTransaction> transactions;

  WalletState copyWith({
    int? pointsBalance,
    List<WalletTransaction>? transactions,
  }) {
    return WalletState(
      pointsBalance: pointsBalance ?? this.pointsBalance,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() => {
        'pointsBalance': pointsBalance,
        'transactions': transactions.map((t) => t.toJson()).toList(),
      };

  static WalletState fromJson(Map<String, dynamic> json) {
    final list = json['transactions'];
    return WalletState(
      pointsBalance: json['pointsBalance'] as int? ?? 0,
      transactions: list is List
          ? list.map((e) => WalletTransaction.fromJson(Map<String, dynamic>.from(e as Map))).toList()
          : [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletState &&
          pointsBalance == other.pointsBalance &&
          transactions.length == other.transactions.length;

  @override
  int get hashCode => Object.hash(pointsBalance, transactions.length);
}
