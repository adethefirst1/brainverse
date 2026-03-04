import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/game_setup_scope.dart';
import 'app/profile_storage.dart';
import 'app/wallet_storage.dart';
import 'shared/models/player_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await ProfileStorage.create();
  final profile = storage.loadProfile() ??
      PlayerProfile(
        username: 'Player',
        ageMode: AgeMode.adults,
        preferredCategory: 'General',
      );
  final walletStorage = await WalletStorage.create();
  final wallet = walletStorage.loadWallet();
  runApp(PuzzleGamesApp(
    storage: storage,
    initialProfile: profile,
    walletStorage: walletStorage,
    initialWallet: wallet,
  ));
}
