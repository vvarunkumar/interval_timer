import 'package:flutter/material.dart';
import 'package:workout_timer/screens/home_screen/home_screen.dart';
import 'package:workout_timer/screens/timer_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
