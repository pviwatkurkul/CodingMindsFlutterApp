import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/auth_service.dart';
import 'package:matching_app/pages/game_screen.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartState();
}

class _StartState extends State<StartPage> {
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
            Text(
              'Welcome to QuizIt!',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 36.0,
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Click and match the images to the category given. You are timed and must make it through all the rounds to win. Good luck and have fun!',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
              child: Text(
                'Start Round',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
