import 'package:flutter/material.dart';

import '../../../app/game_setup_scope.dart';
import '../data/category_word_bank.dart';
import '../logic/difficulty_settings.dart';
import '../logic/word_search_generator.dart';
import '../models/word_search_puzzle.dart';

/// Set to false to hide the debug section below the word list.
const bool kDebugWordSearch = true;

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({
    super.key,
    required this.category,
    required this.ageMode,
  });

  final String category;
  final AgeMode ageMode;

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  late WordSearchPuzzle _puzzle;
  final Set<String> _foundWords = {};
  final Map<String, List<List<int>>> _foundWordCells = {};
  final Set<String> _foundCellKeys = {};
  List<List<int>> _selection = [];
  List<int>? _dragStart;
  /// Locked direction (dr, dc) once user moves to a second cell; reset on selection end.
  int? _lockedDr;
  int? _lockedDc;
  bool _winDialogShown = false;
  bool _shownDiagonalSnackBarThisDrag = false;

  /// Placeholder: no backend yet; logs the reward for now.
  void _awardPoints(int amount) {
    // ignore: avoid_print
    print('WordSearchScreen: awardPoints($amount)');
  }

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  void _generatePuzzle() {
    final settings = widget.ageMode.wordSearchSettings;
    final words = CategoryWordBank.pickWords(
      category: widget.category,
      count: settings.wordCount,
      minLen: settings.minWordLength,
      maxLen: settings.maxWordLength,
    );
    final generator = WordSearchGenerator();
    _puzzle = generator.generate(
      gridSize: settings.gridSize,
      allowDiagonal: settings.allowDiagonal,
      allowBackward: settings.allowBackward,
      words: words,
    );
  }

  void _startNewPuzzle() {
    setState(() {
      _generatePuzzle();
      _foundWords.clear();
      _foundWordCells.clear();
      _foundCellKeys.clear();
      _selection = [];
      _dragStart = null;
      _lockedDr = null;
      _lockedDc = null;
      _winDialogShown = false;
      _shownDiagonalSnackBarThisDrag = false;
    });
  }

  List<List<String>> get _grid => _puzzle.grid;
  List<String> get _targetWords => _puzzle.targetWords;

  List<List<int>> _lineCells(int r0, int c0, int r1, int c1) {
    final n = _grid.length;
    final dr = r1 - r0;
    final dc = c1 - c0;
    if (dr == 0 && dc == 0) {
      if (r0 >= 0 && r0 < n && c0 >= 0 && c0 < n) return [[r0, c0]];
      return [];
    }
    if (dr != 0 && dc != 0 && dr.abs() != dc.abs()) return [];
    final stepR = dr == 0 ? 0 : (dr > 0 ? 1 : -1);
    final stepC = dc == 0 ? 0 : (dc > 0 ? 1 : -1);
    final out = <List<int>>[];
    var r = r0;
    var c = c0;
    while (r >= 0 && r < n && c >= 0 && c < n) {
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
      final r = cell[0], c = cell[1];
      if (r >= 0 && r < _grid.length && c >= 0 && c < _grid[0].length) {
        buffer.write(_grid[r][c]);
      }
    }
    return buffer.toString();
  }

  void _onSelectionStart(int r, int c) {
    setState(() {
      _dragStart = [r, c];
      _selection = [[r, c]];
      _lockedDr = null;
      _lockedDc = null;
      _shownDiagonalSnackBarThisDrag = false;
    });
  }

  void _onSelectionUpdate(int r, int c) {
    if (_dragStart == null) return;
    final r0 = _dragStart![0], c0 = _dragStart![1];
    final settings = widget.ageMode.wordSearchSettings;
    final n = _grid.length;

    setState(() {
      if (_lockedDr != null && _lockedDc != null) {
        // Direction locked: snap selection to the line (r0 + t*dr, c0 + t*dc).
        final dr = _lockedDr!, dc = _lockedDc!;
        int? bestT;
        var bestDist = 0x7FFFFFFFF;
        for (var t = -n; t <= n; t++) {
          final r1 = r0 + t * dr;
          final c1 = c0 + t * dc;
          if (r1 >= 0 && r1 < n && c1 >= 0 && c1 < n) {
            final d = (r1 - r) * (r1 - r) + (c1 - c) * (c1 - c);
            if (d < bestDist) {
              bestDist = d;
              bestT = t;
            }
          }
        }
        if (bestT != null) {
          final r1 = r0 + bestT * dr;
          final c1 = c0 + bestT * dc;
          _selection = _lineCells(r0, c0, r1, c1);
        }
        return;
      }

      // Not locked: same cell or first move to second cell.
      if (r == r0 && c == c0) {
        _selection = [_dragStart!];
        return;
      }
      final line = _lineCells(r0, c0, r, c);
      final isDiagonal = line.length > 1 && (r != r0 && c != c0);
      final rejectDiagonal = !settings.allowDiagonal && isDiagonal;

      if (rejectDiagonal) {
        _selection = [_dragStart!];
        if (!_shownDiagonalSnackBarThisDrag && mounted) {
          _shownDiagonalSnackBarThisDrag = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Diagonal not allowed')),
            );
          });
        }
        return;
      }
      if (line.length > 1) {
        _selection = line;
        _lockedDr = (r - r0).sign;
        _lockedDc = (c - c0).sign;
      } else {
        _selection = [_dragStart!];
      }
    });
  }

  void _onSelectionEnd() {
    if (_selection.isEmpty) {
      setState(() {
        _dragStart = null;
        _selection = [];
      });
      return;
    }
    final settings = widget.ageMode.wordSearchSettings;
    final word = _wordFromCells(_selection);
    final reversed = _wordFromCells(_selection.reversed.toList());
    String? matched;
    if (_targetWords.contains(word)) matched = word;
    if (matched == null && settings.allowBackward && _targetWords.contains(reversed)) {
      matched = reversed;
    }

    setState(() {
      if (matched != null && !_foundWords.contains(matched)) {
        _foundWords.add(matched);
        _foundWordCells[matched] = List.from(_selection);
        for (final cell in _selection) {
          _foundCellKeys.add('${cell[0]}:${cell[1]}');
        }
      }
      _dragStart = null;
      _selection = [];
      _lockedDr = null;
      _lockedDc = null;
    });

    if (!_winDialogShown && _foundWords.length == _targetWords.length) {
      _winDialogShown = true;
      _awardPoints(50);
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('You Win'),
          content: const Text('You found all the words!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = widget.ageMode.wordSearchSettings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Search'),
        actions: [
          TextButton.icon(
            onPressed: _startNewPuzzle,
            icon: const Icon(Icons.refresh),
            label: const Text('New Puzzle'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                    label: Text(widget.category),
                    onPressed: null,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: WordGrid(
                    grid: _grid,
                    selection: _selection,
                    foundCellKeys: _foundCellKeys,
                    onSelectionStart: _onSelectionStart,
                    onSelectionUpdate: _onSelectionUpdate,
                    onSelectionEnd: _onSelectionEnd,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                    children: _targetWords.map((w) {
                      final found = _foundWords.contains(w);
                      return Text(
                        w,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: found ? TextDecoration.lineThrough : null,
                          color: found
                              ? theme.colorScheme.onSurfaceVariant.withOpacity(0.7)
                              : theme.colorScheme.onSurface,
                          fontWeight: found ? FontWeight.w500 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  if (kDebugWordSearch) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Text(
                      'Debug',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'gridSize: ${settings.gridSize}, wordCount: ${settings.wordCount}\n'
                      'allowDiagonal: ${settings.allowDiagonal}, allowBackward: ${settings.allowBackward}\n'
                      'minWordLength: ${settings.minWordLength}, maxWordLength: ${settings.maxWordLength}\n'
                      'words: ${_targetWords.join(", ")}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Interactive word search grid. Handles drag selection (mouse and touch).
/// Reports cell indices for start/update; parent computes straight-line selection and match.
class WordGrid extends StatelessWidget {
  const WordGrid({
    super.key,
    required this.grid,
    required this.selection,
    required this.foundCellKeys,
    required this.onSelectionStart,
    required this.onSelectionUpdate,
    required this.onSelectionEnd,
  });

  final List<List<String>> grid;
  final List<List<int>> selection;
  final Set<String> foundCellKeys;
  final void Function(int r, int c) onSelectionStart;
  final void Function(int r, int c) onSelectionUpdate;
  final VoidCallback onSelectionEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final n = grid.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.width > constraints.biggest.height
            ? constraints.biggest.height
            : constraints.biggest.width;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            final r = (details.localPosition.dy / (side / n)).floor().clamp(0, n - 1);
            final c = (details.localPosition.dx / (side / n)).floor().clamp(0, n - 1);
            onSelectionStart(r, c);
          },
          onPanUpdate: (details) {
            final r = (details.localPosition.dy / (side / n)).floor().clamp(0, n - 1);
            final c = (details.localPosition.dx / (side / n)).floor().clamp(0, n - 1);
            onSelectionUpdate(r, c);
          },
          onPanEnd: (_) => onSelectionEnd(),
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
                final isFound = foundCellKeys.contains('$r:$c');
                final isSelected = selection.any((cell) => cell[0] == r && cell[1] == c);
                final cs = theme.colorScheme;
                Color bg = cs.surface;
                if (isSelected) bg = cs.primaryContainer;
                else if (isFound) bg = cs.tertiaryContainer;
                return Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: cs.outlineVariant, width: 0.5),
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
        );
      },
    );
  }
}
