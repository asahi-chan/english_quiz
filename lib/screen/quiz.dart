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

  String get _progressText =>
      '${_quizList.isNotEmpty ? _currentIndex + 1 : 0}/${_quizList.length}';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_progressText),
        backgroundColor: const Color.fromARGB(255, 142, 219, 255),
        actions: [
          IconButton(
            onPressed: _showBackToSettingsDialog,
            icon: const Icon(Icons.home),
          ),
        ],
      ),
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
          final questionText = widget.questionType == 'japaneseToEnglish'
              ? word?.japanese ?? ''
              : word?.english ?? '';
          final answerText = widget.questionType == 'japaneseToEnglish'
              ? word?.english ?? ''
              : word?.japanese ?? '';
          final partOfSpeechText = word?.partOfSpeech ?? '';
          return Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '問題番号：${word?.id ?? ''}',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        questionText,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 48),
                      ),
                      if (_showAnswer && word != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          answerText,
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 36),
                        ),
                        if (partOfSpeechText.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            '品詞：$partOfSpeechText',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontSize: 24),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 144,
                child: Center(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 86, 156),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: _handleButtonPressed,
                      child: Text(_buttonLabel, textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
