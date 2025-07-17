import 'package:flutter/material.dart';
import 'package:matching_app/pages/game_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Over'),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congratulations!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Text(
              'You beat the game!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // Navigate to a new game screen, removing the old one from history
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
