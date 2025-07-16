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
  final GlobalKey<TimerState> _timerKey = GlobalKey<TimerState>();

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
  ];

  int _currentRound = 1;

  String _currentCategoryName = "";
  List<GameItem> _displayItems = [];
  List<GameItem> _selectedItems = [];

  Color? _buttonColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // Start the first round as soon as the widget is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startNewRound();
    });
    startNewRound();
  }

  void startNewRound() {
    _timerKey.currentState?.start();

    final currentCategory = _allCategories[_currentRound - 1];
    setState(() {
      _currentCategoryName = currentCategory.name;
      _buttonColor = Colors.black; // Reset button color to default

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

  void _checkAnswer() {
    // Find all the correct items that are currently displayed.
    final correctItemsInRound = _displayItems
        .where((item) => item.isCorrect)
        .toSet();

    // Get the items the user actually selected.
    final selectedItems = _selectedItems.toSet();

    // The answer is correct if the set of selected items is identical
    // to the set of correct items for the round.
    bool isAnswerCorrect =
        correctItemsInRound.length == selectedItems.length &&
        correctItemsInRound.containsAll(selectedItems);

    setState(() {
      _buttonColor = isAnswerCorrect ? Colors.green : Colors.redAccent;
    });
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
            TimerWidget(key: _timerKey),
            Text(_currentCategoryName),
            Text('Select images that match $_currentCategoryName'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _displayItems.map((item) {
                final isSelected = _selectedItems.contains(item);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedItems.remove(item);
                      } else {
                        _selectedItems.add(item);
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 3,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(item.imageUrl),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 175),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Confirm selection', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
