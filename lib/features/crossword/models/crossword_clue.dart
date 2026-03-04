/// A single clue (across or down) with position and answer.
class CrosswordClue {
  const CrosswordClue({
    required this.number,
    required this.clue,
    required this.answer,
    required this.row,
    required this.col,
    required this.length,
  });

  final int number;
  final String clue;
  final String answer;
  final int row;
  final int col;
  final int length;
}
