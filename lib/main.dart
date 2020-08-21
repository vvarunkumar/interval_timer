import 'package:flutter/material.dart';
import 'package:workout_timer/screens/home_screen/home_screen.dart';
import 'package:workout_timer/screens/timer_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF3A63F6),
        accentColor: Color(0xFF7591F8),
      ),
      home: HomeScreen(),
    );
  }
}
