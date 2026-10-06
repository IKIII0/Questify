import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(const QuestifyApp());
}

/// Root aplikasi Questify.
///
/// Widget ini memiliki [ThemeNotifier] dan menyediakannya ke seluruh widget
/// lewat `ChangeNotifierProvider`, sehingga tema dapat diganti secara global
/// dari mana pun dengan `context.read<ThemeNotifier>()`.
class QuestifyApp extends StatefulWidget {
  const QuestifyApp({super.key});

  @override
  State<QuestifyApp> createState() => _QuestifyAppState();
}

class _QuestifyAppState extends State<QuestifyApp> {
  final ThemeNotifier _themeNotifier = ThemeNotifier();

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>.value(
      value: _themeNotifier,
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            title: 'Questify',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeNotifier.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

/// Halaman contoh yang mendemokan token tema (Card, Button, tipografi).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final themeNotifier = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questify'),
        actions: [
          IconButton(
            tooltip: themeNotifier.isDarkMode
                ? 'Aktifkan light mode'
                : 'Aktifkan dark mode',
            onPressed: themeNotifier.toggleTheme,
            icon: Icon(
              themeNotifier.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSizes.screenPadding,
          children: [
            Text(
              'Uji Pengetahuanmu',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tema Material 3 dengan dukungan Light & Dark mode.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const _ThemeToggleCard(),
            const SizedBox(height: 16),
            const _QuestionCard(),
          ],
        ),
      ),
    );
  }
}

/// Kartu kontrol untuk memilih mode tema secara eksplisit.
class _ThemeToggleCard extends StatelessWidget {
  const _ThemeToggleCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final themeNotifier = context.watch<ThemeNotifier>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dark Mode',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    themeNotifier.isDarkMode ? 'Aktif' : 'Nonaktif',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: themeNotifier.isDarkMode,
              onChanged: (_) => themeNotifier.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Contoh kartu kuis yang memakai palet, radius, dan tombol dari tema.
class _QuestionCard extends StatelessWidget {
  const _QuestionCard();

  static const List<String> _options = [
    'Widget dasar untuk layout',
    'Bahasa pemrograman',
    'Package manajemen state',
    'Alat build otomatis',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pertanyaan 1 dari 10',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Apa fungsi utama dari widget Scaffold?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            for (final option in _options) ...[
              _OptionTile(label: option),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            Text(
              'Pilih satu jawaban yang paling tepat.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: appColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu pilihan jawaban bergaya Material 3 dengan border radius dari tema.
class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        side: BorderSide(color: colors.outlineVariant),
        foregroundColor: colors.onSurface,
      ),
      child: Text(label, style: theme.textTheme.bodyLarge),
    );
  }
}
