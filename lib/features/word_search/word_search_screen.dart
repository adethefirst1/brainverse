import 'package:flutter/material.dart';

import '../../app/game_setup_scope.dart';
import '../../app/wallet_scope.dart';
import 'logic/word_search_generator.dart';
import 'word_search_data.dart';

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({
    super.key,
    this.category,
    this.gridSize = 10,
  });

  final String? category;
  final int gridSize;

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  late List<List<String>> grid;
  late List<String> targetWords;
  final Set<String> _foundWords = {};
  final Map<String, List<List<int>>> _foundWordCells = {};
  List<List<int>> _selection = [];
  List<int>? _dragStart;
  bool _puzzleInitialized = false;
  bool _awardedPoints = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_puzzleInitialized) return;
    _puzzleInitialized = true;
    final category = widget.category ??
        GameSetupScope.maybeOf(context)?.data.category ??
        defaultWordSearchCategory;
    final wordList = wordListForCategory(category);
    final generator = WordSearchGenerator();
    final puzzle = generator.generate(
      gridSize: widget.gridSize,
      allowDiagonal: true,
      allowBackward: true,
      words: wordList,
    );
    grid = puzzle.grid;
    targetWords = puzzle.targetWords;
  }

  /// Returns a straight line of cells from [r0,c0] to [r1,c1] (only H/V/diagonal).
  List<List<int>> _lineCells(int r0, int c0, int r1, int c1) {
    final n = grid.length;
    final dr = r1 - r0;
    final dc = c1 - c0;
    if (dr == 0 && dc == 0) {
      if (r0 >= 0 && r0 < n && c0 >= 0 && c0 < n) return [[r0, c0]];
      return [];
    }
    // Must be horizontal, vertical, or diagonal (|dr| == |dc|).
    if (dr != 0 && dc != 0 && dr.abs() != dc.abs()) return [];
    final stepR = dr == 0 ? 0 : (dr > 0 ? 1 : -1);
    final stepC = dc == 0 ? 0 : (dc > 0 ? 1 : -1);
    final out = <List<int>>[];
    var r = r0;
    var c = c0;
    while (true) {
      if (r < 0 || r >= n || c < 0 || c >= n) break;
      out.add([r, c]);
      if (r == r1 && c == c1) break;
      r += stepR;
      c += stepC;
    }
    return out;
  }

  String _wordFromCells(List<List<int>> cells) {
    final buffer = StringBuffer();
    for (final cell in cells) {
      final r = cell[0];
      final c = cell[1];
      if (r >= 0 && r < grid.length && c >= 0 && c < grid[0].length) {
        buffer.write(grid[r][c]);
      }
    }
    return buffer.toString();
  }

  void _onPanStart(DragStartDetails details, Size gridSize) {
    final n = grid.length;
    final cellW = gridSize.width / n;
    final cellH = gridSize.height / n;
    final local = details.localPosition;
    final c = (local.dx / cellW).floor().clamp(0, n - 1);
    final r = (local.dy / cellH).floor().clamp(0, n - 1);
    setState(() {
      _dragStart = [r, c];
      _selection = [[r, c]];
    });
  }

  void _onPanUpdate(DragUpdateDetails details, Size gridSize) {
    if (_dragStart == null) return;
    final n = grid.length;
    final cellW = gridSize.width / n;
    final cellH = gridSize.height / n;
    final local = details.localPosition;
    final c = (local.dx / cellW).floor().clamp(0, n - 1);
    final r = (local.dy / cellH).floor().clamp(0, n - 1);
    final line = _lineCells(_dragStart![0], _dragStart![1], r, c);
    setState(() => _selection = line);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_selection.isEmpty) {
      setState(() {
        _dragStart = null;
        _selection = [];
      });
      return;
    }
    final word = _wordFromCells(_selection);
    final reversed = _wordFromCells(_selection.reversed.toList());
    String? matched;
    if (targetWords.contains(word)) matched = word;
    if (matched == null && targetWords.contains(reversed)) matched = reversed;

    setState(() {
      if (matched != null && !_foundWords.contains(matched)) {
        _foundWords.add(matched);
        _foundWordCells[matched] = List.from(_selection);
        if (!_awardedPoints && _foundWords.length == targetWords.length) {
          _awardedPoints = true;
          WalletScope.maybeOf(context)?.addPoints('Word Search completed', 50);
        }
      }
      _dragStart = null;
      _selection = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = widget.category ??
        GameSetupScope.maybeOf(context)?.data.category ??
        defaultWordSearchCategory;
    final n = grid.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Search'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${_foundWords.length}/${targetWords.length}',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Category: $category',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final side = constraints.biggest.width > constraints.biggest.height
                      ? constraints.biggest.height
                      : constraints.biggest.width;
                  final gridSize = Size(side, side);
                  return Center(
                    child: GestureDetector(
                      onPanStart: (d) => _onPanStart(d, gridSize),
                      onPanUpdate: (d) => _onPanUpdate(d, gridSize),
                      onPanEnd: (_) => _onPanEnd(DragEndDetails()),
                      child: SizedBox(
                        width: side,
                        height: side,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: n,
                            childAspectRatio: 1,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                          ),
                          itemCount: n * n,
                          itemBuilder: (context, index) {
                            final r = index ~/ n;
                            final c = index % n;
                            final letter = grid[r][c];
                            final isFound = _foundWordCells.values
                                .any((cells) => cells.any((cell) => cell[0] == r && cell[1] == c));
                            final isSelected = _selection.any((cell) => cell[0] == r && cell[1] == c);
                            final cs = theme.colorScheme;
                            Color bg = cs.surface;
                            if (isSelected) bg = cs.primaryContainer;
                            else if (isFound) bg = cs.tertiaryContainer;
                            return Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: cs.outlineVariant,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isFound ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected
                                        ? cs.onPrimaryContainer
                                        : isFound
                                            ? cs.onTertiaryContainer
                                            : cs.onSurface,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 140),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find these words:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: targetWords.map((w) {
                          final found = _foundWords.contains(w);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              w,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                decoration: found ? TextDecoration.lineThrough : null,
                                color: found
                                    ? theme.colorScheme.onSurfaceVariant
                                    : theme.colorScheme.onSurface,
                                fontWeight: found ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
