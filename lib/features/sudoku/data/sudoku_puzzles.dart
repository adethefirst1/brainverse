import 'dart:math';

import '../../../app/game_setup_scope.dart';
import '../logic/sudoku_difficulty_settings.dart';

/// Predefined easy 9×9 Sudoku puzzles (0 = empty). More givens, fewer cells to fill.
final List<List<List<int>>> kidsPuzzles = [
  [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9],
  ],
  [
    [4, 0, 0, 2, 0, 8, 0, 5, 1],
    [0, 8, 5, 0, 1, 0, 3, 0, 6],
    [2, 0, 1, 0, 5, 6, 0, 8, 4],
    [8, 1, 0, 5, 6, 0, 4, 0, 3],
    [0, 4, 6, 3, 0, 1, 8, 0, 5],
    [5, 0, 3, 0, 8, 4, 0, 1, 9],
    [1, 5, 0, 8, 3, 0, 6, 4, 0],
    [6, 0, 4, 0, 2, 0, 5, 3, 0],
    [3, 0, 8, 6, 0, 5, 0, 0, 2],
  ],
  [
    [0, 2, 6, 0, 3, 0, 0, 8, 9],
    [3, 0, 0, 8, 0, 9, 1, 0, 0],
    [0, 8, 9, 1, 0, 0, 3, 6, 2],
    [2, 6, 0, 3, 9, 0, 8, 0, 0],
    [8, 0, 3, 0, 0, 0, 6, 0, 1],
    [0, 9, 1, 0, 6, 8, 0, 2, 3],
    [9, 3, 0, 0, 0, 1, 2, 0, 6],
    [0, 0, 2, 9, 0, 3, 0, 0, 8],
    [6, 1, 0, 0, 8, 0, 9, 3, 0],
  ],
];

/// Predefined medium 9×9 Sudoku puzzles (0 = empty).
final List<List<List<int>>> teensPuzzles = [
  [
    [0, 0, 0, 6, 0, 4, 7, 0, 0],
    [7, 0, 6, 0, 0, 0, 0, 0, 9],
    [0, 0, 0, 0, 9, 0, 2, 0, 0],
    [0, 0, 0, 0, 0, 3, 0, 0, 0],
    [4, 0, 0, 8, 0, 0, 0, 2, 0],
    [0, 9, 0, 0, 0, 0, 0, 0, 5],
    [0, 0, 9, 0, 0, 0, 0, 8, 0],
    [5, 0, 0, 0, 4, 0, 6, 0, 0],
    [0, 0, 2, 3, 0, 0, 0, 0, 0],
  ],
  [
    [5, 0, 0, 0, 0, 0, 0, 8, 0],
    [0, 0, 0, 0, 3, 0, 0, 0, 2],
    [0, 0, 9, 0, 0, 6, 5, 0, 0],
    [0, 2, 0, 4, 0, 0, 0, 0, 6],
    [0, 0, 0, 8, 0, 1, 0, 0, 0],
    [8, 0, 0, 0, 0, 9, 0, 2, 0],
    [0, 0, 7, 2, 0, 0, 9, 0, 0],
    [4, 0, 0, 0, 6, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 0, 0, 0, 4],
  ],
  [
    [0, 6, 0, 0, 0, 0, 0, 1, 0],
    [0, 0, 8, 0, 0, 2, 0, 0, 5],
    [2, 0, 0, 5, 0, 8, 0, 0, 0],
    [0, 0, 5, 0, 9, 0, 0, 0, 0],
    [8, 0, 0, 0, 0, 0, 0, 0, 3],
    [0, 0, 0, 0, 4, 0, 6, 0, 0],
    [0, 0, 0, 3, 0, 7, 0, 0, 9],
    [3, 0, 0, 9, 0, 0, 2, 0, 0],
    [0, 4, 0, 0, 0, 0, 0, 7, 0],
  ],
];

/// Predefined hard 9×9 Sudoku puzzles (0 = empty). Fewer givens.
final List<List<List<int>>> adultsPuzzles = [
  [
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 3, 0, 8, 5],
    [0, 0, 1, 0, 2, 0, 0, 0, 0],
    [0, 0, 0, 5, 0, 7, 0, 0, 0],
    [0, 0, 4, 0, 0, 0, 1, 0, 0],
    [0, 9, 0, 0, 0, 0, 0, 0, 0],
    [5, 0, 0, 0, 0, 0, 0, 7, 3],
    [0, 0, 2, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 4, 0, 0, 0, 9],
  ],
  [
    [0, 0, 0, 7, 0, 0, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 4, 3, 0, 2, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 6],
    [0, 0, 0, 5, 0, 9, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 4, 1, 8],
    [0, 0, 0, 0, 8, 0, 0, 0, 0],
    [0, 0, 5, 0, 0, 0, 6, 0, 0],
    [0, 9, 0, 0, 0, 0, 0, 0, 0],
  ],
  [
    [0, 0, 0, 0, 0, 6, 0, 0, 0],
    [0, 5, 9, 0, 0, 0, 6, 0, 0],
    [2, 0, 0, 0, 0, 8, 0, 0, 0],
    [0, 4, 5, 0, 0, 0, 0, 0, 0],
    [0, 0, 3, 0, 0, 0, 0, 0, 0],
    [0, 0, 6, 0, 0, 3, 0, 5, 4],
    [0, 0, 0, 3, 2, 5, 0, 0, 6],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
  ],
];

/// Number of given (non-zero) cells in a 9×9 puzzle.
int countClues(List<List<int>> puzzle) {
  var n = 0;
  for (final row in puzzle) {
    for (final cell in row) {
      if (cell != 0) n++;
    }
  }
  return n;
}

/// All 9×9 puzzles by difficulty list (for filtering by clue range).
List<List<List<int>>> _puzzlesForAgeMode(AgeMode ageMode) {
  return switch (ageMode) {
    AgeMode.kids => kidsPuzzles,
    AgeMode.teens => teensPuzzles,
    AgeMode.adults => adultsPuzzles,
  };
}

/// Returns a random 9×9 puzzle for [ageMode] whose clue count is within
/// [SudokuDifficultySettings.minClues]–[SudokuDifficultySettings.maxClues].
/// Returns a deep copy (safe to mutate).
List<List<int>> getPuzzleForAgeMode(AgeMode ageMode, {int? seed}) {
  final settings = ageMode.sudokuSettings;
  final list = _puzzlesForAgeMode(ageMode);
  final inRange = list.where((p) {
    final clues = countClues(p);
    return clues >= settings.minClues && clues <= settings.maxClues;
  }).toList();
  final rng = seed != null ? Random(seed) : Random();
  final eligible = inRange.isNotEmpty ? inRange : list;
  final puzzle = eligible[rng.nextInt(eligible.length)];
  return puzzle.map((row) => List<int>.from(row)).toList();
}
