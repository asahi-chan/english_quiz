import 'package:flutter/material.dart';
import 'package:english_quiz/model/word.dart';
import 'package:english_quiz/repository/word_repository.dart';

import 'bottomNavigationBar.dart';

class FavoritesWordsScreen extends StatefulWidget {
  const FavoritesWordsScreen({super.key});

  @override
  State<FavoritesWordsScreen> createState() => _FavoritesWordsScreenState();
}

class _FavoritesWordsScreenState extends State<FavoritesWordsScreen> {
  late final Future<List<Word>> _favoriteWordsFuture;
  final WordRepository _wordRepository = WordRepository();
  final Set<int> _removingWordIds = {};

  @override
  void initState() {
    super.initState();
    _favoriteWordsFuture = _wordRepository.fetchFavoriteWords();
  }

  Future<void> _confirmRemoveFavorite(
    Word word,
    List<Word> favoriteWords,
  ) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('${word.english}(${word.japanese})を削除しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('はい'),
            ),
          ],
        );
      },
    );

    if (shouldRemove == true && mounted) {
      await _removeFavorite(word, favoriteWords);
    }
  }

  Future<void> _removeFavorite(Word word, List<Word> favoriteWords) async {
    setState(() {
      _removingWordIds.add(word.id);
    });

    try {
      await _wordRepository.updateFavorite(word.id, false);
    } on Exception catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _removingWordIds.remove(word.id);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ふせんの削除に失敗しました: $error')));
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _removingWordIds.remove(word.id);
      favoriteWords.removeWhere((favoriteWord) => favoriteWord.id == word.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ふせんを付けた単語'),
        backgroundColor: const Color.fromARGB(255, 142, 219, 255),
      ),
      body: FutureBuilder<List<Word>>(
        future: _favoriteWordsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('ふせんを付けた単語の読み込みに失敗しました。\n\n${snapshot.error}'),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteWords = snapshot.data ?? [];
          if (favoriteWords.isEmpty) {
            return const Center(child: Text('ふせんを付けた単語はありません。'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favoriteWords.length,
            itemBuilder: (context, index) {
              final word = favoriteWords[index];
              return Card(
                child: ListTile(
                  title: Text(word.english),
                  subtitle: Text('${word.japanese}\n品詞：${word.partOfSpeech}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('No.${word.id}'),
                      IconButton(
                        onPressed: _removingWordIds.contains(word.id)
                            ? null
                            : () => _confirmRemoveFavorite(word, favoriteWords),
                        icon: const Icon(Icons.delete),
                        tooltip: 'ふせんを外す',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 1),
    );
  }
}
