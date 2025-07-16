import 'package:flutter/material.dart';
import 'package:matching_app/models/game_item.dart';
import 'package:matching_app/models/game_category.dart';
import 'package:matching_app/widgets/round_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matching_app/auth_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameState();
}

class _GameState extends State<GameScreen> {
  final List<GameCategory> _allCategories = [
    GameCategory(
      name: "Fruits",
      items: [
        GameItem(
          name: "Apple",
          imageUrl: "lib/assets/apple.jpg",
          isCorrect: true,
        ),
        GameItem(
          name: "Banana",
          imageUrl: "lib/assets/banana.jpg",
          isCorrect: true,
        ),
        GameItem(
          name: "Potato",
          imageUrl: "lib/assets/potato.jpg",
          isCorrect: false,
        ),
      ],
    ),
    // ... more categories
  ];

  int _currentRound = 1;
  // int _timeLeft = 30;
  // late Timer _timer;

  String _currentCategoryName = "";
  List<GameItem> _displayItems = [];
  // List<GameItem> _selectedItems = [];

  void startNewRound() {
    final currentCategory = _allCategories[_currentRound - 1];
    setState(() {
      _currentCategoryName = currentCategory.name;
      _displayItems = currentCategory.items;
      _displayItems.shuffle();
    });
  }

  void logout() async {
    try {
      await authService.value.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ROUND 1/5'),
            Text('0:30'),
            Text(_currentCategoryName),
            Text('Select images that match $_currentCategoryName'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _displayItems.map((item) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(item.imageUrl),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 175),
            ElevatedButton(onPressed: () {}, child: Text('Confirm selection')),
            ElevatedButton(
              onPressed: startNewRound,
              child: Text('Start Round'),
            ),
          ],
        ),
      ),
    );
  }
}
