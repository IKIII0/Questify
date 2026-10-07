import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ---------------------------------------------------------------------------
/// Design tokens
/// ---------------------------------------------------------------------------

/// Warna mentah untuk palette Light & Dark Questify.
///
/// Token ini dipakai sebagai sumber kebenaran tunggal saat membangun
/// [ColorScheme]. Widget sebaiknya membaca warna dari `Theme.of(context)`
/// atau [AppColorsExtension], bukan langsung dari konstanta di sini.
class AppColors {
  const AppColors._();

  // Light palette
  static const Color lightPrimary = Color(0xFF1E3A8A);
  static const Color lightSecondary = Color(0xFF0D9488);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFE11D48);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Warna semantik untuk jawaban benar (dipakai OptionCard & hasil kuis).
  static const Color successLight = Color(0xFF16A34A);
  static const Color successDark = Color(0xFF4ADE80);

  // Dark palette
  static const Color darkPrimary = Color(0xFF60A5FA);
  static const Color darkSecondary = Color(0xFF34D399);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkError = Color(0xFFF87171);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}

/// Token bentuk dan jarak yang dipakai konsisten di seluruh aplikasi.
class AppSizes {
  const AppSizes._();

  /// Radius seragam untuk Card, Button, input, dialog, dsb.
  static const double radius = 16;

  /// Radius lebih kecil untuk elemen kompak seperti Chip.
  static const double radiusSmall = 12;

  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(radius),
  );

  static const BorderRadius borderRadiusTop = BorderRadius.vertical(
    top: Radius.circular(radius),
  );

  static const EdgeInsets screenPadding = EdgeInsets.all(20);
}

/// ---------------------------------------------------------------------------
/// Theme extension
/// ---------------------------------------------------------------------------

/// Warna teks tambahan yang tidak punya padanan langsung di [ColorScheme].
///
/// Akses lewat:
/// ```dart
/// final colors = Theme.of(context).extension<AppColorsExtension>()!;
/// Text('Halo', style: TextStyle(color: colors.textSecondary));
/// ```
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.textPrimary,
    required this.textSecondary,
  });

  final Color textPrimary;
  final Color textSecondary;

  @override
  AppColorsExtension copyWith({Color? textPrimary, Color? textSecondary}) {
    return AppColorsExtension(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other == null) return this;
    return AppColorsExtension(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

/// ---------------------------------------------------------------------------
/// Theme factory
/// ---------------------------------------------------------------------------

/// Membangun [ThemeData] Material 3 untuk Light dan Dark mode.
class AppTheme {
  const AppTheme._();

  /// Font untuk body/nilai yang menekankan keterbacaan.
  static TextStyle bodyFont({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Font untuk heading/judul agar terasa tegas dan modern.
  static TextStyle headingFont({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static ThemeData get light => _build(
    brightness: Brightness.light,
    primary: AppColors.lightPrimary,
    secondary: AppColors.lightSecondary,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    error: AppColors.lightError,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkSecondary,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    error: AppColors.darkError,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color error,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final isLight = brightness == Brightness.light;
    final colorScheme = _colorScheme(
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
    );
    final textTheme = _textTheme(
      brightness: brightness,
      textPrimary: textPrimary,
    );

    // Bayangan tipis: cukup memberi kedalaman tanpa terlihat berat.
    final shadowColor = Colors.black.withValues(alpha: isLight ? 0.06 : 0.40);
    final cardShape = RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadius,
    );
    final buttonShape = RoundedRectangleBorder(
      borderRadius: AppSizes.borderRadius,
    );
    final buttonTextStyle = textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimary,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: shadowColor,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: cardShape,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: primary.withValues(alpha: 0.4),
          disabledForegroundColor: colorScheme.onPrimary.withValues(alpha: 0.7),
          elevation: 1,
          shadowColor: shadowColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: buttonShape,
          textStyle: buttonTextStyle,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: buttonShape,
          textStyle: buttonTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: colorScheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: buttonShape,
          textStyle: buttonTextStyle,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: buttonShape,
          textStyle: buttonTextStyle,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        highlightElevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadius,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
        labelStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: AppSizes.borderRadius,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadius,
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadius,
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadius,
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSizes.borderRadius,
          borderSide: BorderSide(color: error, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: primary.withValues(alpha: 0.15),
        side: BorderSide(color: colorScheme.outlineVariant),
        labelStyle: textTheme.labelLarge?.copyWith(color: textPrimary),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: primary),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusSmall)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: shadowColor,
        shape: cardShape,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadiusTop,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.15),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium?.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? primary : textSecondary);
        }),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: textSecondary,
        textColor: textPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadius,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return colorScheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStatePropertyAll(colorScheme.outlineVariant),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSizes.borderRadius,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppColorsExtension(
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ],
    );
  }

  static ColorScheme _colorScheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color surface,
    required Color error,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final isLight = brightness == Brightness.light;

    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: isLight ? Colors.white : const Color(0xFF0B1220),
      secondary: secondary,
      onSecondary: isLight ? Colors.white : const Color(0xFF06251C),
      error: error,
      onError: isLight ? Colors.white : const Color(0xFF3B0A0A),
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      surfaceContainerLowest: isLight
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF0B1220),
      surfaceContainerLow: isLight
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF1E293B),
      surfaceContainer: isLight
          ? const Color(0xFFF1F5F9)
          : const Color(0xFF253449),
      surfaceContainerHigh: isLight
          ? const Color(0xFFE9EEF5)
          : const Color(0xFF2D3E56),
      surfaceContainerHighest: isLight
          ? const Color(0xFFE2E8F0)
          : const Color(0xFF334155),
      outline: isLight ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
      outlineVariant: isLight
          ? const Color(0xFFE2E8F0)
          : const Color(0xFF334155),
      inverseSurface: isLight
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      onInverseSurface: isLight
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF0F172A),
      inversePrimary: isLight
          ? const Color(0xFF60A5FA)
          : const Color(0xFF1E3A8A),
    );
  }

  static TextTheme _textTheme({
    required Brightness brightness,
    required Color textPrimary,
  }) {
    final base = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;

    // Body & label memakai Plus Jakarta Sans untuk keterbacaan.
    final body = GoogleFonts.plusJakartaSansTextTheme(
      base,
    ).apply(bodyColor: textPrimary, displayColor: textPrimary);

    // Heading & title memakai Space Grotesk agar terasa tegas dan modern.
    final headings = GoogleFonts.spaceGroteskTextTheme(
      base,
    ).apply(bodyColor: textPrimary, displayColor: textPrimary);

    return body.copyWith(
      displayLarge: headings.displayLarge,
      displayMedium: headings.displayMedium,
      displaySmall: headings.displaySmall,
      headlineLarge: headings.headlineLarge,
      headlineMedium: headings.headlineMedium,
      headlineSmall: headings.headlineSmall,
      titleLarge: headings.titleLarge,
    );
  }
}

/// ---------------------------------------------------------------------------
/// State management
/// ---------------------------------------------------------------------------

/// Notifier sederhana untuk mengatur [ThemeMode] secara global.
///
/// Disediakan lewat `ChangeNotifierProvider` di root aplikasi sehingga
/// perubahan tema otomatis membangun ulang seluruh widget yang mendengarkan.
class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier({ThemeMode initialMode = ThemeMode.system})
    : _themeMode = initialMode;

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Mengubah mode tema secara eksplisit (light, dark, atau system).
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  /// Membalik mode terang/gelap. Mode [ThemeMode.system] dianggap terang.
  void toggleTheme() {
    setThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}
