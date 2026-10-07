import 'package:flutter/material.dart';

import '../models/question_model.dart';
import '../theme/app_theme.dart';
import '../widgets/option_card.dart';
import '../widgets/quiz_progress_bar.dart';
import 'result_screen.dart';

/// State logika kuis yang terpisah dari widget.
///
/// Karena instance-nya disimpan di dalam `State` dari [QuizScreen] (bukan
/// dibuat ulang di `build`), seluruh progres (indeks soal, jawaban terpilih,
/// dan skor) tetap bertahan ketika layar diputar (rotasi / resize). `State`
/// tidak dibuang saat konfigurasi berubah, hanya di-rebuild.
class QuizController extends ChangeNotifier {
  QuizController({List<Question>? questions})
    : questions = questions ?? listQuestions;

  final List<Question> questions;

  int _currentIndex = 0;
  final Map<String, int> _selectedAnswers = {};
  final Set<String> _submittedQuestionIds = {};

  int get currentIndex => _currentIndex;
  Question get currentQuestion => questions[_currentIndex];
  int get totalQuestions => questions.length;
  bool get isLastQuestion => _currentIndex == totalQuestions - 1;

  /// Indeks opsi yang dipilih pada soal aktif (null bila belum memilih).
  int? get selectedIndex => _selectedAnswers[currentQuestion.id];

  /// Apakah soal aktif sudah dikonfirmasi/ditinjau.
  bool get isSubmitted => _submittedQuestionIds.contains(currentQuestion.id);

  bool get hasSelection => selectedIndex != null;

  /// Jumlah jawaban benar.
  int get correctCount => questions
      .where(
        (question) =>
            _selectedAnswers[question.id] == question.correctOptionIndex,
      )
      .length;

  /// Skor akhir dalam persentase (0-100).
  int get score =>
      totalQuestions == 0 ? 0 : ((correctCount / totalQuestions) * 100).round();

  /// Label tombol aksi utama sesuai tahapan kuis.
  String get actionLabel {
    if (!isSubmitted) return 'Konfirmasi Jawaban';
    return isLastQuestion ? 'Lihat Hasil' : 'Selanjutnya';
  }

  /// Tombol aktif bila opsi sudah dipilih atau jawaban sudah dikonfirmasi.
  bool get canAct => isSubmitted || hasSelection;

  /// Memilih opsi [index]; diabaikan bila soal sudah dikonfirmasi.
  void selectOption(int index) {
    if (isSubmitted || selectedIndex == index) return;
    _selectedAnswers[currentQuestion.id] = index;
    notifyListeners();
  }

  /// Mengunci dan mengevaluasi jawaban soal aktif.
  void submitAnswer() {
    if (isSubmitted || !hasSelection) return;
    _submittedQuestionIds.add(currentQuestion.id);
    notifyListeners();
  }

  /// Berpindah ke soal berikutnya (tidak berefek di soal terakhir).
  void nextQuestion() {
    if (isLastQuestion) return;
    _currentIndex++;
    notifyListeners();
  }
}

/// Halaman kuis pilihan ganda Questify.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.userName});

  /// Nama pengguna yang dikirim dari halaman sebelumnya.
  final String userName;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Dibuat sekali di initState sehingga tidak hilang saat rotasi layar.
  late final QuizController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuizController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePrimaryAction() {
    if (!_controller.isSubmitted) {
      _controller.submitAnswer();
    } else if (_controller.isLastQuestion) {
      _goToResult();
    } else {
      _controller.nextQuestion();
    }
  }

  void _goToResult() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          userName: widget.userName,
          score: _controller.score,
          correctCount: _controller.correctCount,
          totalQuestions: _controller.totalQuestions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kuis')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Padding mengikuti lebar layar; konten dibatasi lebarnya agar
                // nyaman dibaca di tablet.
                final horizontalPadding = constraints.maxWidth < 380
                    ? 16.0
                    : 24.0;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        16,
                        horizontalPadding,
                        16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuizProgressBar(
                            currentQuestion: _controller.currentIndex + 1,
                            totalQuestions: _controller.totalQuestions,
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _QuestionHeader(
                                    userName: widget.userName,
                                    question: _controller.currentQuestion,
                                  ),
                                  const SizedBox(height: 20),
                                  ..._buildOptions(),
                                  if (_controller.isSubmitted) ...[
                                    const SizedBox(height: 20),
                                    _ExplanationCard(
                                      question: _controller.currentQuestion,
                                      isCorrect: _isCurrentAnswerCorrect,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _controller.canAct
                                ? _handlePrimaryAction
                                : null,
                            child: Text(_controller.actionLabel),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  bool get _isCurrentAnswerCorrect {
    final question = _controller.currentQuestion;
    return _controller.selectedIndex == question.correctOptionIndex;
  }

  List<Widget> _buildOptions() {
    final question = _controller.currentQuestion;
    final widgets = <Widget>[];

    for (var i = 0; i < question.options.length; i++) {
      widgets.add(
        OptionCard(
          optionLetter: _letterFor(i),
          optionText: question.options[i],
          isSelected: _controller.selectedIndex == i,
          isCorrect: question.isCorrectIndex(i),
          isSubmitted: _controller.isSubmitted,
          onTap: () => _controller.selectOption(i),
        ),
      );
      if (i != question.options.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }
    return widgets;
  }

  String _letterFor(int index) {
    if (index < optionLetters.length) return optionLetters[index];
    return String.fromCharCode('A'.codeUnitAt(0) + index);
  }
}

/// Header soal: sapaan pengguna + teks pertanyaan.
class _QuestionHeader extends StatelessWidget {
  const _QuestionHeader({required this.userName, required this.question});

  final String userName;
  final Question question;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Semangat, $userName!',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          question.questionText,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

/// Kartu penjelasan yang muncul setelah jawaban dikonfirmasi.
class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({required this.question, required this.isCorrect});

  final Question question;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final success = theme.brightness == Brightness.dark
        ? AppColors.successDark
        : AppColors.successLight;
    final accent = isCorrect ? success : colors.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: AppSizes.borderRadius,
        border: Border.all(color: accent.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: accent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Jawaban Benar!' : 'Jawaban Kurang Tepat',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  question.explanation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
