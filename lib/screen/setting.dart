import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'quiz.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const _questionTypeKey = 'settings.questionType';
  static const _orderTypeKey = 'settings.orderType';
  static const _questionCountKey = 'settings.questionCount';
  static const _selectedLevelsKey = 'settings.selectedLevels';
  static const _startQuestionNumberKey = 'settings.startQuestionNumber';
  static const _cardTextStyle = TextStyle(fontSize: 16);
  static const _cardSectionTitleStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

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
  };

  bool get _isQuestionNumberFilterEnabled =>
      _startQuestionNumberController.text.isNotEmpty;

  List<String> get _selectedLevels => _levelSelections.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  int? get _startQuestionNumber {
    final text = _startQuestionNumberController.text;
    if (text.isEmpty) {
      return null;
    }

    return int.tryParse(text);
  }

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuestionType = prefs.getString(_questionTypeKey);
    final savedOrderType = prefs.getString(_orderTypeKey);
    final savedQuestionCount = prefs.getString(_questionCountKey);
    final savedSelectedLevels = prefs.getStringList(_selectedLevelsKey) ?? [];
    final savedStartQuestionNumber =
        prefs.getString(_startQuestionNumberKey) ?? '';

    if (!mounted) {
      return;
    }

    setState(() {
      if (savedQuestionType != null) {
        _questionType = savedQuestionType;
      }
      if (savedOrderType != null) {
        _orderType = savedOrderType;
      }
      if (savedQuestionCount != null) {
        _questionCount = savedQuestionCount;
      }

      for (final level in _levelSelections.keys) {
        _levelSelections[level] = savedSelectedLevels.contains(level);
      }

      _startQuestionNumberController.text = savedStartQuestionNumber;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_questionTypeKey, _questionType);
    await prefs.setString(_orderTypeKey, _orderType);
    await prefs.setString(_questionCountKey, _questionCount);
    await prefs.setStringList(_selectedLevelsKey, _selectedLevels);
    await prefs.setString(
      _startQuestionNumberKey,
      _startQuestionNumberController.text,
    );
  }

  @override
  void dispose() {
    _startQuestionNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('出題設定'),
        backgroundColor: const Color.fromARGB(255, 142, 219, 255),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //出題範囲
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('出題範囲', style: _cardSectionTitleStyle),
                            const SizedBox(height: 8),
                            const Text('レベルから絞る', style: _cardTextStyle),
                            GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 2.4,
                              children: _levelSelections.entries.map((entry) {
                                return CheckboxListTile(
                                  title: Text(entry.key, style: _cardTextStyle),
                                  value: entry.value,
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                  onChanged: _isQuestionNumberFilterEnabled
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _levelSelections[entry.key] =
                                                value ?? false;
                                          });
                                          _saveSettings();
                                        },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('問題番号から絞る：', style: _cardTextStyle),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: _startQuestionNumberController,
                                    style: _cardTextStyle,
                                    keyboardType: TextInputType.number,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (_) {
                                      setState(() {});
                                      _saveSettings();
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
                                const Text('番以降から出題', style: _cardTextStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '※CEFRを参考に学習難易度の目安として単語のレベルを分類しています。公式な語彙リストを示すものではありません。',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  //出題数
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('出題数', style: _cardSectionTitleStyle),
                            GridView.count(
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 2.0,
                              children: ['5', '10', '20', '50'].map((choice) {
                                return RadioListTile<String>(
                                  title: Text(choice, style: _cardTextStyle),
                                  value: choice,
                                  groupValue: _questionCount,
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _questionCount = value;
                                    });
                                    _saveSettings();
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  //出題形式
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('出題形式', style: _cardSectionTitleStyle),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text(
                                      '英→日',
                                      style: _cardTextStyle,
                                    ),
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
                                      _saveSettings();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text(
                                      '日→英',
                                      style: _cardTextStyle,
                                    ),
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
                                      _saveSettings();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  //順番
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('順番', style: _cardSectionTitleStyle),
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text(
                                      '番号順',
                                      style: _cardTextStyle,
                                    ),
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
                                      _saveSettings();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: const Text(
                                      'ランダム',
                                      style: _cardTextStyle,
                                    ),
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
                                      _saveSettings();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 86, 156),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
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
                    questionCount: int.parse(_questionCount),
                    startQuestionNumber: _startQuestionNumber,
                  ),
                ),
              );
            },
            child: const Text('スタート💪', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
