import 'package:flutter/material.dart';

import 'game_setup_scope.dart';
import 'profile_scope.dart';
import 'profile_storage.dart';
import 'wallet_scope.dart';
import 'wallet_storage.dart';
import '../features/home/home_screen.dart';
import '../shared/models/player_profile.dart';
import '../shared/models/wallet_state.dart';

class PuzzleGamesApp extends StatefulWidget {
  const PuzzleGamesApp({
    super.key,
    required this.storage,
    required this.initialProfile,
    required this.walletStorage,
    required this.initialWallet,
  });

  final ProfileStorage storage;
  final PlayerProfile initialProfile;
  final WalletStorage walletStorage;
  final WalletState initialWallet;

  @override
  State<PuzzleGamesApp> createState() => _PuzzleGamesAppState();
}

class _PuzzleGamesAppState extends State<PuzzleGamesApp> {
  GameSetupData _gameSetupData = GameSetupData(
    category: 'General',
    ageMode: AgeMode.adults,
  );

  late PlayerProfile _profile;
  late WalletState _wallet;

  @override
  void initState() {
    super.initState();
    _profile = widget.initialProfile;
    _wallet = widget.initialWallet;
  }

  void _updateGameSetup(GameSetupData data) {
    setState(() => _gameSetupData = data);
  }

  void _saveProfile(PlayerProfile profile) {
    widget.storage.saveProfile(profile);
    setState(() => _profile = profile);
  }

  void _addPoints(String reason, int amount) {
    if (amount <= 0) return;
    final tx = WalletTransaction(reason: reason, amount: amount, isCredit: true);
    final next = WalletState(
      pointsBalance: _wallet.pointsBalance + amount,
      transactions: [..._wallet.transactions, tx],
    );
    widget.walletStorage.saveWallet(next);
    setState(() => _wallet = next);
  }

  void _spendPoints(String reason, int amount) {
    if (amount <= 0) return;
    final balance = _wallet.pointsBalance - amount;
    final tx = WalletTransaction(reason: reason, amount: amount, isCredit: false);
    final next = WalletState(
      pointsBalance: balance.clamp(0, 0x7fffffff),
      transactions: [..._wallet.transactions, tx],
    );
    widget.walletStorage.saveWallet(next);
    setState(() => _wallet = next);
  }

  @override
  Widget build(BuildContext context) {
    return GameSetupScope(
      data: _gameSetupData,
      onUpdate: _updateGameSetup,
      child: ProfileScope(
        profile: _profile,
        saveProfile: _saveProfile,
        child: WalletScope(
          wallet: _wallet,
          addPoints: _addPoints,
          spendPoints: _spendPoints,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
              ),
            ),
            home: const HomeScreen(),
          ),
        ),
      ),
    );
  }
}

