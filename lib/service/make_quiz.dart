//

import 'package:english_quiz/model/word.dart';
import 'package:english_quiz/repository/word_repository.dart';

final WordRepository _wordRepository = WordRepository();

// クイズリストを設定する関数
List<Word> setQuiz(List<Word> words, String orderType) {
  final orderedWords = List<Word>.from(words);

  if (orderType == 'random') {
    orderedWords.shuffle();
  } else {
    orderedWords.sort((first, second) => first.id.compareTo(second.id));
  }

  return orderedWords;
}

// クイズリストを読み込む関数
Future<List<Word>> loadQuiz(String orderType, List<String> levels) async {
  final words = await _wordRepository.fetchAllWords(levels: levels);
  return setQuiz(words, orderType);
}
