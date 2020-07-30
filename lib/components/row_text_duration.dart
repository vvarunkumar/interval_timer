import 'package:flutter/material.dart';
import 'package:workout_timer/constants.dart';

class RowTextDuration extends StatelessWidget {
  final String text;
  final Duration duration;
  final Function onPress;

  RowTextDuration({this.text, this.duration, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        FlatButton(
          child: Text(
            formatTime(duration),
            style: TextStyle(
              color: Color(0xFFD2D2D2),
            ),
          ),
          onPressed: onPress,
        ),
      ],
    );
  }
}
