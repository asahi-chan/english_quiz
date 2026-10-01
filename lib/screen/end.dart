import 'package:flutter/material.dart';

import 'quiz.dart';
import 'setting.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({
    super.key,
    required this.questionType,
    required this.orderType,
  });

  final String? questionType;
  final String? orderType;

  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context)?.settings.arguments;
    final resolvedQuestionType =
        questionType ??
        (routeArguments is Map<String, dynamic>
            ? routeArguments['questionType']
            : routeArguments);
    final resolvedOrderType =
        orderType ??
        (routeArguments is Map<String, dynamic>
            ? routeArguments['orderType']
            : null);

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
