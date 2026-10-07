import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'welcome_screen.dart';

/// Layar pembuka (splash) yang menampilkan logo Questify, lalu berpindah
/// otomatis ke [WelcomeScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  /// Lama logo ditampilkan sebelum berpindah ke halaman berikutnya.
  static const Duration displayDuration = Duration(milliseconds: 1600);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _scheduleNavigation();
  }

  Future<void> _scheduleNavigation() async {
    await Future<void>.delayed(SplashScreen.displayDuration);
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) => const WelcomeScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary =
        theme.extension<AppColorsExtension>()?.textSecondary ??
        theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Pola min-height + scroll agar tetap terpusat dan bebas overflow
            // di layar pendek (mis. landscape).
            final minHeight = (constraints.maxHeight - 48).clamp(
              0.0,
              double.infinity,
            );
            // Ukuran logo menyesuaikan lebar layar (dinamis, bukan hardcode)
            // agar proporsional di HP kecil maupun tablet.
            final logoSize = (constraints.maxWidth * 0.32).clamp(104.0, 168.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 0.85 + 0.15 * value,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppLogo(size: logoSize),
                        const SizedBox(height: 24),
                        Text(
                          'Questify',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Kuis pilihan ganda interaktif',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 3),
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
