import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:english_quiz/model/word.dart';
//import 'package:sqflite/sqflite.dart';

final List<Word> quizList = [];

// jsonから単語リストを作成する関数
//今後はここでフィルターするべき？
List<Word> wordsFromJson(String source) {
  final decoded = jsonDecode(source) as List<dynamic>;
  return decoded
      .map((item) => Word.fromJson(item as Map<String, dynamic>))
      .toList();
}

// クイズリストを設定する関数
void setQuiz(List<Word> words, String orderType) {
  final orderedWords = List<Word>.from(words);

  if (orderType == 'random') {
    orderedWords.shuffle();
  } else {
    orderedWords.sort((first, second) => first.id.compareTo(second.id));
  }

  quizList
    ..clear()
    ..addAll(orderedWords);
}

// クイズリストを読み込む関数
Future<void> loadQuiz(String orderType) async {
  final source = await rootBundle.loadString(
    'assets/data/english_words_60.json',
  );
  setQuiz(wordsFromJson(source), orderType);
}
