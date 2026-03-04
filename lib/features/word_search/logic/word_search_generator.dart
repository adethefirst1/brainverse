import 'dart:math';

import '../models/word_search_puzzle.dart';

/// Direction offsets (dr, dc). Index: 0=E, 1=W, 2=S, 3=N, 4=SE, 5=SW, 6=NE, 7=NW.
const List<int> _dirRow = [0, 0, 1, -1, 1, 1, -1, -1];
const List<int> _dirCol = [1, -1, 0, 0, 1, -1, 1, -1];

/// Forward-only direction indices (E, S, SE, SW).
const List<int> _forwardDirIndices = [0, 2, 4, 5];

const String _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

/// Generates a word search puzzle by placing words in the grid and filling the rest.
class WordSearchGenerator {
  /// [randomSeed] optional for reproducible puzzles.
  WordSearchGenerator({int? randomSeed}) : _rng = Random(randomSeed);

  final Random _rng;

  /// Builds a puzzle with the given constraints.
  ///
  /// - [gridSize]: N×N grid.
  /// - [allowDiagonal]: if false, only horizontal and vertical placement.
  /// - [allowBackward]: if false, only "forward" directions (E, S, SE, SW).
  /// - [words]: list of words to place (will be normalized and filtered by length).
  ///
  /// Overlap is allowed only when letters match. Remaining cells are filled with random A–Z.
  WordSearchPuzzle generate({
    required int gridSize,
    required bool allowDiagonal,
    required bool allowBackward,
    required List<String> words,
    int? randomSeed,
  }) {
    final rng = randomSeed != null ? Random(randomSeed) : _rng;
    final grid = _emptyGrid(gridSize);
    final normalized = _normalizeWords(words, gridSize, rng);
    final directions = _allowedDirections(allowDiagonal, allowBackward);
    final placedWords = <String>[];

    for (final word in normalized) {
      if (_tryPlaceWord(grid, word, gridSize, directions, rng)) {
        placedWords.add(word);
      }
    }

    _fillEmptyCells(grid, gridSize, rng);
    return WordSearchPuzzle(
      grid: grid,
      targetWords: placedWords,
    );
  }

  /// Returns direction indices allowed by [allowDiagonal] and [allowBackward].
  /// Horizontal/vertical = 0..3 (E,W,S,N). Diagonal = 4..7 (SE,SW,NE,NW).
  /// Forward-only = E, S, SE, SW (indices 0, 2, 4, 5).
  List<int> _allowedDirections(bool allowDiagonal, bool allowBackward) {
    List<int> indices = [0, 1, 2, 3]; // E, W, S, N
    if (allowDiagonal) {
      indices = [0, 1, 2, 3, 4, 5, 6, 7];
    }
    if (!allowBackward) {
      indices = indices.where((i) => _forwardDirIndices.contains(i)).toList();
    }
    return indices;
  }

  List<List<String>> _emptyGrid(int n) {
    return List.generate(n, (_) => List.filled(n, ''));
  }

  List<String> _normalizeWords(List<String> words, int maxLen, Random rng) {
    final list = words
        .map((w) => w.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), ''))
        .where((w) => w.length >= 2 && w.length <= maxLen)
        .toSet()
        .toList();
    list.shuffle(rng);
    return list;
  }

  /// Tries to place [word] in [grid] at a random position using one of [directions].
  /// Overlaps only where existing letter matches. Returns true if placed.
  bool _tryPlaceWord(
    List<List<String>> grid,
    String word,
    int n,
    List<int> directions,
    Random rng,
  ) {
    if (directions.isEmpty) return false;
    const maxTries = 80;
    final shuffledDirs = List<int>.from(directions)..shuffle(rng);

    for (var t = 0; t < maxTries; t++) {
      final r0 = rng.nextInt(n);
      final c0 = rng.nextInt(n);
      for (final di in shuffledDirs) {
        final dr = _dirRow[di];
        final dc = _dirCol[di];
        if (_fits(grid, word, n, r0, c0, dr, dc)) {
          _writeWord(grid, word, r0, c0, dr, dc);
          return true;
        }
      }
    }
    return false;
  }

  bool _fits(
    List<List<String>> grid,
    String word,
    int n,
    int r0,
    int c0,
    int dr,
    int dc,
  ) {
    final len = word.length;
    final r1 = r0 + (len - 1) * dr;
    final c1 = c0 + (len - 1) * dc;
    if (r1 < 0 || r1 >= n || c1 < 0 || c1 >= n) return false;

    for (var i = 0; i < len; i++) {
      final r = r0 + i * dr;
      final c = c0 + i * dc;
      final existing = grid[r][c];
      if (existing.isNotEmpty && existing != word[i]) return false;
    }
    return true;
  }

  void _writeWord(
    List<List<String>> grid,
    String word,
    int r0,
    int c0,
    int dr,
    int dc,
  ) {
    for (var i = 0; i < word.length; i++) {
      grid[r0 + i * dr][c0 + i * dc] = word[i];
    }
  }

  void _fillEmptyCells(List<List<String>> grid, int n, Random rng) {
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if (grid[r][c].isEmpty) {
          grid[r][c] = _letters[rng.nextInt(26)];
        }
      }
    }
  }
}
