// Smoke test dasar untuk Questify: memastikan aplikasi dapat dibangun dan
// mode tema dapat diganti secara global lewat ThemeNotifier.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:questify/main.dart';

void main() {
  setUpAll(() {
    // Cegah google_fonts mencoba mengunduh font saat pengujian.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('QuestifyApp tampil dan tema dapat diganti', (tester) async {
    await tester.pumpWidget(const QuestifyApp());

    expect(find.text('Uji Pengetahuanmu'), findsOneWidget);

    final initialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(initialApp.themeMode, ThemeMode.system);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pump();

    final updatedApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(updatedApp.themeMode, ThemeMode.dark);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
  });
}
