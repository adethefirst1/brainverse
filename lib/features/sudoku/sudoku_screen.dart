import 'package:flutter/material.dart';

import '../../app/game_setup_scope.dart';
import '../../app/wallet_scope.dart';
import 'data/sudoku_puzzles.dart';
import 'logic/sudoku_difficulty_settings.dart';
import 'logic/sudoku_validator.dart';

const bool kDebugSudoku = true;

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key, required this.ageMode});

  final AgeMode ageMode;

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  int selectedRow = -1;
  int selectedCol = -1;

  late List<List<int>> board;
  late Set<String> fixedCells;
  Set<String> _conflictCells = {};

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
  }

  void _loadPuzzle() {
    final puzzle = getPuzzleForAgeMode(widget.ageMode);
    board = puzzle;
    fixedCells = <String>{};
    selectedRow = -1;
    selectedCol = -1;
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        if (board[r][c] != 0) {
          fixedCells.add('$r,$c');
        }
      }
    }
    _conflictCells = computeConflictCells(board);
  }

  void selectCell(int r, int c) {
    setState(() {
      selectedRow = r;
      selectedCol = c;
    });
  }

  bool isFixedCell(int row, int col) => fixedCells.contains('$row,$col');

  /// Returns true if placing [value] at [row], [col] does not break Sudoku rules.
  bool isValidMove(int row, int col, int value) {
    if (value == 0) return true; // Clearing a cell is always valid

    // No duplicate in the same row
    for (int c = 0; c < 9; c++) {
      if (c != col && board[row][c] == value) return false;
    }

    // No duplicate in the same column
    for (int r = 0; r < 9; r++) {
      if (r != row && board[r][col] == value) return false;
    }

    // No duplicate in the same 3x3 box
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if ((r != row || c != col) && board[r][c] == value) return false;
      }
    }

    return true;
  }

  void checkWin() {
    // Puzzle is complete when there are no zeros and all numbers are valid
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final value = board[r][c];
        if (value == 0) return;
        if (!isValidMove(r, c, value)) return;
      }
    }

    WalletScope.maybeOf(context)?.addPoints('Sudoku completed', 50);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You solved it!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = widget.ageMode.sudokuSettings;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sudoku"),
        actions: [
          TextButton.icon(
            onPressed: () {
              _loadPuzzle();
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
            label: const Text('New Puzzle'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  InputChip(
                    label: Text(widget.ageMode.label),
                    onPressed: null,
                  ),
                  InputChip(
                    label: Text(settings.label),
                    onPressed: null,
                  ),
                ],
              ),
            ),
            if (kDebugSudoku)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Clues: ${countClues(board)} (expected ${settings.minClues}–${settings.maxClues})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            if (_conflictCells.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'Conflicts: ${_conflictCells.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: _SudokuBoard(
                            board: board,
                            selectedRow: selectedRow,
                            selectedCol: selectedCol,
                            fixedCells: fixedCells,
                            conflictCells: _conflictCells,
                            onCellTap: selectCell,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _SudokuKeypad(
                              onNumberTap: (n) {
                                if (selectedRow == -1 || selectedCol == -1) return;
                                if (isFixedCell(selectedRow, selectedCol)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Cannot edit fixed cell')),
                                  );
                                  return;
                                }
                                setState(() {
                                  board[selectedRow][selectedCol] = n;
                                  _conflictCells = computeConflictCells(board);
                                });
                                checkWin();
                              },
                              onClear: () {
                                if (selectedRow == -1 || selectedCol == -1) return;
                                if (isFixedCell(selectedRow, selectedCol)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Cannot edit fixed cell')),
                                  );
                                  return;
                                }
                                setState(() {
                                  board[selectedRow][selectedCol] = 0;
                                  _conflictCells = computeConflictCells(board);
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Tap a cell, then choose a number.",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SudokuBoard extends StatelessWidget {
  const _SudokuBoard({
    required this.board,
    required this.selectedRow,
    required this.selectedCol,
    required this.fixedCells,
    required this.conflictCells,
    required this.onCellTap,
  });

  final List<List<int>> board;
  final int selectedRow;
  final int selectedCol;
  final Set<String> fixedCells;
  final Set<String> conflictCells;
  final void Function(int row, int col) onCellTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
      ),
      itemCount: 81,
      itemBuilder: (context, index) {
        final r = index ~/ 9;
        final c = index % 9;
        final value = board[r][c];

        final isSelected = r == selectedRow && c == selectedCol;
        final isFixed = fixedCells.contains('$r,$c');
        final hasConflict = conflictCells.contains('$r:$c');
        final hasSelection = selectedRow >= 0 && selectedCol >= 0;
        final isInSelectedRowOrCol = hasSelection &&
            (r == selectedRow || c == selectedCol) &&
            !isSelected;

        // Conflict > selection > row/col highlight > default. Fixed only affects fontWeight.
        final Color cellColor;
        final Color textColor;
        if (hasConflict) {
          cellColor = cs.errorContainer;
          textColor = cs.onErrorContainer;
        } else if (isSelected) {
          cellColor = cs.primaryContainer;
          textColor = cs.onPrimaryContainer;
        } else if (isInSelectedRowOrCol) {
          cellColor = cs.primaryContainer.withOpacity(0.25);
          textColor = cs.onSurface;
        } else {
          cellColor = cs.surface;
          textColor = cs.onSurface;
        }

        // thick lines every 3 cells
        final left = (c % 3 == 0) ? 2.0 : 0.5;
        final top = (r % 3 == 0) ? 2.0 : 0.5;
        final right = (c == 8) ? 2.0 : 0.5;
        final bottom = (r == 8) ? 2.0 : 0.5;

        return InkWell(
          onTap: () => onCellTap(r, c),
          child: Container(
            decoration: BoxDecoration(
              color: cellColor,
              border: Border(
                left: BorderSide(color: cs.outline, width: left),
                top: BorderSide(color: cs.outline, width: top),
                right: BorderSide(color: cs.outline, width: right),
                bottom: BorderSide(color: cs.outline, width: bottom),
              ),
            ),
            child: Center(
              child: Text(
                value == 0 ? "" : "$value",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: isFixed ? FontWeight.bold : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SudokuKeypad extends StatelessWidget {
  const _SudokuKeypad({
    required this.onNumberTap,
    required this.onClear,
  });

  final void Function(int number) onNumberTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(9, (i) {
            final n = i + 1;
            return SizedBox(
              width: 56,
              height: 44,
              child: FilledButton.tonal(
                onPressed: () => onNumberTap(n),
                child: Text("$n"),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 180,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.backspace_outlined),
            label: const Text("Clear"),
          ),
        ),
      ],
    );
  }
}

