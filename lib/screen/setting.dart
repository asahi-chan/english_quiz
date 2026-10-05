import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'quiz.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startQuestionNumberController = TextEditingController();
  String _questionType = 'englishToJapanese';
  String _orderType = 'numberOrder';
  String _questionCount = '5';
  final Map<String, bool> _levelSelections = {
    'A1': false,
    'A2': false,
    'B1': false,
    'B2': false,
    'C1': false,
    'C2': false,
  };

  bool get _isQuestionNumberFilterEnabled =>
      _startQuestionNumberController.text.isNotEmpty;

  List<String> get _selectedLevels => _levelSelections.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  @override
  void dispose() {
    _startQuestionNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('出題設定'),
                  const SizedBox(height: 24),
                  //出題範囲
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('出題範囲'),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.4,
                          children: _levelSelections.entries.map((entry) {
                            return CheckboxListTile(
                              title: Text(entry.key),
                              value: entry.value,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              onChanged: _isQuestionNumberFilterEnabled
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _levelSelections[entry.key] =
                                            value ?? false;
                                      });
                                    },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('問題番号から絞る：'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _startQuestionNumberController,
                                keyboardType: TextInputType.number,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (_) {
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }

                                  final number = int.tryParse(value);
                                  if (number == null || number <= 0) {
                                    return '1以上の自然数を入力してください';
                                  }

                                  if (number > 10000) {
                                    return '10000以下で入力してください';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('番以降から出題'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  //出題数
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('出題数'),
                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.0,
                          children: ['5', '10', '20', '50'].map((choice) {
                            return RadioListTile<String>(
                              title: Text(choice),
                              value: choice,
                              groupValue: _questionCount,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }

                                setState(() {
                                  _questionCount = value;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
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
                  const SizedBox(height: 16),
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
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (!(_formKey.currentState?.validate() ?? false)) {
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  //loadQuiz()を呼び出すのはQuizScreenであり、loadQuiz()はorderTypeやquestionTypeが必要だから
                  //QuizScreenにこれらを渡している。
                  builder: (context) => QuizScreen(
                    questionType: _questionType,
                    orderType: _orderType,
                    selectedLevels: _selectedLevels,
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
