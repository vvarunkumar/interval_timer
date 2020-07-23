import 'package:flutter/material.dart';
import 'exercise_card.dart';
import 'package:interval_timer/screens/input_screen/input_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF12C99B),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InputScreen()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ExerciseCard(
                  timerName: 'HIIT Timer',
                ),
                ExerciseCard(
                  timerName: 'Tabata Timer',
                ),
                ExerciseCard(
                  timerName: 'Compound Timer',
                ),
                ExerciseCard(
                  timerName: 'Custom Timer',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
