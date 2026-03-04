/// Word search puzzle: grid, target words, and which have been found.
class WordSearchPuzzle {
  const WordSearchPuzzle({
    required this.grid,
    required this.targetWords,
    this.foundWords = const {},
  });

  final List<List<String>> grid;
  final List<String> targetWords;
  final Set<String> foundWords;

  WordSearchPuzzle copyWith({
    List<List<String>>? grid,
    List<String>? targetWords,
    Set<String>? foundWords,
  }) {
    return WordSearchPuzzle(
      grid: grid ?? this.grid,
      targetWords: targetWords ?? this.targetWords,
      foundWords: foundWords ?? this.foundWords,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordSearchPuzzle &&
          _gridEquals(grid, other.grid) &&
          _listEquals(targetWords, other.targetWords) &&
          _setEquals(foundWords, other.foundWords);

  bool _gridEquals(List<List<String>> a, List<List<String>> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_listEquals(a[i], b[i])) return false;
    }
    return true;
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b) && b.containsAll(a);
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(grid.expand((row) => row)),
        Object.hashAll(targetWords),
        Object.hashAll(foundWords),
      );
}
