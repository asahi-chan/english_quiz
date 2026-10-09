import 'package:flutter/material.dart';
import 'package:flutter_icons_animated/flutter_animated_icons.dart';
import 'package:lottie/lottie.dart';
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
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'お疲れさまでした🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 120),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    Icons8.rocket,
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 96),
          Positioned(
            left: 0,
            right: 0,
            bottom: 144,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 112,
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
                        child: const Icon(Icons.replay, size: 60),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'もう一度',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 112,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const SettingScreen(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [const Icon(Icons.exit_to_app, size: 60)],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '出題設定に戻る',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
