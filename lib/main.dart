import 'package:flutter/material.dart';
import 'package:project_app/Question_Page/dbConnect.dart';
import 'package:project_app/splash_screen/splash.dart';
import 'package:firebase_core/firebase_core.dart';

// @dart=2.9

void main() {
  DBConnect().fetchQuestions();
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
