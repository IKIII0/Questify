import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
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
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
