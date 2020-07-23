import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final String timerName;

  ExerciseCard({this.timerName});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 10.0, horizontal: deviceWidth * 0.1),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF12C99B),
        ),
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(0xFF1D1D1D),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.timer,
              size: 25.0,
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.08,
          ),
          Text(
            timerName,
            style: TextStyle(fontSize: 25.0),
          ),
        ],
      ),
    );
  }
}
