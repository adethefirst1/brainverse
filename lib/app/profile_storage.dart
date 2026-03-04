import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../shared/models/player_profile.dart';

const String _keyProfile = 'player_profile';

/// Loads and saves [PlayerProfile] using SharedPreferences.
class ProfileStorage {
  ProfileStorage(this._prefs);

  final SharedPreferences _prefs;

  static Future<ProfileStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ProfileStorage(prefs);
  }

  PlayerProfile? loadProfile() {
    final json = _prefs.getString(_keyProfile);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return PlayerProfile.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(PlayerProfile profile) async {
    await _prefs.setString(_keyProfile, jsonEncode(profile.toJson()));
  }
}
