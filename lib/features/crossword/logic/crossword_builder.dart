import '../models/crossword_clue.dart';
import '../models/crossword_puzzle.dart';

/// Builds [CrosswordPuzzle] from a grid template, solution grid, and clue bank.
/// - [gridTemplate]: only "#" (block) and "." (fillable) — used for the playable grid only.
/// - [solutionGrid]: letters A-Z and "#", same size — used ONLY for detecting words and answers.
/// - [clueBank]: answer (uppercase) -> clue text; fallback "Word: <answer>" if missing.
CrosswordPuzzle buildCrosswordPuzzle({
  required List<List<String>> gridTemplate,
  required List<List<String>> solutionGrid,
  required Map<String, String> clueBank,
  required String title,
  required String difficultyLabel,
}) {
  final rows = solutionGrid.length;
  final cols = rows > 0 ? solutionGrid[0].length : 0;

  bool isBlock(int r, int c) =>
      r < 0 || r >= rows || c < 0 || c >= cols || solutionGrid[r][c] == '#';

  /// Across: (r,c) starts an across word if not block and (col==0 or left is block).
  /// Read letters to the right until block. Length >= 2 only.
  final acrossStarts = <(int, int)>[];
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (isBlock(r, c)) continue;
      if (c > 0 && !isBlock(r, c - 1)) continue;
      var len = 0;
      while (c + len < cols && !isBlock(r, c + len)) len++;
      if (len >= 2) acrossStarts.add((r, c));
    }
  }

  /// Down: (r,c) starts a down word if not block and (row==0 or above is block).
  /// Read letters downward until block. Length >= 2 only.
  final downStarts = <(int, int)>[];
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      if (isBlock(r, c)) continue;
      if (r > 0 && !isBlock(r - 1, c)) continue;
      var len = 0;
      while (r + len < rows && !isBlock(r + len, c)) len++;
      if (len >= 2) downStarts.add((r, c));
    }
  }

  // Number all start cells in reading order (top-left to bottom-right)
  final allStarts = <(int, int)>{}..addAll(acrossStarts)..addAll(downStarts);
  final sortedStarts = allStarts.toList()
    ..sort((a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2));
  final numberAt = <(int, int), int>{};
  for (var i = 0; i < sortedStarts.length; i++) {
    numberAt[sortedStarts[i]] = i + 1;
  }

  String clueFor(String answer) =>
      clueBank[answer] ?? clueBank[answer.toUpperCase()] ?? 'Word: $answer';

  final acrossClues = <CrosswordClue>[];
  for (final (r, c) in acrossStarts) {
    var len = 0;
    while (c + len < cols && !isBlock(r, c + len)) len++;
    if (len < 2) continue;
    final answer = [for (var i = 0; i < len; i++) solutionGrid[r][c + i]]
        .join()
        .toUpperCase();
    if (answer.isEmpty) continue;
    acrossClues.add(CrosswordClue(
      number: numberAt[(r, c)] ?? 0,
      clue: clueFor(answer),
      answer: answer,
      row: r,
      col: c,
      length: len,
    ));
  }

  final downClues = <CrosswordClue>[];
  for (final (r, c) in downStarts) {
    var len = 0;
    while (r + len < rows && !isBlock(r + len, c)) len++;
    if (len < 2) continue;
    final answer = [for (var i = 0; i < len; i++) solutionGrid[r + i][c]]
        .join()
        .toUpperCase();
    if (answer.isEmpty) continue;
    downClues.add(CrosswordClue(
      number: numberAt[(r, c)] ?? 0,
      clue: clueFor(answer),
      answer: answer,
      row: r,
      col: c,
      length: len,
    ));
  }

  acrossClues.sort((a, b) => a.number.compareTo(b.number));
  downClues.sort((a, b) => a.number.compareTo(b.number));

  final grid = gridTemplate.map((row) => List<String>.from(row)).toList();
  return CrosswordPuzzle(
    grid: grid,
    acrossClues: acrossClues,
    downClues: downClues,
    title: title,
    difficultyLabel: difficultyLabel,
  );
}
