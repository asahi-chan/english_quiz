import 'package:english_quiz/model/word.dart';
import 'package:english_quiz/repository/word_repository.dart';

final List<Word> quizList = [];

final WordRepository _wordRepository = WordRepository();

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
  final words = await _wordRepository.fetchAllWords();
  setQuiz(words, orderType);
}
