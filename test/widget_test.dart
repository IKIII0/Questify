// Smoke test untuk Questify: membangun aplikasi, menguji toggle tema global,
// validasi nama pada WelcomeScreen, dan alur kuis sampai ResultScreen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:Questify/main.dart';
import 'package:Questify/models/question_model.dart';
import 'package:Questify/widgets/option_card.dart';

void main() {
  setUpAll(() {
    // Cegah google_fonts mencoba mengunduh font saat pengujian.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('WelcomeScreen tampil dan tema dapat diganti', (tester) async {
    await tester.pumpWidget(const QuestifyApp());

    expect(find.text('Selamat Datang di Questify'), findsOneWidget);
    expect(find.text('Mulai Kuis'), findsOneWidget);

    final initialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(initialApp.themeMode, ThemeMode.system);
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode_rounded));
    await tester.pump();

    final updatedApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(updatedApp.themeMode, ThemeMode.dark);
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
  });

  testWidgets('Validasi nama dan navigasi ke QuizScreen', (tester) async {
    await tester.pumpWidget(const QuestifyApp());

    await tester.ensureVisible(find.text('Mulai Kuis'));
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pump();
    expect(find.text('Nama tidak boleh kosong'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'ab');
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pump();
    expect(find.text('Nama minimal 3 karakter'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Andi');
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pumpAndSettle();
    expect(find.text('Semangat, Andi!'), findsOneWidget);
    expect(find.text('Konfirmasi Jawaban'), findsOneWidget);
  });

  testWidgets('Alur kuis lengkap sampai ResultScreen', (tester) async {
    await tester.pumpWidget(const QuestifyApp());

    await tester.enterText(find.byType(TextFormField), 'Andi');
    await tester.ensureVisible(find.text('Mulai Kuis'));
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pumpAndSettle();

    // Tombol belum aktif sebelum memilih opsi.
    final confirmButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Konfirmasi Jawaban'),
    );
    expect(confirmButton.onPressed, isNull);

    for (var i = 0; i < listQuestions.length; i++) {
      final question = listQuestions[i];
      final option = find.byType(OptionCard).at(question.correctOptionIndex);

      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pump();

      await tester.tap(find.text('Konfirmasi Jawaban'));
      await tester.pump();
      expect(find.text('Jawaban Benar!'), findsOneWidget);

      if (i == listQuestions.length - 1) {
        await tester.tap(find.text('Lihat Hasil'));
        await tester.pumpAndSettle();
      } else {
        await tester.tap(find.text('Selanjutnya'));
        await tester.pump();
      }
    }

    // Semua jawaban benar -> skor 100% di ResultScreen.
    expect(find.text('Selamat, Andi!'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('Luar Biasa!'), findsOneWidget);
    expect(find.text('Ulangi Kuis'), findsOneWidget);
    expect(find.text('Kembali ke Beranda'), findsOneWidget);
  });

  testWidgets('Skor rendah menampilkan evaluasi Coba Lagi', (tester) async {
    await tester.pumpWidget(const QuestifyApp());

    await tester.enterText(find.byType(TextFormField), 'Budi');
    await tester.ensureVisible(find.text('Mulai Kuis'));
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pumpAndSettle();

    // Jawab semua soal dengan opsi yang salah.
    for (var i = 0; i < listQuestions.length; i++) {
      final question = listQuestions[i];
      final wrongIndex =
          (question.correctOptionIndex + 1) % question.options.length;
      final option = find.byType(OptionCard).at(wrongIndex);

      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pump();

      await tester.tap(find.text('Konfirmasi Jawaban'));
      await tester.pump();

      if (i == listQuestions.length - 1) {
        await tester.tap(find.text('Lihat Hasil'));
        await tester.pumpAndSettle();
      } else {
        await tester.tap(find.text('Selanjutnya'));
        await tester.pump();
      }
    }

    expect(find.text('Selamat, Budi!'), findsOneWidget);
    expect(find.text('Coba Lagi!'), findsOneWidget);
    expect(find.text('5'), findsOneWidget); // 5 jawaban salah
  });
}
