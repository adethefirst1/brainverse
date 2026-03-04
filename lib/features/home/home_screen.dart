import 'package:flutter/material.dart';

import '../../app/game_setup_scope.dart';
import '../crossword/screens/crossword_screen.dart';
import '../profile/profile_screen.dart';
import '../setup/category_and_age_setup_screen.dart';
import '../sudoku/sudoku_screen.dart';
import '../wallet/wallet_screen.dart';
import '../word_search/screens/word_search_screen.dart';
import '../word_wipe/word_wipe_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static List<_GameCardData> get _games => [
    _GameCardData(
      title: 'Word Wipe',
      subtitle: 'Clear the board by finding words.',
      showCategory: true,
      nextScreenBuilder: (_) => WordWipeScreen(),
    ),
    _GameCardData(
      title: 'Crossword',
      subtitle: 'Fill the grid with words and clues.',
      showCategory: true,
      nextScreenBuilder: (data) => CrosswordScreen(
        ageMode: data.ageMode,
        category: data.category,
      ),
    ),
    _GameCardData(
      title: 'Word Search',
      subtitle: 'Find hidden words in the grid.',
      showCategory: true,
      nextScreenBuilder: (data) => WordSearchScreen(
        category: data.category,
        ageMode: data.ageMode,
      ),
    ),
    _GameCardData(
      title: 'Sudoku',
      subtitle: 'Fill rows, columns and boxes with 1–9.',
      showCategory: false,
      nextScreenBuilder: (setupData) => SudokuScreen(ageMode: setupData.ageMode),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width > 900 ? 4 : (width > 600 ? 2 : 1);
    final padding = width > 600 ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Puzzle Games"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WalletScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: width > 600 ? 1.4 : 1.1,
            physics: const BouncingScrollPhysics(),
            children: _games.map((game) => _GameCard(data: game)).toList(),
          ),
        ),
      ),
    );
  }
}

class _GameCardData {
  const _GameCardData({
    required this.title,
    required this.subtitle,
    required this.showCategory,
    required this.nextScreenBuilder,
  });

  final String title;
  final String subtitle;
  final bool showCategory;
  final Widget Function(GameSetupData setupData) nextScreenBuilder;
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.data});

  final _GameCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryAndAgeSetupScreen(
                nextScreenBuilder: data.nextScreenBuilder,
                showCategory: data.showCategory,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
