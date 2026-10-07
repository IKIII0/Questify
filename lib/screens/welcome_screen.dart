import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import 'quiz_screen.dart';

/// Halaman pembuka Questify.
///
/// Mengumpulkan nama pengguna, menyediakan toggle tema Light/Dark, lalu
/// berpindah ke [QuizScreen] sambil membawa nama tersebut.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userName = _nameController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => QuizScreen(userName: userName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questify'),
        actions: const [_ThemeToggleButton()],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Padding menyesuaikan lebar layar agar tidak terasa sempit.
            final horizontalPadding = constraints.maxWidth < 380 ? 16.0 : 24.0;
            const verticalPadding = 24.0;
            // Ruang minimum agar konten bisa terpusat vertikal, tetapi tetap
            // dapat di-scroll pada layar pendek (mis. landscape / keyboard).
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
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _HeaderBanner(),
                          const SizedBox(height: 28),
                          _NameField(
                            controller: _nameController,
                            onSubmitted: (_) => _startQuiz(),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 54,
                            child: FilledButton.icon(
                              onPressed: _startQuiz,
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Mulai Kuis'),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),
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

/// Banner hero dengan badge ikon bergaya modern.
class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner();

  // Gradien branding: cukup gelap sehingga teks putih tetap kontras di
  // kedua mode tema.
  static const List<Color> _gradient = [
    AppColors.lightPrimary,
    AppColors.lightSecondary,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        borderRadius: AppSizes.borderRadius,
        gradient: const LinearGradient(
          colors: _gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const _BadgeIcon(),
          const SizedBox(height: 20),
          Text(
            'Selamat Datang di Questify',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Uji pengetahuanmu lewat kuis pilihan ganda yang cepat dan seru.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lingkaran ikon bergaya badge dengan efek kaca.
class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.30),
            Colors.white.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.45),
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
      child: const Icon(
        Icons.psychology_rounded,
        size: 48,
        color: Colors.white,
      ),
    );
  }
}

/// Field input nama pengguna dengan validasi dan border rounded 12px.
class _NameField extends StatelessWidget {
  const _NameField({required this.controller, this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  static const double _radius = AppSizes.radiusSmall; // 12px

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textSecondary =
        theme.extension<AppColorsExtension>()?.textSecondary ??
        colors.onSurfaceVariant;

    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.words,
      onFieldSubmitted: onSubmitted,
      style: theme.textTheme.bodyLarge,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: 'Nama Pengguna',
        hintText: 'Masukkan namamu',
        prefixIcon: const Icon(Icons.person),
        prefixIconColor: textSecondary,
        // Override radius tema (16) menjadi 12 untuk field ini.
        border: _border(colors.outline),
        enabledBorder: _border(colors.outlineVariant),
        focusedBorder: _border(colors.primary, width: 2),
        errorBorder: _border(colors.error),
        focusedErrorBorder: _border(colors.error, width: 2),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return 'Nama tidak boleh kosong';
        if (text.length < 3) return 'Nama minimal 3 karakter';
        return null;
      },
    );
  }
}

/// Tombol toggle Light/Dark mode di kanan atas App Bar.
class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return IconButton(
      tooltip: themeNotifier.isDarkMode
          ? 'Aktifkan light mode'
          : 'Aktifkan dark mode',
      onPressed: themeNotifier.toggleTheme,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          themeNotifier.isDarkMode
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          key: ValueKey<bool>(themeNotifier.isDarkMode),
        ),
      ),
    );
  }
}
