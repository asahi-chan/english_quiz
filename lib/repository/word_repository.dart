// データベースとクラスをもとに単語データをリストとして作成する

import 'package:english_quiz/database/database_helper.dart';
import 'package:english_quiz/model/word.dart';

class WordRepository {
  WordRepository({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _databaseHelper;

  Future<List<Word>> fetchAllWords({
    List<String> levels = const [],
    required String orderType,
    required int questionCount,
    int? startQuestionNumber,
  }) async {
    final db = await _databaseHelper.database;
    final hasStartQuestionNumberFilter = startQuestionNumber != null;
    final hasLevelFilter = levels.isNotEmpty;
    final wordMaps = await db.query(
      'words',
      where: hasStartQuestionNumberFilter
          ? 'id >= ?'
          : hasLevelFilter
          ? 'level IN (${List.filled(levels.length, '?').join(', ')})'
          : null,
      whereArgs: hasStartQuestionNumberFilter
          ? [startQuestionNumber]
          : hasLevelFilter
          ? levels
          : null,
      orderBy: orderType == 'numberOrder' ? 'id ASC' : 'RANDOM()',
      limit: questionCount,
    );

    return wordMaps.map((wordMap) => Word.fromMap(wordMap)).toList();
  }
}
