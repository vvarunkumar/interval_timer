import 'package:flutter/material.dart';
import 'timer_type_card.dart';
import 'file:///D:/Code/AndroidStudioProjects/Github/workout_timer/lib/screens/tabata_input_screen.dart';
import 'file:///D:/Code/AndroidStudioProjects/Github/workout_timer/lib/model.dart';
import 'package:workout_timer/screens/timer_screen.dart';

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
          Navigator.push(context, MaterialPageRoute(builder: (context) => TabataInputScreen()));
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
                TimerTypeCard(
                  timerName: 'HIIT Timer',
                ),
                TimerTypeCard(
                  timerName: 'Tabata Timer',
                ),
                TimerTypeCard(
                  timerName: 'Compound Timer',
                ),
                TimerTypeCard(
                  timerName: 'Custom Timer',
                  onPressed: () {
                    TimerData _timerData = defaultTabataData;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimerScreen(
                                  timerData: _timerData,
                                )));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
