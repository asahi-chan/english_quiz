class Word {
  const Word({
    required this.id,
    required this.english,
    required this.japanese,
    required this.level,
    required this.isFavorite,
  });

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
