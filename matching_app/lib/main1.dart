import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyFormState(),
      child: MaterialApp(
        title: 'Matching App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: FormPage(),
      ),
    );
  }
}

class MyFormState extends ChangeNotifier {}

class FormPage extends StatefulWidget {
  @override
  State<FormPage> createState() => _UserFormState();
}

class _UserFormState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
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
                    SizedBox(height: 24),

                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@gmail.com')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
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
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuizPage()),
                          );
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

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizState();
}

class _QuizState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Text(
                      'Testing Page',
                      style: TextStyle(fontSize: 24, color: Colors.lightBlue),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(onPressed: null, child: Text('Login')),
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
