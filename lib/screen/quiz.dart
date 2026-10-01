import 'package:flutter/material.dart';
import 'end.dart';
import 'setting.dart';
import '../service/make_quiz.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.questionType,
    required this.orderType,
  });

  final String questionType;
  final String orderType;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final Future<void> _loadQuizFuture;
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
        quizList.isNotEmpty &&
        _currentIndex == quizList.length - 1) {
      return '終了';
    }

    return _showAnswer ? '次へ' : '答えを見る';
  }

  @override
  void initState() {
    super.initState();
    _loadQuizFuture = loadQuiz(widget.orderType);
  }

  void _handleButtonPressed() {
    if (!_showAnswer) {
      setState(() {
        _showAnswer = true;
      });
      return;
    }

    if (quizList.isEmpty) {
      return;
    }

    if (_currentIndex == quizList.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EndScreen(
            questionType: widget.questionType,
            orderType: widget.orderType,
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
      body: FutureBuilder<void>(
        future: _loadQuizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final word = quizList.isNotEmpty ? quizList[_currentIndex] : null;
          final progressText =
              '${quizList.isNotEmpty ? _currentIndex + 1 : 0}/${quizList.length}';
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
