import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'quiz_screen.dart';

/// Halaman hasil skor kuis.
///
/// Menampilkan sapaan pengguna, kartu skor akhir beserta rincian jawaban
/// benar/salah, pesan evaluasi otomatis, dan dua aksi: mengulang kuis atau
/// kembali ke beranda.
class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.userName,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
  });

  /// Nama pengguna yang dioper dari halaman kuis.
  final String userName;

  /// Skor akhir (0-100).
  final int score;

  /// Jumlah jawaban benar.
  final int correctCount;

  /// Jumlah total soal.
  final int totalQuestions;

  /// Jumlah jawaban salah.
  int get _wrongCount =>
      (totalQuestions - correctCount).clamp(0, totalQuestions);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textSecondary =
        theme.extension<AppColorsExtension>()?.textSecondary ??
        colors.onSurfaceVariant;
    final accent = _accentFor(theme);
    final evaluation = _evaluationFor(theme);

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
                        // Sapaan pengguna.
                        Text(
                          'Selamat, $userName!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Berikut hasil kuis kamu.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Kartu skor akhir + rincian benar/salah.
                        _ScoreCard(
                          score: score,
                          correctCount: correctCount,
                          wrongCount: _wrongCount,
                          accent: accent,
                        ),
                        const SizedBox(height: 20),

                        // Pesan evaluasi otomatis.
                        _EvaluationBanner(evaluation: evaluation),
                        const SizedBox(height: 32),

                        // Aksi.
                        FilledButton.icon(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      QuizScreen(userName: userName),
                                ),
                              ),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Ulangi Kuis'),
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

  /// Warna aksen kartu skor; hijau bila lulus, primary bila belum.
  Color _accentFor(ThemeData theme) {
    if (score >= 60) {
      return theme.brightness == Brightness.dark
          ? AppColors.successDark
          : AppColors.successLight;
    }
    return theme.colorScheme.primary;
  }

  /// Evaluasi otomatis berdasarkan skor.
  _EvaluationResult _evaluationFor(ThemeData theme) {
    final success = theme.brightness == Brightness.dark
        ? AppColors.successDark
        : AppColors.successLight;
    final colors = theme.colorScheme;

    if (score >= 80) {
      return _EvaluationResult(
        message: 'Luar Biasa!',
        detail: 'Kamu menguasai materi ini dengan sangat baik.',
        icon: Icons.emoji_events_rounded,
        color: success,
      );
    }
    if (score >= 60) {
      return _EvaluationResult(
        message: 'Kerja Bagus!',
        detail: 'Sedikit lagi menuju hasil yang sempurna.',
        icon: Icons.thumb_up_rounded,
        color: colors.secondary,
      );
    }
    if (score >= 50) {
      return _EvaluationResult(
        message: 'Cukup Baik',
        detail: 'Terus berlatih agar makin mahir.',
        icon: Icons.sentiment_satisfied_rounded,
        color: colors.secondary,
      );
    }
    return _EvaluationResult(
      message: 'Coba Lagi!',
      detail: 'Jangan menyerah, ulangi kuis untuk hasil yang lebih baik.',
      icon: Icons.sentiment_dissatisfied_rounded,
      color: colors.error,
    );
  }
}

/// Kartu skor akhir: angka skor, progress bar, dan rincian benar/salah.
class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.score,
    required this.correctCount,
    required this.wrongCount,
    required this.accent,
  });

  final int score;
  final int correctCount;
  final int wrongCount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textSecondary =
        theme.extension<AppColorsExtension>()?.textSecondary ??
        colors.onSurfaceVariant;
    final success = theme.brightness == Brightness.dark
        ? AppColors.successDark
        : AppColors.successLight;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Skor Akhir',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            // FittedBox menjaga angka skor tetap muat di layar sempit
            // tanpa overflow horizontal.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$score',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '/ 100',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (score / 100).clamp(0.0, 1.0),
              minHeight: 10,
              borderRadius: AppSizes.borderRadius,
              backgroundColor: colors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
            const SizedBox(height: 20),
            Divider(color: colors.outlineVariant, height: 1),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _BreakdownTile(
                      icon: Icons.check_circle_rounded,
                      label: 'Benar',
                      value: correctCount,
                      color: success,
                    ),
                  ),
                  Container(width: 1, color: colors.outlineVariant),
                  Expanded(
                    child: _BreakdownTile(
                      icon: Icons.cancel_rounded,
                      label: 'Salah',
                      value: wrongCount,
                      color: colors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu kolom rincian (ikon + jumlah + label).
class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary =
        theme.extension<AppColorsExtension>()?.textSecondary ??
        theme.colorScheme.onSurfaceVariant;

    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(color: textSecondary),
        ),
      ],
    );
  }
}

/// Banner pesan evaluasi otomatis.
class _EvaluationBanner extends StatelessWidget {
  const _EvaluationBanner({required this.evaluation});

  final _EvaluationResult evaluation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = evaluation.color;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: AppSizes.borderRadius,
        border: Border.all(color: accent.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(evaluation.icon, color: accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evaluation.message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  evaluation.detail,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Hasil evaluasi: pesan, detail, ikon, dan warna.
@immutable
class _EvaluationResult {
  const _EvaluationResult({
    required this.message,
    required this.detail,
    required this.icon,
    required this.color,
  });

  final String message;
  final String detail;
  final IconData icon;
  final Color color;
}
