import '../../app/game_setup_scope.dart';

/// Player profile with optional local persistence.
class PlayerProfile {
  const PlayerProfile({
    required this.username,
    this.avatar = '',
    this.country = '',
    required this.ageMode,
    required this.preferredCategory,
  });

  final String username;
  /// Asset path or empty string for placeholder.
  final String avatar;
  final String country;
  final AgeMode ageMode;
  final String preferredCategory;

  static const String _keyUsername = 'username';
  static const String _keyAvatar = 'avatar';
  static const String _keyCountry = 'country';
  static const String _keyAgeMode = 'ageMode';
  static const String _keyPreferredCategory = 'preferredCategory';

  Map<String, dynamic> toJson() => {
        _keyUsername: username,
        _keyAvatar: avatar,
        _keyCountry: country,
        _keyAgeMode: ageMode.name,
        _keyPreferredCategory: preferredCategory,
      };

  static PlayerProfile fromJson(Map<String, dynamic> json) {
    final ageName = json[_keyAgeMode] as String?;
    AgeMode age = AgeMode.adults;
    for (final e in AgeMode.values) {
      if (e.name == ageName) {
        age = e;
        break;
      }
    }
    return PlayerProfile(
      username: json[_keyUsername] as String? ?? 'Player',
      avatar: json[_keyAvatar] as String? ?? '',
      country: json[_keyCountry] as String? ?? '',
      ageMode: age,
      preferredCategory: json[_keyPreferredCategory] as String? ?? 'General',
    );
  }

  PlayerProfile copyWith({
    String? username,
    String? avatar,
    String? country,
    AgeMode? ageMode,
    String? preferredCategory,
  }) {
    return PlayerProfile(
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      country: country ?? this.country,
      ageMode: ageMode ?? this.ageMode,
      preferredCategory: preferredCategory ?? this.preferredCategory,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerProfile &&
          username == other.username &&
          avatar == other.avatar &&
          country == other.country &&
          ageMode == other.ageMode &&
          preferredCategory == other.preferredCategory;

  @override
  int get hashCode =>
      Object.hash(username, avatar, country, ageMode, preferredCategory);
}
