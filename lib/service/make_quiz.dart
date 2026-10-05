//

import 'package:english_quiz/model/word.dart';
import 'package:english_quiz/repository/word_repository.dart';

final WordRepository _wordRepository = WordRepository();

// クイズリストを読み込む関数
Future<List<Word>> loadQuiz(
  String orderType,
  List<String> levels,
  int questionCount,
  int? startQuestionNumber,
) async {
  return _wordRepository.fetchAllWords(
    levels: levels,
    orderType: orderType,
    questionCount: questionCount,
    startQuestionNumber: startQuestionNumber,
  );
}
