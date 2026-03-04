import '../../../app/game_setup_scope.dart';

/// Difficulty settings for Sudoku, mapped from [AgeMode].
/// Grid is always 9×9; difficulty is based on clue count (filled cells).
class SudokuDifficultySettings {
  const SudokuDifficultySettings({
    required this.minClues,
    required this.maxClues,
    required this.label,
  });

  /// Minimum number of given (non-zero) cells in the puzzle.
  final int minClues;
  /// Maximum number of given (non-zero) cells in the puzzle.
  final int maxClues;
  /// Display label: Easy / Medium / Hard.
  final String label;
}

extension AgeModeSudokuDifficulty on AgeMode {
  SudokuDifficultySettings get sudokuSettings {
    switch (this) {
      case AgeMode.kids:
        return const SudokuDifficultySettings(
          minClues: 45,
          maxClues: 52,
          label: 'Easy',
        );
      case AgeMode.teens:
        return const SudokuDifficultySettings(
          minClues: 36,
          maxClues: 44,
          label: 'Medium',
        );
      case AgeMode.adults:
        return const SudokuDifficultySettings(
          minClues: 28,
          maxClues: 35,
          label: 'Hard',
        );
    }
  }
}
