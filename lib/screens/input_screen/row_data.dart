import 'package:flutter/material.dart';
import 'package:interval_timer/constants.dart';

class ExerciseRowData extends StatelessWidget {
  final String name;
  final Duration duration;
  final Function onPress;

  ExerciseRowData({this.name, this.duration, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name,
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
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Color(0xFFB3B3B3),
          ),
          onPressed: () {},
        )
      ],
    );
  }
}

class RowData extends StatefulWidget {
  final String text;

  const RowData({Key key, this.text}) : super(key: key);

  @override
  _RowDataState createState() => _RowDataState();
}

class _RowDataState extends State<RowData> {
  Duration duration = Duration(seconds: 0);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          widget.text,
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
          onPressed: () {},
        ),
      ],
    );
  }
}
