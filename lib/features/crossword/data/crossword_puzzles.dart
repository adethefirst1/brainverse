import 'dart:math';

import '../../../app/game_setup_scope.dart';
import '../logic/crossword_builder.dart';
import '../models/crossword_puzzle.dart';

/// Raw puzzle data: template (.#), solution (letters + #), and clue bank.
class RawCrosswordPuzzle {
  const RawCrosswordPuzzle({
    required this.gridTemplate,
    required this.solutionGrid,
    required this.clueBank,
    required this.title,
    required this.difficultyLabel,
  });

  final List<List<String>> gridTemplate;
  final List<List<String>> solutionGrid;
  final Map<String, String> clueBank;
  final String title;
  final String difficultyLabel;
}

// ─── Kids: 7×7, multiple across and down ────────────────────────────────────

final List<RawCrosswordPuzzle> kidsCrosswordsRaw = [
  RawCrosswordPuzzle(
    title: 'Pets',
    difficultyLabel: 'Easy',
    gridTemplate: [
      ['.', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['#', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
    ],
    solutionGrid: [
      ['C', 'A', 'T', '#', 'D', 'O', 'G'],
      ['A', 'R', 'E', 'O', 'O', 'T', 'O'],
      ['T', 'R', 'Y', 'G', 'O', 'O', 'D'],
      ['#', 'E', 'A', '#', 'D', 'A', 'Y'],
      ['R', 'A', 'T', 'E', 'N', 'D', 'S'],
      ['U', 'N', 'O', 'S', 'D', 'O', 'T'],
      ['N', 'D', 'S', 'E', 'E', 'E', 'S'],
    ],
    clueBank: {
      'CAT': 'Feline pet',
      'DOG': "Man's best friend",
      'ARE': 'Form of "be"',
      'TRY': 'Attempt',
      'EAR': 'You hear with it',
      'EAT': 'Have a meal',
      'GOOD': 'Not bad',
      'DAY': '24 hours',
      'RAT': 'Rodent',
      'END': 'Finish',
      'RUN': 'Move fast on foot',
      'ONE': 'Single',
      'SEE': 'Use your eyes',
      'NET': 'Catches fish',
      'ODD': 'Strange',
      'TOO': 'Also',
      'SET': 'Collection',
    },
  ),
  RawCrosswordPuzzle(
    title: 'Colors',
    difficultyLabel: 'Easy',
    gridTemplate: [
      ['.', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['#', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
    ],
    solutionGrid: [
      ['R', 'E', 'D', '#', 'B', 'L', 'UE'],
      ['U', 'N', 'I', 'L', 'U', 'E', 'S'],
      ['N', 'I', 'T', 'E', 'E', 'E', 'E'],
      ['#', 'T', 'S', '#', 'E', 'A', 'R'],
      ['B', 'E', 'E', 'A', 'R', 'T', 'S'],
      ['L', 'A', 'R', 'R', 'E', 'E', 'E'],
      ['U', 'E', 'E', 'D', 'S', 'E', 'E'],
    ],
    clueBank: {
      'RED': 'Color of an apple',
      'BLU': 'Sky color (short)',
      'RUN': 'What you do with your legs',
      'UNIT': 'One of something',
      'NIT': 'Egg of a louse',
      'BEE': 'Insect that makes honey',
      'EAR': 'You hear with it',
      'BEAR': 'Big furry animal',
      'ART': 'Painting and drawing',
      'SEA': 'Ocean',
      'LEE': 'Sheltered side',
      'EAT': 'Have food',
      'USE': 'Utilize',
      'TEA': 'Hot drink',
    },
  ),
  RawCrosswordPuzzle(
    title: 'Numbers',
    difficultyLabel: 'Easy',
    gridTemplate: [
      ['.', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['#', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
    ],
    solutionGrid: [
      ['O', 'N', 'E', '#', 'T', 'W', 'O'],
      ['N', 'I', 'N', 'W', 'E', 'N', 'O'],
      ['E', 'N', 'O', 'O', 'N', 'E', 'T'],
      ['#', 'E', 'N', '#', 'E', 'E', 'N'],
      ['T', 'W', 'O', 'T', 'N', 'I', 'N'],
      ['E', 'O', 'N', 'E', 'E', 'N', 'E'],
      ['N', 'T', 'E', 'N', 'T', 'E', 'N'],
    ],
    clueBank: {
      'ONE': 'First number',
      'TWO': 'One plus one',
      'ON': 'Opposite of off',
      'NET': 'Catches fish',
      'WIN': 'Beat the game',
      'NO': 'Opposite of yes',
      'TEN': 'Number after nine',
      'NINE': 'Three times three',
      'EON': 'Very long time',
      'TOTE': 'Carry',
      'NIT': 'Small egg',
    },
  ),
];

// ─── Teens: 7×7 ─────────────────────────────────────────────────────────────

final List<RawCrosswordPuzzle> teensCrosswordsRaw = [
  RawCrosswordPuzzle(
    title: 'School',
    difficultyLabel: 'Medium',
    gridTemplate: [
      ['.', '.', '.', '.', '#', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '#', '.', '.', '.'],
      ['#', '.', '.', '.', '.', '.', '#'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '#', '.', '.'],
    ],
    solutionGrid: [
      ['M', 'A', 'T', 'H', '#', 'A', 'R'],
      ['U', 'S', 'E', 'R', 'E', 'A', 'D'],
      ['S', 'I', 'C', 'E', 'N', 'C', 'E'],
      ['I', 'C', 'E', '#', 'P', 'E', 'N'],
      ['#', 'P', 'E', 'N', 'A', 'L', '#'],
      ['B', 'O', 'O', 'K', 'S', 'E', 'E'],
      ['O', 'K', 'S', 'E', '#', 'N', 'E'],
    ],
    clueBank: {
      'MATH': 'Subject with numbers',
      'ART': 'Painting and drawing',
      'USER': 'Someone who uses something',
      'READ': 'Look at words',
      'SCIENCE': 'Study of the natural world',
      'ICE': 'Frozen water',
      'PEN': 'Writing tool',
      'PENAL': 'Related to punishment',
      'ALL': 'Everything',
      'BOOK': 'You read it',
      'SEEK': 'Look for',
      'NET': 'Internet',
      'MUSE': 'Inspire',
      'USE': 'Utilize',
    },
  ),
  RawCrosswordPuzzle(
    title: 'Nature',
    difficultyLabel: 'Medium',
    gridTemplate: [
      ['.', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['#', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
    ],
    solutionGrid: [
      ['S', 'U', 'N', '#', 'T', 'R', 'E'],
      ['E', 'A', 'R', 'R', 'R', 'E', 'E'],
      ['A', 'R', 'T', 'E', 'E', 'D', 'S'],
      ['#', 'E', 'E', '#', 'E', 'A', 'R'],
      ['T', 'R', 'E', 'E', 'S', 'E', 'E'],
      ['R', 'E', 'E', 'D', 'E', 'E', 'D'],
      ['E', 'D', 'S', 'E', 'E', 'D', 'S'],
    ],
    clueBank: {
      'SUN': 'Star that gives daylight',
      'TREE': 'Tall plant with a trunk',
      'SAD': 'Not happy',
      'EAR': 'You hear with it',
      'ART': 'Painting',
      'RED': 'Color',
      'SEE': 'Use your eyes',
      'TREES': 'Forest has many',
      'REED': 'Plant by the water',
      'SEED': 'Grows into a plant',
      'EAT': 'Have a meal',
    },
  ),
  RawCrosswordPuzzle(
    title: 'Sports',
    difficultyLabel: 'Medium',
    gridTemplate: [
      ['.', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['#', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
    ],
    solutionGrid: [
      ['R', 'U', 'N', '#', 'B', 'A', 'T'],
      ['U', 'M', 'P', 'I', 'A', 'L', 'L'],
      ['N', 'P', 'S', 'C', 'L', 'E', 'E'],
      ['#', 'I', 'C', '#', 'E', 'A', 'R'],
      ['G', 'O', 'L', 'F', 'E', 'E', 'D'],
      ['O', 'L', 'E', 'E', 'N', 'D', 'S'],
      ['L', 'E', 'D', 'E', 'D', 'S', 'T'],
    ],
    clueBank: {
      'RUN': 'Move fast on foot',
      'BAT': 'Used in baseball',
      'UMP': 'Baseball referee',
      'PIC': 'Picture',
      'ICE': 'Frozen water',
      'GOLF': 'Sport with clubs',
      'GOAL': 'Score in soccer',
      'LED': 'Past of lead',
      'END': 'Finish',
    },
  ),
];

// ─── Adults: 7×7 (consistent) ───────────────────────────────────────────────

final List<RawCrosswordPuzzle> adultsCrosswordsRaw = [
  RawCrosswordPuzzle(
    title: 'Vocabulary',
    difficultyLabel: 'Hard',
    gridTemplate: [
      ['.', '.', '.', '.', '#', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '#', '.', '.', '.'],
      ['#', '.', '.', '.', '.', '.', '#'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '#', '.', '.'],
    ],
    solutionGrid: [
      ['E', 'X', 'P', 'A', '#', 'L', 'O'],
      ['V', 'E', 'R', 'B', 'O', 'G', 'I'],
      ['E', 'R', 'A', 'E', 'M', 'I', 'C'],
      ['R', 'B', 'E', '#', 'I', 'T', 'E'],
      ['#', 'O', 'M', 'I', 'T', 'S', '#'],
      ['S', 'G', 'I', 'T', 'E', 'E', 'S'],
      ['E', 'I', 'C', 'E', '#', 'N', 'E'],
    ],
    clueBank: {
      'EXPA': 'Word: EXPA',
      'EXPAND': 'To make something bigger',
      'LOGI': 'Word: LOGI',
      'LOGIC': 'Logical reasoning',
      'VERB': 'Action word',
      'OGRE': 'Giant monster',
      'ERA': 'Period of time',
      'OMIT': 'To leave out',
      'BEAR': 'Large animal',
      'EAT': 'Have a meal',
      'ICE': 'Frozen water',
    },
  ),
  RawCrosswordPuzzle(
    title: 'General',
    difficultyLabel: 'Hard',
    gridTemplate: [
      ['.', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['#', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
    ],
    solutionGrid: [
      ['T', 'R', 'U', 'E', '#', 'G', 'E'],
      ['R', 'U', 'E', 'E', 'E', 'E', 'T'],
      ['U', 'E', 'E', 'E', 'A', 'T', 'O'],
      ['#', 'O', 'R', '#', 'E', 'A', 'R'],
      ['O', 'P', 'E', 'N', 'E', 'C', 'E'],
      ['P', 'E', 'A', 'E', 'N', 'E', 'A'],
      ['E', 'N', 'E', 'E', 'E', 'A', 'N'],
    ],
    clueBank: {
      'TRUE': 'Not false',
      'GET': 'To obtain',
      'OR': 'Word: OR',
      'EAR': 'You hear with it',
      'RUE': 'Regret',
      'TOP': 'Highest point',
      'OCEAN': 'Large body of water',
      'OPEN': 'Not closed',
      'PEA': 'Small green vegetable',
    },
  ),
  RawCrosswordPuzzle(
    title: 'Words',
    difficultyLabel: 'Hard',
    gridTemplate: [
      ['.', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['#', '.', '.', '#', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
      ['.', '.', '.', '.', '.', '.', '.'],
    ],
    solutionGrid: [
      ['W', 'O', 'R', 'D', '#', 'B', 'O'],
      ['O', 'R', 'E', 'O', 'O', 'O', 'O'],
      ['R', 'E', 'A', 'D', 'O', 'K', 'K'],
      ['#', 'O', 'D', '#', 'K', 'E', 'S'],
      ['B', 'O', 'K', 'E', 'E', 'E', 'E'],
      ['O', 'K', 'E', 'E', 'N', 'D', 'E'],
      ['K', 'E', 'E', 'E', 'E', 'E', 'E'],
    ],
    clueBank: {
      'WORD': 'Unit of language',
      'BOOK': 'You read it',
      'ORE': 'Mined mineral',
      'READ': 'Look at words',
      'ODD': 'Strange',
      'KEY': 'Opens a lock',
      'END': 'Finish',
    },
  ),
];

/// Returns a random crossword for [ageMode]. Uses [crossword_builder] to derive
/// Across/Down clues from template + solution + clue bank. Grid is a deep copy.
CrosswordPuzzle getRandomCrossword(AgeMode ageMode) {
  final list = switch (ageMode) {
    AgeMode.kids => kidsCrosswordsRaw,
    AgeMode.teens => teensCrosswordsRaw,
    AgeMode.adults => adultsCrosswordsRaw,
  };
  final raw = list[Random().nextInt(list.length)];
  final puzzle = buildCrosswordPuzzle(
    gridTemplate: raw.gridTemplate,
    solutionGrid: raw.solutionGrid,
    clueBank: raw.clueBank,
    title: raw.title,
    difficultyLabel: raw.difficultyLabel,
  );
  final gridCopy = puzzle.grid.map((row) => List<String>.from(row)).toList();
  return CrosswordPuzzle(
    grid: gridCopy,
    acrossClues: puzzle.acrossClues,
    downClues: puzzle.downClues,
    title: puzzle.title,
    difficultyLabel: puzzle.difficultyLabel,
  );
}
