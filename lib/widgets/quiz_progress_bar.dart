import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Progress bar linear dinamis yang menunjukkan posisi soal aktif.
///
/// Contoh tampilan: "Soal 3 dari 5" dengan bar terisi 60%.
class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.label,
    this.showPercentage = true,
  });

  /// Nomor soal aktif (berbasis 1, sesuai tampilan "Soal 1 dari 5").
  final int currentQuestion;

  /// Jumlah total soal.
  final int totalQuestions;

  /// Label kustom pada sisi kiri. Default: 'Soal X dari Y'.
  final String? label;

  /// Menampilkan persentase di sisi kanan.
  final bool showPercentage;

  /// Nilai progres 0.0 - 1.0 yang selalu aman dipakai.
  double get _progress {
    if (totalQuestions <= 0) return 0;
    return (currentQuestion / totalQuestions).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>();
    final textSecondary = appColors?.textSecondary ?? colors.onSurfaceVariant;

    final progress = _progress;
    final progressLabel = label ?? 'Soal $currentQuestion dari $totalQuestions';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                progressLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (showPercentage)
              Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          borderRadius: AppSizes.borderRadius,
          backgroundColor: colors.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
        ),
      ],
    );
  }
}
