import 'crossword_clue.dart';

/// Immutable crossword puzzle.
/// - [grid]: "#" = black block, A-Z = letter, "." = empty cell to fill
/// - [acrossClues] / [downClues]: clues in number order
/// - [title], [difficultyLabel]: display strings
class CrosswordPuzzle {
  const CrosswordPuzzle({
    required this.grid,
    required this.acrossClues,
    required this.downClues,
    required this.title,
    required this.difficultyLabel,
  });

  final List<List<String>> grid;
  final List<CrosswordClue> acrossClues;
  final List<CrosswordClue> downClues;
  final String title;
  final String difficultyLabel;
}
