import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'quiz_screen.dart';

/// Halaman hasil kuis.
///
/// Menampilkan skor akhir, jumlah jawaban benar, dan total soal, serta
/// menyediakan aksi untuk mengulang kuis atau kembali ke beranda.
class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.userName,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
  });

  /// Nama pengguna yang dikirim dari halaman kuis.
  final String userName;

  /// Total skor dalam persentase (0-100).
  final int score;

  /// Jumlah jawaban benar.
  final int correctCount;

  /// Total jumlah soal.
  final int totalQuestions;

  String get _message {
    if (score >= 80) return 'Luar biasa!';
    if (score >= 60) return 'Kerja bagus!';
    if (score >= 40) return 'Cukup baik.';
    return 'Terus berlatih!';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary =
        theme.extension<AppColorsExtension>()?.textSecondary ??
        theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 16.0 : 24.0;
            const verticalPadding = 24.0;
            final minHeight = (constraints.maxHeight - verticalPadding * 2)
                .clamp(0.0, double.infinity);

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ScoreBadge(score: score),
                        const SizedBox(height: 20),
                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hasil kuis untuk $userName',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'Skor',
                                value: '$score',
                                highlight: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Benar',
                                value: '$correctCount',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Total Soal',
                                value: '$totalQuestions',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        FilledButton.icon(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      QuizScreen(userName: userName),
                                ),
                              ),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Main Lagi'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst),
                          icon: const Icon(Icons.home_rounded),
                          label: const Text('Kembali ke Beranda'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Lingkaran besar berisi skor persentase.
class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = score >= 60
        ? (isDark ? AppColors.successDark : AppColors.successLight)
        : theme.colorScheme.primary;

    return Center(
      child: Container(
        width: 160,
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withValues(alpha: 0.12),
          border: Border.all(color: accent, width: 6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$score%',
              style: theme.textTheme.displaySmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'SKOR',
              style: theme.textTheme.labelMedium?.copyWith(
                color: accent,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu statistik kecil (nilai + label).
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textSecondary =
        theme.extension<AppColorsExtension>()?.textSecondary ??
        colors.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: highlight
            ? colors.primary.withValues(alpha: 0.10)
            : colors.surface,
        borderRadius: AppSizes.borderRadius,
        border: Border.all(
          color: highlight ? colors.primary : colors.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: highlight ? colors.primary : colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(color: textSecondary),
          ),
        ],
      ),
    );
  }
}
