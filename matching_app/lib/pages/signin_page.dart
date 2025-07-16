// filepath: lib/pages/signin_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/auth_service.dart';
import 'package:matching_app/pages/register_page.dart';

class SigninPage extends StatefulWidget {
  @override
  State<SigninPage> createState() => _SiginState();
}

class _SiginState extends State<SigninPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  void signIn() async {
    try {
      await authService.value.signIn(
        email: email.text,
        password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'This is not working';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Text(
                      'Welcome to QuizIt',
                      style: TextStyle(fontSize: 24, color: Colors.lightBlue),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20, color: Colors.lightBlue),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.lightBlue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.deepPurpleAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        labelText: 'Enter your email',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: password,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.lightBlue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.deepPurpleAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        labelText: 'Enter your password',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text('Don\'t have an account? Register Here'),
                    ),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signIn();
                        }
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
