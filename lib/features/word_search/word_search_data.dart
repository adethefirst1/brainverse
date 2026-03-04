/// Category-based word lists for Word Search. MVP: one hardcoded category.
const Map<String, List<String>> kWordSearchCategories = {
  'Animals': [
    'CAT',
    'DOG',
    'BIRD',
    'FISH',
    'LION',
    'BEAR',
    'WOLF',
    'DEER',
    'DUCK',
    'OWL',
    'FROG',
    'SNAKE',
  ],
};

String get defaultWordSearchCategory => 'Animals';

List<String> wordListForCategory(String category) {
  return List.from(kWordSearchCategories[category] ?? kWordSearchCategories[defaultWordSearchCategory]!);
}
