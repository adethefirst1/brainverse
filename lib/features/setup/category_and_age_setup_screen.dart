import 'package:flutter/material.dart';

import '../../app/game_setup_scope.dart';

/// Predefined categories for the dropdown.
const List<String> kSetupCategories = [
  'General',
  'Animals',
  'Science',
  'Sports',
  'Geography',
  'History',
  'Music',
  'Nature',
  'Food',
  'Travel',
];

/// Shown before starting a game. User picks category and age mode; Continue
/// saves to app state and navigates to the screen built by [nextScreenBuilder].
/// When [showCategory] is false (e.g. Sudoku), the category dropdown is hidden.
class CategoryAndAgeSetupScreen extends StatefulWidget {
  const CategoryAndAgeSetupScreen({
    super.key,
    required this.nextScreenBuilder,
    this.showCategory = true,
  });

  final Widget Function(GameSetupData setupData) nextScreenBuilder;
  final bool showCategory;

  @override
  State<CategoryAndAgeSetupScreen> createState() =>
      _CategoryAndAgeSetupScreenState();
}

class _CategoryAndAgeSetupScreenState extends State<CategoryAndAgeSetupScreen> {
  String _category = kSetupCategories.first;
  AgeMode _ageMode = AgeMode.adults;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final scope = GameSetupScope.maybeOf(context);
    if (scope != null) {
      setState(() {
        _category = scope.data.category;
        _ageMode = scope.data.ageMode;
      });
    }
  }

  void _onContinue() {
    final setupData = GameSetupData(
      category: _category,
      ageMode: _ageMode,
    );
    GameSetupScope.of(context).onUpdate(setupData);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => widget.nextScreenBuilder(setupData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Game setup')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showCategory) ...[
                Text(
                  'Category',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownMenu<String>(
                  key: ValueKey(_category),
                  initialSelection: _category,
                  dropdownMenuEntries: kSetupCategories
                      .map((c) => DropdownMenuEntry(value: c, label: c))
                      .toList(),
                  onSelected: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                  width: MediaQuery.sizeOf(context).width - 48,
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
              Text(
                'Age mode',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<AgeMode>(
                segments: AgeMode.values
                    .map((e) => ButtonSegment<AgeMode>(
                          value: e,
                          label: Text(e.label),
                        ))
                    .toList(),
                selected: {_ageMode},
                onSelectionChanged: (Set<AgeMode> selected) {
                  setState(() => _ageMode = selected.first);
                },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: _onContinue,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
