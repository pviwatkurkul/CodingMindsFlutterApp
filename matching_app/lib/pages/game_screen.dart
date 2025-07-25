// filepath: c:\dev\CodingMindsFlutterApp\matching_app\lib\pages\game_screen.dart
import 'package:flutter/material.dart';
import 'package:matching_app/models/game_item.dart';
import 'package:matching_app/models/game_category.dart';
import 'package:matching_app/widgets/round_timer.dart';
import 'package:matching_app/pages/results_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matching_app/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameState();
}

class _GameState extends State<GameScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final GlobalKey<TimerState> _timerKey = GlobalKey<TimerState>();

  late Future<List<GameCategory>> _gameDataFuture;

  List<GameCategory> _allCategories = [];
  int _currentRound = 0;

  String _currentCategoryName = "";
  List<GameItem> _displayItems = [];
  List<GameItem> _selectedItems = [];

  Color? _buttonColor;

  bool _isGameFinished = false;
  bool _isTimeUp = false;

  @override
  void initState() {
    super.initState();
    _gameDataFuture = _fetchGameData();
  }

  Future<List<GameCategory>> _fetchGameData() async {
    final snapshot = await _databaseRef.child('rounds').get();
    if (snapshot.exists && snapshot.value != null) {
      final roundsData = Map<String, dynamic>.from(snapshot.value as Map);
      final categories = roundsData.values
          .map(
            (roundData) =>
                GameCategory.fromMap(Map<String, dynamic>.from(roundData)),
          )
          .toList();
      return categories;
    } else {
      throw Exception('No game data found in Firebase.');
    }
  }

  void _restartGame() {
    setState(() {
      _allCategories.clear();
      _currentRound = 0;
      _isGameFinished = false;
      _isTimeUp = false;
      _gameDataFuture = _fetchGameData();
    });
  }

  void _onTimeUp() {
    setState(() {
      _isTimeUp = true;
    });
  }

  void startNewRound() {
    if (_currentRound >= _allCategories.length) {
      print("Game Over!");
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerKey.currentState?.start();
    });

    setState(() {
      _currentRound++;
      final currentCategory = _allCategories[_currentRound - 1];
      _currentCategoryName = currentCategory.name;
      _buttonColor = Colors.black;
      _selectedItems.clear();
      _displayItems = List.from(currentCategory.items)..shuffle();
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
    final correctItemsInRound = _displayItems
        .where((item) => item.isCorrect)
        .toSet();
    final selectedItems = _selectedItems.toSet();

    bool isAnswerCorrect =
        correctItemsInRound.length == selectedItems.length &&
        correctItemsInRound.containsAll(selectedItems);

    // Check for win condition
    if (isAnswerCorrect && _currentRound >= _allCategories.length) {
      setState(() {
        _isGameFinished = true;
        _buttonColor = Colors.green;
      });
      return; // Stop further execution
    }
    setState(() {
      _buttonColor = isAnswerCorrect ? Colors.green : Colors.redAccent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GameCategory>>(
      future: _gameDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Loading Game...')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(
              child: Text('Could not load game data: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.hasData && _allCategories.isEmpty) {
          _allCategories = snapshot.data!;
          // Use a post-frame callback to ensure the first build is complete
          WidgetsBinding.instance.addPostFrameCallback((_) {
            startNewRound();
          });
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: logout,
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_allCategories.isNotEmpty)
                  Text(
                    'ROUND $_currentRound/${_allCategories.length}',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                TimerWidget(key: _timerKey, onTimerEnd: _onTimeUp),
                SizedBox(height: 80),
                Text(
                  _currentCategoryName,
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: 'Select image(s) that match ',
                    style: TextStyle(fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$_currentCategoryName',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 64),
                Wrap(
                  alignment: WrapAlignment.center,
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
                        margin: EdgeInsets.all(8.0),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                            width: 4,
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
                SizedBox(height: 20),
                if (_isTimeUp)
                  ElevatedButton(
                    onPressed: _restartGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Keep the green color
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0,
                      ),
                    ),
                    child: Text(
                      'Times Up! Try Again?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (_isGameFinished)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ResultsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Keep the green color
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0,
                      ),
                    ),
                    child: Text(
                      'Finish Game',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (_buttonColor == Colors.green)
                  ElevatedButton(
                    onPressed: startNewRound,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Keep the green color
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0,
                      ),
                    ),
                    child: Text(
                      'Next Round',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0,
                      ),
                    ),
                    child: Text(
                      'Confirm Selection',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_buttonColor == Colors.redAccent && !_isTimeUp)
                  Text(
                    'Try again!',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
