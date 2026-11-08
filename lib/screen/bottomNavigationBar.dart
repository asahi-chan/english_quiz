import 'package:flutter/material.dart';

import 'favoritesWords.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.quiz), label: '問題'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'ふせん済み'),
      ],
      onTap: (index) {
        if (index == currentIndex) {
          return;
        }

        if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FavoritesWordsScreen(),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
