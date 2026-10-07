// Smoke test untuk Questify: membangun aplikasi, menguji toggle tema global,
// dan memverifikasi validasi nama pada WelcomeScreen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:questify/main.dart';

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

    // Kosong -> error.
    await tester.ensureVisible(find.text('Mulai Kuis'));
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pump();
    expect(find.text('Nama tidak boleh kosong'), findsOneWidget);

    // Terlalu pendek -> error.
    await tester.enterText(find.byType(TextFormField), 'ab');
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pump();
    expect(find.text('Nama minimal 3 karakter'), findsOneWidget);

    // Valid -> berpindah ke QuizScreen dengan nama yang dibawa.
    await tester.enterText(find.byType(TextFormField), 'Andi');
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Andi!'), findsOneWidget);
  });
}
