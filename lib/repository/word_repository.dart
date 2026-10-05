// データベースとクラスをもとに単語データをリストとして作成する

import 'package:english_quiz/database/database_helper.dart';
import 'package:english_quiz/model/word.dart';

class WordRepository {
  WordRepository({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _databaseHelper;

  Future<List<Word>> fetchAllWords({List<String> levels = const []}) async {
    final db = await _databaseHelper.database;
    final hasLevelFilter = levels.isNotEmpty;
    final wordMaps = await db.query(
      'words',
      where: hasLevelFilter
          ? 'level IN (${List.filled(levels.length, '?').join(', ')})'
          : null,
      whereArgs: hasLevelFilter ? levels : null,
      orderBy: 'id ASC',
    );

    return wordMaps.map((wordMap) => Word.fromMap(wordMap)).toList();
  }
}
