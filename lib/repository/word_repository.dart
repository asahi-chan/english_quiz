import 'package:english_quiz/database/database_helper.dart';
import 'package:english_quiz/model/word.dart';

class WordRepository {
  WordRepository({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _databaseHelper;

  Future<List<Word>> fetchAllWords() async {
    final db = await _databaseHelper.database;
    final wordMaps = await db.query('words', orderBy: 'id ASC');

    return wordMaps.map((wordMap) => Word.fromMap(wordMap)).toList();
  }
}
