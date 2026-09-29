import 'dart:convert';

import 'package:flutter/services.dart';

final List<Word> quizList = [];

// jsonから単語リストを作成する関数
//今後はここでフィルターするべき？
List<Word> wordsFromJson(String source) {
  final decoded = jsonDecode(source) as List<dynamic>;
  return decoded
      .map((item) => Word.fromJson(item as Map<String, dynamic>))
      .toList();
}

// 単語クラス
class Word {
  const Word({
    required this.id,
    required this.english,
    required this.japanese,
    required this.level,
    required this.isFavorite,
  });
  // JSONから単語オブジェクトを作成するファクトリコンストラクタ
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as int,
      english: json['english'] as String,
      japanese: json['japanese'] as String,
      level: json['level'] as String,
      isFavorite: json['is_favorite'] as bool,
    );
  }

  final int id;
  final String english;
  final String japanese;
  final String level;
  final bool isFavorite;
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
    'assets/data/english_words_10.json',
  );
  setQuiz(wordsFromJson(source), orderType);
}
