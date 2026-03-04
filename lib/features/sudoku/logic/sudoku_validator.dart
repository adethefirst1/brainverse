/// Validation helpers for 9×9 Sudoku. A cell is invalid if its value
/// duplicates another in the same row, column, or 3×3 box.

/// True if no non-zero value appears more than once in [row].
bool isRowValid(List<List<int>> board, int row) {
  final seen = <int>{};
  for (var c = 0; c < 9; c++) {
    final v = board[row][c];
    if (v != 0 && !seen.add(v)) return false;
  }
  return true;
}

/// True if no non-zero value appears more than once in [column].
bool isColumnValid(List<List<int>> board, int column) {
  final seen = <int>{};
  for (var r = 0; r < 9; r++) {
    final v = board[r][column];
    if (v != 0 && !seen.add(v)) return false;
  }
  return true;
}

/// True if no non-zero value appears more than once in the 3×3 box
/// that contains [row], [column].
bool isBoxValid(List<List<int>> board, int row, int column) {
  final boxRow = (row ~/ 3) * 3;
  final boxCol = (column ~/ 3) * 3;
  final seen = <int>{};
  for (var r = boxRow; r < boxRow + 3; r++) {
    for (var c = boxCol; c < boxCol + 3; c++) {
      final v = board[r][c];
      if (v != 0 && !seen.add(v)) return false;
    }
  }
  return true;
}

/// True if the cell at [row], [column] does not duplicate a value
/// in its row, column, or 3×3 box. Empty (0) is considered valid.
bool isCellValid(List<List<int>> board, int row, int column) {
  final value = board[row][column];
  if (value == 0) return true;

  for (var c = 0; c < 9; c++) {
    if (c != column && board[row][c] == value) return false;
  }
  for (var r = 0; r < 9; r++) {
    if (r != row && board[r][column] == value) return false;
  }
  final boxRow = (row ~/ 3) * 3;
  final boxCol = (column ~/ 3) * 3;
  for (var r = boxRow; r < boxRow + 3; r++) {
    for (var c = boxCol; c < boxCol + 3; c++) {
      if ((r != row || c != column) && board[r][c] == value) return false;
    }
  }
  return true;
}

/// Returns keys "r:c" for every cell involved in a conflict (duplicate in row,
/// column, or 3×3 box). Ignores zeros. If a number appears more than once in
/// a row/column/box, all positions with that number are added.
Set<String> computeConflictCells(List<List<int>> board) {
  final conflict = <String>{};

  // Rows: for each row, find values that appear more than once, add all positions
  for (var r = 0; r < 9; r++) {
    final valueToCols = <int, List<int>>{};
    for (var c = 0; c < 9; c++) {
      final v = board[r][c];
      if (v != 0) valueToCols.putIfAbsent(v, () => []).add(c);
    }
    for (final cols in valueToCols.values) {
      if (cols.length > 1) for (final c in cols) conflict.add('$r:$c');
    }
  }

  // Columns
  for (var c = 0; c < 9; c++) {
    final valueToRows = <int, List<int>>{};
    for (var r = 0; r < 9; r++) {
      final v = board[r][c];
      if (v != 0) valueToRows.putIfAbsent(v, () => []).add(r);
    }
    for (final rows in valueToRows.values) {
      if (rows.length > 1) for (final r in rows) conflict.add('$r:$c');
    }
  }

  // 3×3 boxes
  for (var br = 0; br < 3; br++) {
    for (var bc = 0; bc < 3; bc++) {
      final valueToPos = <int, List<String>>{};
      for (var r = br * 3; r < br * 3 + 3; r++) {
        for (var c = bc * 3; c < bc * 3 + 3; c++) {
          final v = board[r][c];
          if (v != 0) valueToPos.putIfAbsent(v, () => []).add('$r:$c');
        }
      }
      for (final positions in valueToPos.values) {
        if (positions.length > 1) conflict.addAll(positions);
      }
    }
  }

  return conflict;
}
