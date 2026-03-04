/// Word bank for Word Wipe, grouped by setup categories.
/// Keys match [kSetupCategories]: General, Animals, Science, Sports, etc.
class WordWipeWordBank {
  /// Raw words per category. Use [dictionaryFor] for filtered, uppercase sets.
  static const Map<String, List<String>> wordsByCategory = {
    'General': [
      'PUZZLE', 'BRAIN', 'LOGIC', 'RIDDLE', 'PATTERN', 'NUMBER', 'LETTER',
      'GUESS', 'HINT', 'CLUE', 'SEARCH', 'MATCH', 'GRID', 'LEVEL', 'SCORE',
      'TIMER', 'ROUND', 'STREAK', 'COMBO', 'POINTS', 'WINNER', 'PLAYER',
      'CHALLENGE', 'SKILL', 'FOCUS', 'MEMORY', 'STRATEGY', 'RANDOM', 'TARGET',
      'REWARD', 'BONUS', 'MODE', 'TILE', 'GAME', 'FUN', 'EASY', 'HARD',
      'SOLVE', 'ANSWER', 'QUESTION', 'CHOICE', 'LUCK', 'SPEED', 'QUICK',
      'CLEVER', 'SMART', 'THINK', 'LEARN', 'PRACTICE', 'MASTER', 'EXPERT',
      'BEGINNER', 'FINISH', 'START', 'PAUSE', 'RESUME', 'RETRY', 'NEXT',
    ],
    'Animals': [
      'CAT', 'DOG', 'BIRD', 'FISH', 'LION', 'TIGER', 'BEAR', 'WOLF', 'EAGLE',
      'MOUSE', 'HORSE', 'SHEEP', 'GOAT', 'ZEBRA', 'PANDA', 'KOALA', 'MONKEY',
      'GORILLA', 'RABBIT', 'FROG', 'SNAKE', 'SHARK', 'WHALE', 'DOLPHIN', 'OTTER',
      'DEER', 'DUCK', 'OWL', 'FOX', 'LLAMA', 'CAMEL', 'CHEETAH', 'LEOPARD',
      'HIPPO', 'ELEPHANT', 'GIRAFFE', 'KANGAROO', 'PENGUIN', 'PARROT', 'CROW',
      'SWAN', 'PELICAN', 'FLAMINGO', 'PEACOCK', 'TURKEY', 'CHICKEN', 'COW',
      'PIG', 'HEDGEHOG', 'SQUIRREL', 'BEAVER', 'RACCOON', 'SKUNK', 'BADGER',
      'OTTER', 'SEAL', 'WALRUS', 'OCTOPUS', 'JELLYFISH', 'CRAB', 'LOBSTER',
      'TURTLE', 'CROCODILE', 'LIZARD', 'CHAMELEON', 'ANT', 'BEE', 'BUTTERFLY',
    ],
    'Science': [
      'ATOM', 'MOLECULE', 'ENERGY', 'GRAVITY', 'PLANET', 'GALAXY', 'NEBULA',
      'ORBIT', 'FORCE', 'MOTION', 'MASS', 'VOLUME', 'DENSITY', 'CELL', 'TISSUE',
      'ORGAN', 'SPECIES', 'EVOLUTION', 'GENE', 'PROTEIN', 'NEURON', 'CIRCUIT',
      'CURRENT', 'VOLTAGE', 'MAGNET', 'LASER', 'ROBOT', 'CHEMISTRY', 'PHYSICS',
      'BIOLOGY', 'ECOLOGY', 'MINERAL', 'CRYSTAL', 'SATELLITE', 'TELESCOPE',
      'MICROSCOPE', 'EXPERIMENT', 'THEORY', 'HYPOTHESIS', 'DATA', 'RESEARCH',
      'OXYGEN', 'HYDROGEN', 'CARBON', 'NITROGEN', 'ELEMENT', 'COMPOUND',
      'REACTION', 'SOLUTION', 'ACID', 'BASE', 'ELECTRON', 'PROTON', 'NEUTRON',
      'QUANTUM', 'RADIATION', 'WAVELENGTH', 'SPECTRUM', 'FOSSIL', 'BACTERIA',
      'VIRUS', 'VACCINE', 'CLIMATE', 'WEATHER', 'PRESSURE', 'TEMPERATURE',
    ],
    'Sports': [
      'SOCCER', 'FOOTBALL', 'BASKETBALL', 'BASEBALL', 'TENNIS', 'CRICKET',
      'RUGBY', 'HOCKEY', 'GOLF', 'BOXING', 'CYCLING', 'SKATING', 'SKIING',
      'SURFING', 'RUNNING', 'RACING', 'MARATHON', 'SPRINT', 'JUDO', 'KARATE',
      'ARCHERY', 'FENCING', 'VOLLEYBALL', 'HANDBALL', 'BOWLING', 'GYMNAST',
      'STADIUM', 'CHAMPION', 'COACH', 'REFEREE', 'TEAM', 'PLAYER', 'GOAL',
      'TOURNAMENT', 'MEDAL', 'TROPHY', 'SCORE', 'MATCH', 'LEAGUE', 'SEASON',
      'TRAINING', 'FITNESS', 'WEIGHTS', 'STRETCH', 'WARMUP', 'COOLDOWN',
      'RELAY', 'DIVING', 'SWIMMING', 'ROWING', 'CANOE', 'CLIMBING', 'BIATHLON',
      'TRIATHLON', 'DECATHLON', 'POLEVAULT', 'LONGJUMP', 'SHOTPUT', 'DISCUS',
      'JAVELIN', 'HURDLES', 'BENCH', 'CLEATS', 'UNIFORM', 'WHISTLE',
    ],
    'Geography': [
      'MOUNTAIN', 'VALLEY', 'RIVER', 'OCEAN', 'ISLAND', 'DESERT', 'FOREST',
      'GLACIER', 'PENINSULA', 'PLATEAU', 'CANYON', 'DELTA', 'HARBOR', 'COAST',
      'BAY', 'STRAIT', 'CONTINENT', 'COUNTRY', 'CAPITAL', 'CITY', 'VILLAGE',
      'REGION', 'CLIMATE', 'TROPIC', 'ARCTIC', 'EQUATOR', 'HEMISPHERE',
      'MERIDIAN', 'MAP', 'COMPASS', 'LATITUDE', 'LONGITUDE', 'LANDMARK',
      'VOLCANO', 'LAKE', 'STREAM', 'CREEK', 'WATERFALL', 'RESERVOIR', 'BASIN',
      'COASTLINE', 'SHORELINE', 'REEF', 'ATOLL', 'SAVANNA', 'JUNGLE', 'MARSH',
      'SWAMP', 'TUNDRA', 'STEPPE', 'PRAIRIE', 'HIGHLAND', 'LOWLAND', 'RIDGE',
      'SUMMIT', 'PEAK', 'FOOTHILL', 'DUNES', 'OASIS', 'ESTUARY', 'FJORD',
      'ARCHIPELAGO', 'ISTHMUS', 'BORDER', 'FRONTIER', 'TERRITORY', 'PROVINCE',
    ],
    'History': [
      'EMPIRE', 'KINGDOM', 'DYNASTY', 'BATTLE', 'REVOLUTION', 'COLONY',
      'PHARAOH', 'PYRAMID', 'CASTLE', 'KNIGHT', 'SAMURAI', 'WARRIOR', 'TREATY',
      'INVENTION', 'EXPLORER', 'VOYAGE', 'CRUSADE', 'RENAISSANCE', 'MEDIEVAL',
      'ANCIENT', 'ARCHIVE', 'CHRONICLE', 'MONUMENT', 'ARTIFACT', 'CIVILIZATION',
      'PARCHMENT', 'SCROLL', 'TIMELINE', 'HISTORIAN', 'MUSEUM', 'EMPEROR',
      'CONQUEST', 'CAPITOL', 'COLISEUM', 'LEGION', 'SENATE', 'REPUBLIC',
      'MONARCHY', 'DEMOCRACY', 'CONSTITUTION', 'DECLARATION', 'INDEPENDENCE',
      'SETTLEMENT', 'MIGRATION', 'NOMAD', 'TRIBE', 'CLAN', 'DIPLOMAT',
      'AMBASSADOR', 'SIEGE', 'FORTRESS', 'BARRACKS', 'BATTALION', 'REGIMENT',
      'CORONATION', 'THRONE', 'SCEPTER', 'CROWN', 'RELIC', 'RUINS', 'EXCAVATION',
      'FOSSIL', 'MANUSCRIPT', 'CODEX', 'INSCRIPTION', 'HIEROGLYPH', 'LEGEND',
    ],
    'Music': [
      'MELODY', 'RHYTHM', 'HARMONY', 'TEMPO', 'LYRICS', 'CHORD', 'SCALE',
      'NOTE', 'DRUM', 'GUITAR', 'PIANO', 'VIOLIN', 'TRUMPET', 'FLUTE', 'CELLO',
      'SAXOPHONE', 'ORCHESTRA', 'BAND', 'SINGER', 'VOCAL', 'CHOIR', 'CONCERT',
      'STUDIO', 'ALBUM', 'TRACK', 'PLAYLIST', 'HEADPHONE', 'VOLUME', 'REMIX',
      'BEAT', 'SYMPHONY', 'OPERA', 'BALLET', 'JAZZ', 'BLUES', 'ROCK', 'POP',
      'CLASSICAL', 'FOLK', 'COUNTRY', 'REGGAE', 'HIPHOP', 'ELECTRONIC', 'BASS',
      'KEYBOARD', 'PERCUSSION', 'TROMBONE', 'CLARINET', 'OBOE', 'HARP',
      'BANJO', 'MANDOLIN', 'ACCORDION', 'HARMONICA', 'MICROPHONE', 'AMPLIFIER',
      'SPEAKER', 'AUDIENCE', 'ENCORE', 'REHEARSAL', 'COMPOSER', 'CONDUCTOR',
      'SOLO', 'DUET', 'QUARTET', 'ENSEMBLE', 'CADENCE', 'OCTAVE', 'FORTE',
    ],
    'Nature': [
      'TREE', 'FLOWER', 'RIVER', 'LAKE', 'MOUNTAIN', 'VALLEY', 'OCEAN',
      'FOREST', 'DESERT', 'PRAIRIE', 'RAINFOREST', 'MEADOW', 'ISLAND', 'CLOUD',
      'RAIN', 'THUNDER', 'LIGHTNING', 'SUNRISE', 'SUNSET', 'BREEZE', 'STORM',
      'SEASON', 'AUTUMN', 'WINTER', 'SPRING', 'SUMMER', 'ROCK', 'MINERAL',
      'SOIL', 'ROOT', 'LEAF', 'BRANCH', 'BLOSSOM', 'HABITAT', 'WILDLIFE',
      'ECOSYSTEM', 'CANOPY', 'UNDERGROWTH', 'MOSS', 'FERN', 'VINE', 'BUSH',
      'SHRUB', 'GRASS', 'WEED', 'POLLEN', 'SEED', 'BULB', 'PETAL', 'STEM',
      'THORN', 'BARK', 'TRUNK', 'GROVE', 'THICKET', 'MARSH', 'WETLAND',
      'POND', 'STREAM', 'CREEK', 'WATERFALL', 'GLACIER', 'SNOW', 'FROST',
      'DEW', 'MIST', 'FOG', 'HAIL', 'SLEET', 'HURRICANE', 'TORNADO', 'DROUGHT',
    ],
    'Food': [
      'BREAD', 'CHEESE', 'BUTTER', 'PASTA', 'PIZZA', 'BURGER', 'SALAD', 'SOUP',
      'SANDWICH', 'TACO', 'SUSHI', 'NOODLE', 'STEAK', 'OMELET', 'PANCAKE',
      'WAFFLE', 'YOGURT', 'COOKIE', 'BROWNIE', 'MUFFIN', 'CARROT', 'TOMATO',
      'ONION', 'GARLIC', 'BANANA', 'ORANGE', 'APPLE', 'BERRY', 'LEMON', 'PEACH',
      'SPICE', 'PEPPER', 'HONEY', 'SAUCE', 'RICE', 'BEANS', 'LENTIL', 'QUINOA',
      'OATMEAL', 'CEREAL', 'TOAST', 'JAM', 'JELLY', 'SYRUP', 'CREAM', 'MILK',
      'COFFEE', 'TEA', 'JUICE', 'SMOOTHIE', 'SODA', 'WATER', 'VINEGAR', 'OIL',
      'FLOUR', 'SUGAR', 'SALT', 'CINNAMON', 'NUTMEG', 'BASIL', 'OREGANO',
      'CILANTRO', 'MINT', 'GINGER', 'TURMERIC', 'CUMIN', 'PAPRIKA', 'CORIANDER',
      'AVOCADO', 'BROCCOLI', 'SPINACH', 'POTATO', 'CORN', 'PEAS', 'CELERY',
    ],
    'Travel': [
      'JOURNEY', 'VOYAGE', 'TICKET', 'PASSPORT', 'LUGGAGE', 'SUITCASE',
      'AIRPORT', 'STATION', 'HOTEL', 'HOSTEL', 'MOTEL', 'RESORT', 'CRUISE',
      'FLIGHT', 'TRANSIT', 'SUBWAY', 'TRAM', 'TAXI', 'SHUTTLE', 'CARPOOL',
      'MAP', 'GUIDEBOOK', 'ITINERARY', 'TOURIST', 'SOUVENIR', 'CAMERA',
      'BACKPACK', 'JOURNAL', 'ADVENTURE', 'EXPLORE', 'LANDMARK', 'DESTINATION',
      'DEPARTURE', 'ARRIVAL', 'BOARDING', 'GATE', 'TERMINAL', 'CHECKIN',
      'VISA', 'CUSTOMS', 'IMMIGRATION', 'LAYOVER', 'CONNECTION', 'DOMESTIC',
      'INTERNATIONAL', 'COACH', 'FIRSTCLASS', 'AISLE', 'WINDOW', 'CABIN',
      'DECK', 'ANCHOR', 'FERRY', 'YACHT', 'RENTAL', 'BOOKING', 'RESERVATION',
      'CANCELLATION', 'UPGRADE', 'LOUNGE', 'BAGGAGE', 'CARRYON', 'ROUTE',
      'STAMP', 'CURRENCY', 'EXCHANGE', 'TOUR', 'GUIDE', 'EXCURSION', 'TRIP',
    ],
  };

  /// Returns a set of valid dictionary words for [category] with length >= [minLen].
  /// Words are uppercase with spaces and punctuation stripped.
  /// Falls back to 'General' if [category] is not in [wordsByCategory].
  static Set<String> dictionaryFor({
    required String category,
    required int minLen,
  }) {
    final raw = wordsByCategory[category] ?? wordsByCategory['General'] ?? const <String>[];
    return raw
        .map((w) => w.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), ''))
        .where((w) => w.isNotEmpty && w.length >= minLen)
        .toSet();
  }
}
