import 'package:flutter/material.dart';

import '../../../app/game_setup_scope.dart';
import '../../../app/wallet_scope.dart';
import '../data/crossword_puzzles.dart';
import '../models/crossword_clue.dart';
import '../models/crossword_puzzle.dart';

class CrosswordScreen extends StatefulWidget {
  const CrosswordScreen({
    super.key,
    required this.ageMode,
    this.category,
  });

  final AgeMode ageMode;
  final String? category;

  @override
  State<CrosswordScreen> createState() => _CrosswordScreenState();
}

enum _Direction { across, down }

class _CrosswordScreenState extends State<CrosswordScreen> with SingleTickerProviderStateMixin {
  late CrosswordPuzzle _puzzle;
  late Set<String> _fixedCells;

  int _selectedRow = -1;
  int _selectedCol = -1;
  _Direction _direction = _Direction.across;
  Set<String> _wrongCells = {};
  bool _winDialogShown = false;
  late TabController _tabController;

  /// Clue number(s) at (r,c) if this cell starts a clue. E.g. "1" or "1-2" when both across and down start here.
  String? _clueNumberAt(int r, int c) {
    final numbers = <int>{};
    for (final clue in _puzzle.acrossClues) {
      if (clue.row == r && clue.col == c) numbers.add(clue.number);
    }
    for (final clue in _puzzle.downClues) {
      if (clue.row == r && clue.col == c) numbers.add(clue.number);
    }
    if (numbers.isEmpty) return null;
    final list = numbers.toList()..sort();
    return list.join('-');
  }

  /// Cells belonging to the current word (direction) containing the selection.
  Set<String> _getActiveWordCells() {
    if (_selectedRow < 0 || _selectedCol < 0) return {};
    final cells = <String>{};
    if (_direction == _Direction.across) {
      var c = _selectedCol;
      while (c > 0 && _grid[_selectedRow][c - 1] != '#') c--;
      while (c < _cols && _grid[_selectedRow][c] != '#') {
        cells.add('$_selectedRow:$c');
        c++;
      }
    } else {
      var r = _selectedRow;
      while (r > 0 && _grid[r - 1][_selectedCol] != '#') r--;
      while (r < _rows && _grid[r][_selectedCol] != '#') {
        cells.add('$r:$_selectedCol');
        r++;
      }
    }
    return cells;
  }

  /// Clue number for the word containing the selected cell in current direction.
  int? _getActiveClueNumber() {
    if (_selectedRow < 0 || _selectedCol < 0) return null;
    if (_direction == _Direction.across) {
      var c = _selectedCol;
      while (c > 0 && _grid[_selectedRow][c - 1] != '#') c--;
      for (final clue in _puzzle.acrossClues) {
        if (clue.row == _selectedRow && clue.col == c) return clue.number;
      }
    } else {
      var r = _selectedRow;
      while (r > 0 && _grid[r - 1][_selectedCol] != '#') r--;
      for (final clue in _puzzle.downClues) {
        if (clue.row == r && clue.col == _selectedCol) return clue.number;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _puzzle = getRandomCrossword(widget.ageMode);
    _fixedCells = {};
    final grid = _puzzle.grid;
    for (var r = 0; r < grid.length; r++) {
      for (var c = 0; c < grid[r].length; c++) {
        final cell = grid[r][c];
        if (cell != '#' && cell != '.') {
          _fixedCells.add('$r:$c');
        }
      }
    }
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<List<String>> get _grid => _puzzle.grid;

  void _onCellTap(int r, int c) {
    if (_grid[r][c] == '#') return;
    setState(() {
      if (_selectedRow == r && _selectedCol == c) {
        _direction = _direction == _Direction.across ? _Direction.down : _Direction.across;
        _tabController.animateTo(_direction == _Direction.across ? 0 : 1);
      } else {
        _selectedRow = r;
        _selectedCol = c;
      }
    });
  }

  void _onClueTap(CrosswordClue clue, bool isAcross) {
    setState(() {
      _selectedRow = clue.row;
      _selectedCol = clue.col;
      _direction = isAcross ? _Direction.across : _Direction.down;
      _tabController.animateTo(isAcross ? 0 : 1);
    });
  }

  int get _rows => _grid.length;
  int get _cols => _rows > 0 ? _grid[0].length : 0;

  /// Next or previous cell in current direction. Returns null if none.
  (int, int)? _adjacentInDirection(int r, int c, bool forward) {
    if (_direction == _Direction.across) {
      if (forward) {
        for (var j = c + 1; j < _cols; j++) {
          if (_grid[r][j] != '#') return (r, j);
        }
        return null;
      } else {
        for (var j = c - 1; j >= 0; j--) {
          if (_grid[r][j] != '#') return (r, j);
        }
        return null;
      }
    } else {
      if (forward) {
        for (var i = r + 1; i < _rows; i++) {
          if (_grid[i][c] != '#') return (i, c);
        }
        return null;
      } else {
        for (var i = r - 1; i >= 0; i--) {
          if (_grid[i][c] != '#') return (i, c);
        }
        return null;
      }
    }
  }

  void _onLetter(String letter) {
    if (_selectedRow < 0 || _selectedCol < 0) return;
    if (_fixedCells.contains('$_selectedRow:$_selectedCol')) return;
    setState(() {
      _grid[_selectedRow][_selectedCol] = letter.toUpperCase();
      final next = _adjacentInDirection(_selectedRow, _selectedCol, true);
      if (next != null) {
        _selectedRow = next.$1;
        _selectedCol = next.$2;
      }
    });
  }

  void _onBackspace() {
    if (_selectedRow < 0 || _selectedCol < 0) return;
    setState(() {
      if (!_fixedCells.contains('$_selectedRow:$_selectedCol')) {
        _grid[_selectedRow][_selectedCol] = '.';
      }
      final prev = _adjacentInDirection(_selectedRow, _selectedCol, false);
      if (prev != null) {
        _selectedRow = prev.$1;
        _selectedCol = prev.$2;
      }
    });
  }

  /// Build solution grid from clues (same dimensions as puzzle grid).
  List<List<String>> _buildSolutionGrid() {
    final rows = _rows;
    final cols = _cols;
    final solution = List.generate(
      rows,
      (r) => List.generate(cols, (c) => _grid[r][c] == '#' ? '#' : '.'),
    );
    for (final clue in _puzzle.acrossClues) {
      final ans = clue.answer.toUpperCase();
      for (var i = 0; i < clue.length && clue.col + i < cols; i++) {
        solution[clue.row][clue.col + i] = i < ans.length ? ans[i] : '.';
      }
    }
    for (final clue in _puzzle.downClues) {
      final ans = clue.answer.toUpperCase();
      for (var i = 0; i < clue.length && clue.row + i < rows; i++) {
        solution[clue.row + i][clue.col] = i < ans.length ? ans[i] : '.';
      }
    }
    return solution;
  }

  void _onCheck() {
    final solution = _buildSolutionGrid();
    final wrong = <String>{};
    for (var r = 0; r < _rows; r++) {
      for (var c = 0; c < _cols; c++) {
        if (_grid[r][c] != '#' && _grid[r][c] != solution[r][c]) {
          wrong.add('$r:$c');
        }
      }
    }
    setState(() => _wrongCells = wrong);

    if (wrong.isEmpty) {
      for (var r = 0; r < _rows; r++) {
        for (var c = 0; c < _cols; c++) {
          if (_grid[r][c] != '#' && _grid[r][c] == '.') return;
        }
      }
      _showWinDialog();
    }
  }

  void _onRevealCell() {
    if (_selectedRow < 0 || _selectedCol < 0) return;
    final solution = _buildSolutionGrid();
    final correct = solution[_selectedRow][_selectedCol];
    if (correct == '#' || correct == '.') return;
    setState(() {
      _grid[_selectedRow][_selectedCol] = correct;
      _fixedCells.add('$_selectedRow:$_selectedCol');
      _wrongCells.remove('$_selectedRow:$_selectedCol');
    });
  }

  void _showWinDialog() {
    if (_winDialogShown || !mounted) return;
    _winDialogShown = true;
    WalletScope.maybeOf(context)?.addPoints('Crossword completed', 50);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You completed the crossword!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _grid.length;
    final cols = rows > 0 ? _grid[0].length : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crossword'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputChip(
                    label: Text(widget.ageMode.label),
                    onPressed: null,
                  ),
                  const SizedBox(width: 8),
                  InputChip(
                    label: Text(_puzzle.difficultyLabel),
                    onPressed: null,
                  ),
                  if (widget.category != null) ...[
                    const SizedBox(width: 8),
                    InputChip(
                      label: Text(widget.category!),
                      onPressed: null,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final side = constraints.biggest.width < constraints.biggest.height
                          ? constraints.biggest.width
                          : constraints.biggest.height;
                      const spacing = 1.0;
                      final n = rows > cols ? rows : cols;
                      final cellSize = (rows > 0 && cols > 0)
                          ? (side - (n - 1) * spacing) / n
                          : 0.0;
                      final activeWordCells = _getActiveWordCells();
                      return SizedBox(
                        width: cellSize * cols + (cols - 1) * spacing,
                        height: cellSize * rows + (rows - 1) * spacing,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cols,
                            childAspectRatio: 1,
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                          ),
                          itemCount: rows * cols,
                          itemBuilder: (context, index) {
                            final r = index ~/ cols;
                            final c = index % cols;
                            final cell = _grid[r][c];
                            final isBlack = cell == '#';
                            final isSelected =
                                _selectedRow == r && _selectedCol == c;
                            final isInActiveWord = activeWordCells.contains('$r:$c');
                            final isFixed = _fixedCells.contains('$r:$c');
                            final isWrong = _wrongCells.contains('$r:$c');
                            final clueNum = _clueNumberAt(r, c);

                            if (isBlack) {
                              return Container(
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.inverseSurface,
                                  border: Border.all(
                                    color: theme.colorScheme.inverseSurface,
                                    width: 1,
                                  ),
                                ),
                              );
                            }

                            final Color cellColor = isWrong
                                ? theme.colorScheme.errorContainer
                                : (isSelected
                                    ? theme.colorScheme.primary
                                    : (isInActiveWord
                                        ? theme.colorScheme.primaryContainer.withOpacity(0.7)
                                        : theme.colorScheme.surface));
                            final Color textColor = isWrong
                                ? theme.colorScheme.onErrorContainer
                                : (isSelected
                                    ? theme.colorScheme.onPrimary
                                    : (isInActiveWord
                                        ? theme.colorScheme.onPrimaryContainer
                                        : theme.colorScheme.onSurface));

                            return InkWell(
                              onTap: () => _onCellTap(r, c),
                              child: Container(
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  border: Border.all(
                                    color: theme.colorScheme.outline.withOpacity(0.8),
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (clueNum != null)
                                      Positioned(
                                        left: 2,
                                        top: 2,
                                        child: Text(
                                          clueNum,
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: textColor.withOpacity(0.9),
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    Center(
                                      child: Text(
                                        cell == '.' ? '' : cell,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight:
                                              isFixed ? FontWeight.bold : FontWeight.w500,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _onCheck,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Check'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonalIcon(
                    onPressed: _selectedRow >= 0 && _selectedCol >= 0
                        ? _onRevealCell
                        : null,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Reveal Cell'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedRow >= 0 && _selectedCol >= 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<_Direction>(
                  segments: const [
                    ButtonSegment(value: _Direction.across, label: Text('Across')),
                    ButtonSegment(value: _Direction.down, label: Text('Down')),
                  ],
                  selected: {_direction},
                  onSelectionChanged: (Set<_Direction> s) {
                    setState(() => _direction = s.first);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    ...List.generate(26, (i) {
                      final letter = String.fromCharCode(65 + i);
                      return SizedBox(
                        width: 32,
                        height: 40,
                        child: FilledButton.tonal(
                          onPressed: () => _onLetter(letter),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                          ),
                          child: Text(letter),
                        ),
                      );
                    }),
                    SizedBox(
                      width: 56,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: _onBackspace,
                        child: const Icon(Icons.backspace_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: theme.colorScheme.primary,
                    tabs: const [
                      Tab(text: 'Across'),
                      Tab(text: 'Down'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _ClueList(
                          clues: _puzzle.acrossClues,
                          activeClueNumber: _getActiveClueNumber(),
                          isCurrentDirection: _direction == _Direction.across,
                          isAcross: true,
                          onClueTap: _onClueTap,
                        ),
                        _ClueList(
                          clues: _puzzle.downClues,
                          activeClueNumber: _getActiveClueNumber(),
                          isCurrentDirection: _direction == _Direction.down,
                          isAcross: false,
                          onClueTap: _onClueTap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClueList extends StatelessWidget {
  const _ClueList({
    required this.clues,
    required this.activeClueNumber,
    required this.isCurrentDirection,
    required this.isAcross,
    required this.onClueTap,
  });

  final List<CrosswordClue> clues;
  final int? activeClueNumber;
  final bool isCurrentDirection;
  final bool isAcross;
  final void Function(CrosswordClue clue, bool isAcross) onClueTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: clues.length,
      itemBuilder: (context, index) {
        final clue = clues[index];
        final isActive = isCurrentDirection && activeClueNumber == clue.number;
        return Material(
          color: isActive
              ? theme.colorScheme.primaryContainer.withOpacity(0.6)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => onClueTap(clue, isAcross),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isActive
                    ? Border(
                        left: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 3,
                        ),
                      )
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${clue.number}.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withOpacity(0.9),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      clue.clue,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isActive ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
