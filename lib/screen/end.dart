import 'package:flutter/material.dart';

import 'quiz.dart';
import 'setting.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({
    super.key,
    required this.questionType,
    required this.orderType,
    required this.questionCount,
    this.selectedLevels = const [],
    this.startQuestionNumber,
  });

  final String questionType;
  final String orderType;
  final int questionCount;
  final List<String> selectedLevels;
  final int? startQuestionNumber;

  @override
  Widget build(BuildContext context) {
    final resolvedQuestionType = questionType;
    final resolvedOrderType = orderType;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('お疲れさまでした🎉'),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 88,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            questionType: resolvedQuestionType,
                            orderType: resolvedOrderType,
                            questionCount: questionCount,
                            selectedLevels: selectedLevels,
                            startQuestionNumber: startQuestionNumber,
                          ),
                        ),
                      );
                    },
                    child: const Text('もう一度', textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox.square(
                  dimension: 88,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SettingScreen(),
                        ),
                      );
                    },
                    child: const Text('出題設定に戻る', textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
