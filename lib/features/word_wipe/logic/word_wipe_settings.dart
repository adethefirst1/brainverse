import '../../../app/game_setup_scope.dart';

class WordWipeSettings {
  const WordWipeSettings({
    required this.gridSize,
    required this.minWordLength,
  });

  final int gridSize;
  final int minWordLength;
}

extension AgeModeWordWipe on AgeMode {
  WordWipeSettings get wordWipeSettings {
    switch (this) {
      case AgeMode.kids:
        return const WordWipeSettings(gridSize: 6, minWordLength: 3);
      case AgeMode.teens:
        return const WordWipeSettings(gridSize: 7, minWordLength: 4);
      case AgeMode.adults:
        return const WordWipeSettings(gridSize: 8, minWordLength: 5);
    }
  }
}
