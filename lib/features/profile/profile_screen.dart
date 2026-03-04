import 'package:flutter/material.dart';

import '../../app/game_setup_scope.dart';
import '../../app/profile_scope.dart';
import '../setup/category_and_age_setup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _countryController;
  late AgeMode _ageMode;
  late String _preferredCategory;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final profile = ProfileScope.maybeOf(context)?.profile;
    if (profile != null) {
      _usernameController = TextEditingController(text: profile.username);
      _countryController = TextEditingController(text: profile.country);
      _ageMode = profile.ageMode;
      _preferredCategory = profile.preferredCategory;
    } else {
      _usernameController = TextEditingController(text: 'Player');
      _countryController = TextEditingController();
      _ageMode = AgeMode.adults;
      _preferredCategory = 'General';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _save() {
    final scope = ProfileScope.of(context);
    final updated = scope.profile.copyWith(
      username: _usernameController.text.trim().isEmpty
          ? 'Player'
          : _usernameController.text.trim(),
      country: _countryController.text.trim(),
      ageMode: _ageMode,
      preferredCategory: _preferredCategory,
    );
    scope.saveProfile(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Avatar (placeholder)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  hintText: 'Your display name',
                ),
                textCapitalization: TextCapitalization.none,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. United States',
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),
              Text(
                'Age mode',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 24),
              Text(
                'Preferred category',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              DropdownMenu<String>(
                key: ValueKey(_preferredCategory),
                initialSelection: _preferredCategory,
                dropdownMenuEntries: kSetupCategories
                    .map((c) => DropdownMenuEntry(value: c, label: c))
                    .toList(),
                onSelected: (value) {
                  if (value != null) setState(() => _preferredCategory = value);
                },
                width: MediaQuery.sizeOf(context).width - 48,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
