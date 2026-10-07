import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Halaman kuis.
///
/// Catatan: ini masih placeholder minimal yang menerima [userName] dari
/// [WelcomeScreen]. Logika kuis (pertanyaan, opsi, skor) akan ditambahkan pada
/// tahap berikutnya.
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.userName});

  /// Nama pengguna yang dikirim dari halaman Welcome.
  final String userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary =
        theme.extension<AppColorsExtension>()?.textSecondary ??
        theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: const Text('Kuis')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSizes.screenPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Halo, $userName!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Halaman kuis sedang disiapkan.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
