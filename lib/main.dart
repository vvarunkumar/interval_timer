import 'package:flutter/material.dart';
import 'package:interval_timer/screens/input_screen/input_screen.dart';
import 'package:interval_timer/screens/home_screen/home_screen.dart';
import 'package:interval_timer/screens/timer_screen.dart';

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
