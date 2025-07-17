import 'package:matching_app/models/game_item.dart';

class GameCategory {
  final String name;
  final List<GameItem> items;

  GameCategory({required this.name, required this.items});

  factory GameCategory.fromMap(Map<dynamic, dynamic> map) {
    var itemsList = <GameItem>[];
    if (map['items'] != null) {
      for (var itemMap in (map['items'] as List)) {
        itemsList.add(GameItem.fromMap(itemMap));
      }
    }
    return GameCategory(name: map['name'] ?? '', items: itemsList);
  }
}
