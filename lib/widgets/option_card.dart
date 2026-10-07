import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Kartu opsi jawaban yang dapat dipakai ulang pada kuis pilihan ganda.
///
/// Indikator visual:
/// - Netral: belum dipilih dan belum disubmit.
/// - Primary: sedang dipilih (belum disubmit).
/// - Hijau: jawaban benar, ditampilkan setelah [isSubmitted].
/// - Merah: opsi yang dipilih tetapi salah, setelah [isSubmitted].
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.optionText,
    required this.optionLetter,
    required this.isSelected,
    required this.isCorrect,
    required this.isSubmitted,
    required this.onTap,
  });

  /// Teks jawaban yang ditampilkan.
  final String optionText;

  /// Huruf penanda opsi, misalnya 'A', 'B', 'C', atau 'D'.
  final String optionLetter;

  /// Apakah opsi ini sedang dipilih pengguna.
  final bool isSelected;

  /// Apakah opsi ini merupakan jawaban benar.
  final bool isCorrect;

  /// Apakah jawaban sudah disubmit/ditinjau.
  final bool isSubmitted;

  /// Aksi saat kartu ditekan.
  final VoidCallback onTap;

  // Warna semantik "benar"; sedikit lebih terang di dark mode.
  static const Color _successLight = Color(0xFF16A34A);
  static const Color _successDark = Color(0xFF4ADE80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>();
    final textSecondary = appColors?.textSecondary ?? colors.onSurfaceVariant;
    final isDark = theme.brightness == Brightness.dark;

    final success = isDark ? _successDark : _successLight;

    final showCorrect = isSubmitted && isCorrect;
    final showWrong = isSubmitted && isSelected && !isCorrect;
    final isReviewed = isSubmitted && !isCorrect && !isSelected;
    final showSelected = !isSubmitted && isSelected;

    // Aksen utama kartu: menentukan border, latar, dan badge huruf.
    Color? accent;
    if (showCorrect) {
      accent = success;
    } else if (showWrong) {
      accent = colors.error;
    } else if (showSelected) {
      accent = colors.primary;
    }

    final isActive = accent != null;

    final Color borderColor = accent ?? colors.outlineVariant;
    final Color backgroundColor = accent != null
        ? accent.withValues(alpha: 0.12)
        : (isReviewed ? colors.surfaceContainerLow : colors.surface);
    final Color contentColor = isReviewed ? textSecondary : colors.onSurface;

    final Color badgeBackground = accent ?? colors.surfaceContainerHighest;
    final Color badgeForeground = accent != null
        ? (ThemeData.estimateBrightnessForColor(accent) == Brightness.dark
              ? Colors.white
              : Colors.black87)
        : textSecondary;

    final IconData trailingIcon = switch (this) {
      _ when showCorrect => Icons.check_circle_rounded,
      _ when showWrong => Icons.cancel_rounded,
      _ when isSelected => Icons.radio_button_checked_rounded,
      _ => Icons.radio_button_unchecked_rounded,
    };
    final Color trailingColor = accent ?? colors.outline;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppSizes.borderRadius,
        border: Border.all(color: borderColor, width: isActive ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSizes.borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _LetterBadge(
                  letter: optionLetter,
                  background: badgeBackground,
                  foreground: badgeForeground,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    optionText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: contentColor,
                      fontWeight: showSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(trailingIcon, color: trailingColor, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Badge lingkaran berisi huruf opsi (A, B, C, D).
class _LetterBadge extends StatelessWidget {
  const _LetterBadge({
    required this.letter,
    required this.background,
    required this.foreground,
  });

  final String letter;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        letter,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
