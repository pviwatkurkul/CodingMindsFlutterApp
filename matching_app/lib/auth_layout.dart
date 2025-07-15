import 'package:flutter/material.dart';
import 'package:matching_app/auth_service.dart';
import './main1.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.hasData) {
              widget = QuizPage();
            } else {
              widget = SigninPage();
            }
            return widget;
          },
        );
      },
    );
  }
}
