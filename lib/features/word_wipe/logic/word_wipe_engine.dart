import 'dart:math';

/// Engine for Word Wipe: board generation, gravity, refill, and applying word paths.
/// Board is [row][col]; empty cells are represented as "".
/// Use optional [seed] for deterministic behavior (e.g. replay or tests).
class WordWipeEngine {
  WordWipeEngine({this.seed});

  final int? seed;

  static const String _empty = '';
  static const _letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Creates a new [Random]. If [seed] was provided to the engine, uses it;
  /// otherwise uses the optional [overrideSeed] or a non-deterministic Random.
  Random _random([int? overrideSeed]) {
    final s = overrideSeed ?? seed;
    return s != null ? Random(s) : Random();
  }

  /// Generates a size x size board filled with random letters A–Z.
  List<List<String>> generateBoard(int size, {int? seed}) {
    final rng = _random(seed);
    return List.generate(
      size,
      (_) => List.generate(
        size,
        (_) => _letters[rng.nextInt(_letters.length)],
      ),
    );
  }

  /// Returns a new board after clearing cells at [pathCells], applying gravity,
  /// then refilling empty spots. [pathCells] are (row, col) pairs, 0-based.
  List<List<String>> applyWordPath(
    List<List<String>> board,
    List<(int, int)> pathCells, {
    int? seed,
  }) {
    final rows = board.length;
    if (rows == 0) return board;
    final cols = board[0].length;

    // 1) Clear path cells (copy board and set to empty)
    final next = List.generate(
      rows,
      (r) => List<String>.from(board[r]),
    );
    for (final (r, c) in pathCells) {
      if (r >= 0 && r < rows && c >= 0 && c < cols) {
        next[r][c] = _empty;
      }
    }

    // 2) Gravity
    next.replaceRange(0, rows, applyGravity(next));

    // 3) Refill
    return refill(next, seed: seed);
  }

  /// Letters fall down in each column: non-empty cells sink to the bottom,
  /// empty cells ("" ) end up at the top. Returns a new board.
  static List<List<String>> applyGravity(List<List<String>> board) {
    final rows = board.length;
    if (rows == 0) return board;
    final cols = board[0].length;

    final out = List.generate(rows, (r) => List<String>.filled(cols, _empty));

    for (int c = 0; c < cols; c++) {
      final column = List.generate(rows, (r) => board[r][c]);
      final letters = column.where((cell) => cell.isNotEmpty).toList();
      final emptyCount = rows - letters.length;
      for (int r = 0; r < rows; r++) {
        out[r][c] = r < emptyCount ? _empty : letters[r - emptyCount];
      }
    }
    return out;
  }

  /// Fills every "" cell with a random letter A–Z. Returns a new board.
  List<List<String>> refill(List<List<String>> board, {int? seed}) {
    final rng = _random(seed);
    return List.generate(
      board.length,
      (r) => List.generate(
        board[r].length,
        (c) => board[r][c].isEmpty
            ? _letters[rng.nextInt(_letters.length)]
            : board[r][c],
      ),
    );
  }
}
