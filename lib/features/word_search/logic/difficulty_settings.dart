import '../../../app/game_setup_scope.dart';

class DifficultySettings {
  final int gridSize;
  final int wordCount;
  final bool allowDiagonal;
  final bool allowBackward;
  final int minWordLength;
  final int maxWordLength;

  const DifficultySettings({
    required this.gridSize,
    required this.wordCount,
    required this.allowDiagonal,
    required this.allowBackward,
    required this.minWordLength,
    required this.maxWordLength,
  });
}

extension AgeModeDifficulty on AgeMode {
  DifficultySettings get wordSearchSettings {
    switch (this) {
      case AgeMode.kids:
        return const DifficultySettings(
          gridSize: 8,
          wordCount: 6,
          allowDiagonal: false,
          allowBackward: false,
          minWordLength: 3,
          maxWordLength: 6,
        );
      case AgeMode.teens:
        return const DifficultySettings(
          gridSize: 10,
          wordCount: 10,
          allowDiagonal: true,
          allowBackward: false,
          minWordLength: 4,
          maxWordLength: 8,
        );
      case AgeMode.adults:
        return const DifficultySettings(
          gridSize: 12,
          wordCount: 14,
          allowDiagonal: true,
          allowBackward: true,
          minWordLength: 5,
          maxWordLength: 12,
        );
    }
  }
}

