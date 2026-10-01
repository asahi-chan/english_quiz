class Word {
  const Word({
    required this.id,
    required this.english,
    required this.japanese,
    required this.level,
    required this.isFavorite,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'] as int,
      english: map['english'] as String,
      japanese: map['japanese'] as String,
      level: map['level'] as String,
      isFavorite: _parseIsFavorite(map['is_favorite']),
    );
  }

  static bool _parseIsFavorite(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is int) {
      return value != 0;
    }
    throw ArgumentError.value(
      value,
      'value',
      'is_favorite must be bool or int',
    );
  }

  final int id;
  final String english;
  final String japanese;
  final String level;
  final bool isFavorite;
}
