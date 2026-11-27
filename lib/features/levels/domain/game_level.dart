class GameLevel {
  const GameLevel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.pieceCount,
  });

  final int id;
  final String title;
  final String difficulty;
  final int pieceCount;

  factory GameLevel.fromJson(Map<String, dynamic> json) {
    return GameLevel(
      id: json['id'] as int,
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,
      pieceCount: json['piece_count'] as int,
    );
  }
}
