import 'package:flutter/material.dart';

/// Age mode shown in the setup screen and stored in app state.
enum AgeMode {
  kids('Kids (5–12)', 5, 12),
  teens('Teens (13–17)', 13, 17),
  adults('Adults (18+)', 18, 99);

  const AgeMode(this.label, this.minAge, this.maxAge);
  final String label;
  final int minAge;
  final int maxAge;
}

/// Category and age selection saved when user continues from setup.
class GameSetupData {
  const GameSetupData({
    required this.category,
    required this.ageMode,
  });

  final String category;
  final AgeMode ageMode;

  GameSetupData copyWith({String? category, AgeMode? ageMode}) {
    return GameSetupData(
      category: category ?? this.category,
      ageMode: ageMode ?? this.ageMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSetupData &&
          category == other.category &&
          ageMode == other.ageMode;

  @override
  int get hashCode => Object.hash(category, ageMode);
}

/// Provides [GameSetupData] and a way to update it above the widget tree.
class GameSetupScope extends InheritedWidget {
  const GameSetupScope({
    super.key,
    required this.data,
    required this.onUpdate,
    required super.child,
  });

  final GameSetupData data;
  final void Function(GameSetupData) onUpdate;

  static GameSetupScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GameSetupScope>();
    assert(scope != null, 'No GameSetupScope found. Wrap app with GameSetupScope.');
    return scope!;
  }

  static GameSetupScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GameSetupScope>();
  }

  @override
  bool updateShouldNotify(GameSetupScope oldWidget) {
    return data != oldWidget.data;
  }
}
