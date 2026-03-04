import 'package:flutter/material.dart';

import '../shared/models/player_profile.dart';
import 'profile_storage.dart';

/// Provides current [PlayerProfile] and a way to save it (persists via [ProfileStorage]).
class ProfileScope extends InheritedWidget {
  const ProfileScope({
    super.key,
    required this.profile,
    required this.saveProfile,
    required super.child,
  });

  final PlayerProfile profile;
  final void Function(PlayerProfile) saveProfile;

  static ProfileScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProfileScope>();
    assert(scope != null, 'No ProfileScope found.');
    return scope!;
  }

  static ProfileScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProfileScope>();
  }

  @override
  bool updateShouldNotify(ProfileScope oldWidget) => profile != oldWidget.profile;
}
