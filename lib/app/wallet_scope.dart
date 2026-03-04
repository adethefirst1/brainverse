import 'package:flutter/material.dart';

import '../shared/models/wallet_state.dart';
import 'wallet_storage.dart';

/// Provides [WalletState] and add/spend points. Persists via [WalletStorage].
class WalletScope extends InheritedWidget {
  const WalletScope({
    super.key,
    required this.wallet,
    required this.addPoints,
    required this.spendPoints,
    required super.child,
  });

  final WalletState wallet;
  final void Function(String reason, int amount) addPoints;
  final void Function(String reason, int amount) spendPoints;

  static WalletScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<WalletScope>();
    assert(scope != null, 'No WalletScope found.');
    return scope!;
  }

  static WalletScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WalletScope>();
  }

  @override
  bool updateShouldNotify(WalletScope oldWidget) => wallet != oldWidget.wallet;
}
