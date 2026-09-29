import 'package:flutter/material.dart';

import 'quiz.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _questionType = 'englishToJapanese';
  String _orderType = 'numberOrder';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('出題設定'),
              const SizedBox(height: 24),
              //出題範囲
              Container(
                height: 72,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              //出題数
              Container(
                height: 72,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              //出題形式
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('出題形式'),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('英→日'),
                            value: 'englishToJapanese',
                            groupValue: _questionType,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _questionType = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('日→英'),
                            value: 'japaneseToEnglish',
                            groupValue: _questionType,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _questionType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //順番
              Container(
                height: 72,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('順番'),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('番号順'),
                            value: 'numberOrder',
                            groupValue: _orderType,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _orderType = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('ランダム'),
                            value: 'random',
                            groupValue: _orderType,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _orderType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    questionType: _questionType,
                    orderType: _orderType,
                  ),
                ),
              );
            },
            child: const Text('スタート💪'),
          ),
        ),
      ),
    );
  }
}
