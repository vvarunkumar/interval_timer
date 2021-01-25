import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:htimer_app/data/exercise_data.dart';
import 'package:htimer_app/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

TimerData get defaultTimerData => TimerData(
      timerName: 'Timer',
      timerType: TimerType.hiit,
      sets: 1,
      exerciseCount: 0,
      startDelay: Duration(seconds: 10),
      restIntervals: Duration(seconds: 0),
      restSets: Duration(seconds: 0),
      exerciseDetailList: [],
      colorSetRest: Colors.deepOrange,
      colorInterval: Colors.blueGrey,
      colorCountDown: Colors.teal,
      randomise: false,
      tabataStyle: false,
      vibrate: true,
      alertName: alertList[2],
    );

class TimerData {
  /// Sets in a workout
  int sets = 1;

  ///Timer Name
  String timerName = '';

  /// No of Exercise in a set
  int exerciseCount = 0;

  /// Duration List of Exercise
  List<ExerciseDetails> exerciseDetailList;

  /// Rest time between each Exercise
  Duration restIntervals = Duration(seconds: 0);

  /// Rest time between each Set
  Duration restSets = Duration(seconds: 0);

  /// Initial countdown before starting workout
  Duration startDelay = Duration(seconds: 3);

  ///Randomise Exercise Order
  bool randomise = false;

  ///Tabata Style
  bool tabataStyle = false;

  ///Vibrate on alert
  bool vibrate = true;

  ///Countdown Color
  Color colorCountDown = Colors.teal;

  ///Interval Color
  Color colorInterval = Colors.blueGrey;

  ///Set Color
  Color colorSetRest = Colors.deepOrange;

  ///Alert Name
  String alertName = alertList[2];

  TimerType timerType;

  TimerData({
    this.timerName,
    this.sets,
    this.exerciseCount,
    this.startDelay,
    this.restIntervals,
    this.exerciseDetailList,
    this.restSets,
    this.randomise,
    this.tabataStyle,
    this.colorCountDown,
    this.colorInterval,
    this.colorSetRest,
    this.vibrate,
    this.alertName,
    this.timerType,
  });

  Map<String, dynamic> toJson() => {
        'timerName': timerName,
        'timerType': timerType.index,
        'sets': sets,
        'exerciseCount': exerciseCount,
        'startDelay': startDelay.inSeconds,
        'restIntervals': restIntervals.inSeconds,
        'restSets': restSets.inSeconds,
        'exerciseDetailList': exerciseDetailList,
        'colorSetRest': colorSetRest.value,
        'colorInterval': colorInterval.value,
        'colorCountDown': colorCountDown.value,
        'randomise': randomise,
        'tabataStyle': tabataStyle,
        'vibrate': vibrate,
        'alertName': alertName,
      };

  factory TimerData.fromJson(Map<String, dynamic> json) {
    var exerciseListFromJson = json['exerciseDetailList'];
    List<dynamic> exerciseList = new List<dynamic>.from(exerciseListFromJson);
    List<ExerciseDetails> exerciseDetailsList = [];
    for (var exerciseItem in exerciseList) {
      exerciseDetailsList.add(ExerciseDetails.fromJson(exerciseItem));
    }

    return new TimerData(
        timerName: json['timerName'],
        timerType: TimerType.values[json['timerType']],
        sets: json['sets'],
        exerciseCount: json['exerciseCount'],
        startDelay: Duration(seconds: json['startDelay']),
        restIntervals: Duration(seconds: json['restIntervals']),
        restSets: Duration(seconds: json['restSets']),
        exerciseDetailList: exerciseDetailsList,
        colorSetRest: new Color(json['colorSetRest']),
        colorInterval: new Color(json['colorInterval']),
        colorCountDown: new Color(json['colorCountDown']),
        randomise: json['randomise'],
        tabataStyle: json['tabataStyle'],
        vibrate: json['vibrate'],
        alertName: json['alertName']);
  }
//  Duration getTotalTime() {
//    return (exerciseTime * sets * exerciseCount) +
//        (restInterval * sets * (exerciseCount - 1)) +
//        (breakTime * (sets - 1));
//  }
}
