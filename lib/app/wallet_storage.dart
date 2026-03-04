import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../shared/models/wallet_state.dart';

const String _keyWallet = 'wallet_state';

/// Loads and saves [WalletState] using SharedPreferences.
class WalletStorage {
  WalletStorage(this._prefs);

  final SharedPreferences _prefs;

  static Future<WalletStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return WalletStorage(prefs);
  }

  WalletState loadWallet() {
    final json = _prefs.getString(_keyWallet);
    if (json == null) return const WalletState();
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return WalletState.fromJson(map);
    } catch (_) {
      return const WalletState();
    }
  }

  Future<void> saveWallet(WalletState wallet) async {
    await _prefs.setString(_keyWallet, jsonEncode(wallet.toJson()));
  }
}
