/// Position of a cell in the word search grid.
class CellPos {
  const CellPos({required this.row, required this.col});

  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellPos && row == other.row && col == other.col;

  @override
  int get hashCode => Object.hash(row, col);
}
