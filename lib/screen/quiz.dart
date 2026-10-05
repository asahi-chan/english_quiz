import 'package:flutter/material.dart';
import '../model/word.dart';
import 'end.dart';
import 'setting.dart';
import '../service/make_quiz.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.questionType,
    required this.orderType,
    required this.selectedLevels,
    required this.questionCount,
    this.startQuestionNumber,
  });

  final String questionType;
  final String orderType;
  final List<String> selectedLevels;
  final int questionCount;
  final int? startQuestionNumber;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final Future<List<Word>> _loadQuizFuture;
  List<Word> _quizList = [];
  int _currentIndex = 0;
  bool _showAnswer = false;

  Future<void> _showBackToSettingsDialog() async {
    final shouldGoBack = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('出題設定に戻りますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );

    if (shouldGoBack == true && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SettingScreen()),
      );
    }
  }

  String get _buttonLabel {
    if (_showAnswer &&
        _quizList.isNotEmpty &&
        _currentIndex == _quizList.length - 1) {
      return '終了';
    }

    return _showAnswer ? '次へ' : '答えを見る';
  }

  @override
  void initState() {
    super.initState();
    _loadQuizFuture = loadQuiz(
      widget.orderType,
      widget.selectedLevels,
      widget.questionCount,
      widget.startQuestionNumber,
    );
  }

  void _handleButtonPressed() {
    if (!_showAnswer) {
      setState(() {
        _showAnswer = true;
      });
      return;
    }

    if (_quizList.isEmpty) {
      return;
    }

    if (_currentIndex == _quizList.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EndScreen(
            questionType: widget.questionType,
            orderType: widget.orderType,
            questionCount: widget.questionCount,
            selectedLevels: widget.selectedLevels,
            startQuestionNumber: widget.startQuestionNumber,
          ),
        ),
      );
      return;
    }

    setState(() {
      _currentIndex++;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Word>>(
        future: _loadQuizFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'クイズの読み込みに失敗しました。\n\nエラー内容: ${snapshot.error}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          _quizList = snapshot.data ?? [];

          final word = _quizList.isNotEmpty ? _quizList[_currentIndex] : null;
          final progressText =
              '${_quizList.isNotEmpty ? _currentIndex + 1 : 0}/${_quizList.length}';
          final questionText = widget.questionType == 'japaneseToEnglish'
              ? word?.japanese ?? ''
              : word?.english ?? '';
          final answerText = widget.questionType == 'japaneseToEnglish'
              ? word?.english ?? ''
              : word?.japanese ?? '';
          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(progressText),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: _showBackToSettingsDialog,
                      icon: const Icon(Icons.home),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '問題番号：${word?.id ?? ''}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      questionText,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    if (_showAnswer && word != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        answerText,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleButtonPressed,
            child: Text(_buttonLabel),
          ),
        ),
      ),
    );
  }
}
