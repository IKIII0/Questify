import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Gaya tampilan [AppLogo].
enum AppLogoStyle {
  /// Lingkaran gradien branding (navy -> teal) dengan ikon putih.
  /// Cocok dipakai di splash screen dan sebagai ikon aplikasi.
  gradient,

  /// Lingkaran kaca transparan; dipakai di atas banner berwarna.
  glass,
}

/// Logo resmi Questify: lingkaran berisi ikon otak (psychology).
///
/// Dipakai ulang di splash screen maupun banner pada WelcomeScreen agar
/// identitas visual konsisten di seluruh aplikasi.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 96,
    this.style = AppLogoStyle.gradient,
  });

  /// Diameter lingkaran logo.
  final double size;

  /// Gaya tampilan logo.
  final AppLogoStyle style;

  @override
  Widget build(BuildContext context) {
    final isGradient = style == AppLogoStyle.gradient;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isGradient
              ? const [AppColors.lightPrimary, AppColors.lightSecondary]
              : [
                  Colors.white.withValues(alpha: 0.30),
                  Colors.white.withValues(alpha: 0.10),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isGradient
              ? Colors.white.withValues(alpha: 0.20)
              : Colors.white.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.psychology_rounded,
        size: size * 0.5,
        color: Colors.white,
      ),
    );
  }
}
