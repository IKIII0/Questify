// Memverifikasi tidak ada overflow (termasuk BOTTOM OVERFLOWED BY XX PIXELS)
// pada seluruh alur aplikasi di berbagai ukuran layar dan skala teks.
//
// Catatan: di Flutter, RenderFlex overflow dilaporkan sebagai error dan akan
// otomatis menggagalkan test, sehingga test ini berfungsi sebagai penjaga
// regresi tata letak.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:questify/main.dart';
import 'package:questify/models/question_model.dart';
import 'package:questify/widgets/option_card.dart';

/// Menjalankan seluruh alur: Welcome -> Kuis (jawab benar semua) -> Hasil.
Future<void> _runFullFlow(WidgetTester tester) async {
  await tester.pumpWidget(const QuestifyApp());
  expect(find.text('Mulai Kuis'), findsOneWidget);

  await tester.enterText(find.byType(TextFormField), 'Andi');
  await tester.ensureVisible(find.text('Mulai Kuis'));
  await tester.tap(find.text('Mulai Kuis'));
  await tester.pumpAndSettle();

  for (var i = 0; i < listQuestions.length; i++) {
    final question = listQuestions[i];
    final option = find.byType(OptionCard).at(question.correctOptionIndex);

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

  expect(find.text('Selamat, Andi!'), findsOneWidget);
  expect(find.text('Ulangi Kuis'), findsOneWidget);
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  const sizes = <String, Size>{
    'HP kecil portrait 320x480': Size(320, 480),
    'HP sempit portrait 360x640': Size(360, 640),
    'HP landscape 640x320': Size(640, 320),
    'HP landscape sangat pendek 800x260': Size(800, 260),
    'HP modern tall 412x915': Size(412, 915),
    'Tablet 1024x768': Size(1024, 768),
    'Tablet landscape 1280x800': Size(1280, 800),
  };

  for (final entry in sizes.entries) {
    testWidgets('Alur bebas overflow pada ${entry.key}', (tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _runFullFlow(tester);
    });
  }

  testWidgets('Alur bebas overflow dengan teks diperbesar 1.5x', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _runFullFlow(tester);
  });

  testWidgets('WelcomeScreen bebas overflow saat keyboard muncul (inset)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(const QuestifyApp());
    await tester.pumpAndSettle();

    expect(find.text('Mulai Kuis'), findsOneWidget);
  });
}
