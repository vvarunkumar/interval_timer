import 'package:flutter/material.dart';
import 'package:workout_timer/constants.dart';

class ExerciseDetails {
  String name;
  Duration duration;

  ExerciseDetails({this.name, this.duration});
}

class ExerciseData {
  List<ExerciseDetails> exerciseDetailList = [];

  void addExerciseData(ExerciseDetails exerciseDetail) {
    exerciseDetailList.add(exerciseDetail);
  }

  void deleteExerciseData(ExerciseDetails exerciseDetail) {
    print(listSize);
    exerciseDetailList.remove(exerciseDetail);
    print(listSize);
  }

  get listSize => exerciseDetailList.length;
}

class ExerciseRowData extends StatelessWidget {
  final String name;
  final Duration duration;
  final Function onPress;
  final Function onDelete;

  ExerciseRowData({this.name, this.duration, this.onPress, this.onDelete});

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
          onPressed: onDelete,
        )
      ],
    );
  }
}
