import 'package:flutter/material.dart';
import 'package:matching_app/auth_service.dart';
import 'package:matching_app/pages/start_screen.dart';
import 'package:matching_app/pages/signin_page.dart';

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
              widget = StartPage();
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
