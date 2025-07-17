class GameItem {
  final String name;
  final String imageUrl;
  final bool isCorrect;

  GameItem({
    required this.name,
    required this.imageUrl,
    required this.isCorrect,
  });

  factory GameItem.fromMap(Map<dynamic, dynamic> map) {
    final imageUrlFromDb = map['imageUrl'];

    return GameItem(
      name: map['name'] ?? '',
      imageUrl: (imageUrlFromDb is String) ? imageUrlFromDb.trim() : '',
      isCorrect: map['isCorrect'] ?? false,
    );
  }
}
