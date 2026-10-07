import 'package:flutter/foundation.dart';

/// Model satu pertanyaan kuis pilihan ganda.
@immutable
class Question {
  const Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  /// Identitas unik pertanyaan.
  final String id;

  /// Teks pertanyaan yang ditampilkan ke pengguna.
  final String questionText;

  /// Daftar pilihan jawaban (biasanya 4 opsi: A, B, C, D).
  final List<String> options;

  /// Indeks jawaban benar pada [options] (berbasis 0).
  final int correctOptionIndex;

  /// Penjelasan yang ditampilkan setelah pertanyaan dijawab.
  final String explanation;

  /// Teks jawaban yang benar bila [correctOptionIndex] valid.
  String? get correctOptionText {
    if (correctOptionIndex < 0 || correctOptionIndex >= options.length) {
      return null;
    }
    return options[correctOptionIndex];
  }

  /// Mengecek apakah [index] merupakan jawaban benar.
  bool isCorrectIndex(int index) => index == correctOptionIndex;
}

/// Label huruf default untuk setiap opsi (A, B, C, D, ...).
const List<String> optionLetters = ['A', 'B', 'C', 'D', 'E', 'F'];

/// Lima pertanyaan dummy lokal seputar pengetahuan umum dan pemrograman.
const List<Question> listQuestions = [
  Question(
    id: 'q1',
    questionText: 'Apa kepanjangan dari HTML?',
    options: [
      'HyperText Markup Language',
      'HighText Machine Language',
      'HyperTool Multi Language',
      'Home Tool Markup Language',
    ],
    correctOptionIndex: 0,
    explanation:
        'HTML adalah singkatan dari HyperText Markup Language, bahasa markup '
        'yang dipakai untuk menyusun struktur halaman web.',
  ),
  Question(
    id: 'q2',
    questionText:
        'Bahasa pemrograman apa yang dikembangkan oleh Google dan resmi '
        'dirilis pada tahun 2011?',
    options: ['Kotlin', 'Dart', 'Swift', 'TypeScript'],
    correctOptionIndex: 1,
    explanation:
        'Dart dikembangkan oleh Google dan dirilis tahun 2011. Bahasa ini '
        'menjadi fondasi utama framework Flutter.',
  ),
  Question(
    id: 'q3',
    questionText: 'Ibukota negara Jepang adalah...',
    options: ['Osaka', 'Kyoto', 'Tokyo', 'Nagoya'],
    correctOptionIndex: 2,
    explanation:
        'Tokyo adalah ibukota Jepang sekaligus wilayah metropolitan dengan '
        'penduduk terpadat di dunia.',
  ),
  Question(
    id: 'q4',
    questionText: 'Dalam Flutter, widget apa yang menyediakan kerangka '
        'halaman seperti AppBar, body, dan FloatingActionButton?',
    options: ['Container', 'Scaffold', 'Column', 'SizedBox'],
    correctOptionIndex: 1,
    explanation:
        'Scaffold menyediakan struktur visual dasar Material Design, termasuk '
        'AppBar, body, Drawer, dan FloatingActionButton.',
  ),
  Question(
    id: 'q5',
    questionText:
        'Struktur data yang menerapkan prinsip LIFO (Last In First Out) '
        'adalah...',
    options: ['Queue', 'Linked List', 'Stack', 'Tree'],
    correctOptionIndex: 2,
    explanation:
        'Stack menerapkan LIFO: elemen yang terakhir dimasukkan adalah yang '
        'pertama dikeluarkan. Queue menerapkan FIFO (First In First Out).',
  ),
];
