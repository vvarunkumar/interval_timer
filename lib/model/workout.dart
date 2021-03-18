import 'dart:async';
import 'package:flutter/material.dart';
import 'package:htimer_app/data/exercise_data.dart';
import 'package:vibration/vibration.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/services/analytics_service.dart';
import 'package:htimer_app/services/text_to_speech.dart';

class Workout {
  TimerData _config;
  Function _onStateChange;

  Workout(this._config, this._onStateChange);

  WorkoutState _step = WorkoutState.initial;

  Timer _timer;

  /// Time left in the current step
  Duration _timeLeft;

  ///Total Duration
  Duration _totalDuration;

  /// Time Elapsed
  Duration _elapsedTime = Duration(seconds: 0);

  ///Colors
  Color _exerciseColor;

  ///Stores execution path
  List<Path> path = [];
  List<ExerciseDetails> _exerciseDetailList;


/// Starts or resumes the workout
  start() {
    flutterTtsInitialize();

    switch (_config.timerType) {
      case TimerType.hiit:
        _startHiit();
        break;
      case TimerType.tabata:
        _startTabata();
        break;
    }
  }

  _startHiit() {
    //TODO: Path for HIIT Timer
    _hiitPath();

    if (_step == WorkoutState.initial) {
      _step = WorkoutState.starting;

      if (_config.startDelay.inSeconds == 0) {
        nextStep();
      } else {
        speakIt(_config.startDelay.inSeconds.toString());
        _timeLeft = _config.startDelay;
      }
    }
    _timer = Timer.periodic(Duration(seconds: 1), _tick);
    _onStateChange();
  }

  _hiitPath() {
    //TODO Create Path here
    int totalSet = _config.sets;
    int currentSet = 1;
    _exerciseDetailList = _config.exerciseDetailList;

    for (currentSet = 1; currentSet <= totalSet; currentSet++) {
      if (_exerciseDetailList[0].splitInterval) {
        path.add(Path(
          state: WorkoutState.highIntensity,
          stateName: '${_exerciseDetailList[0].name}\n(Left)',
          duration: _exerciseDetailList[0].duration,
          color: _exerciseDetailList[0].color,
          currentExerciseNo: 1,
          currentSetNo: currentSet,
        ));
        path.add(Path(
          state: WorkoutState.highIntensity,
          stateName: '${_exerciseDetailList[0].name}\n(Right)',
          duration: _exerciseDetailList[0].duration,
          color: _exerciseDetailList[0].color,
          currentExerciseNo: 1,
          currentSetNo: currentSet,
        ));
      } else {
        path.add(Path(
          state: WorkoutState.highIntensity,
          stateName: _exerciseDetailList[0].name,
          duration: _exerciseDetailList[0].duration,
          color: _exerciseDetailList[0].color,
          currentExerciseNo: 1,
          currentSetNo: currentSet,
        ));
      }

      if (_exerciseDetailList[1].splitInterval) {
        path.add(Path(
          state: WorkoutState.lowIntensity,
          stateName: '${_exerciseDetailList[1].name}\n(Left)',
          duration: _exerciseDetailList[1].duration,
          color: _exerciseDetailList[1].color,
          currentExerciseNo: 2,
          currentSetNo: currentSet,
        ));
        path.add(Path(
          state: WorkoutState.lowIntensity,
          stateName: '${_exerciseDetailList[1].name}\n(Right)',
          duration: _exerciseDetailList[1].duration,
          color: _exerciseDetailList[1].color,
          currentExerciseNo: 2,
          currentSetNo: currentSet,
        ));
      } else {
        path.add(Path(
          state: WorkoutState.lowIntensity,
          stateName: _exerciseDetailList[1].name,
          duration: _exerciseDetailList[1].duration,
          color: _exerciseDetailList[1].color,
          currentExerciseNo: 2,
          currentSetNo: currentSet,
        ));
      }
    }

    path.add(Path(
      state: WorkoutState.finished,
      duration: Duration(seconds: 0),
      stateName: 'Finished',
      color: Colors.black54,
      currentExerciseNo: 2,
      currentSetNo: totalSet,
    ));
  }

  _startTabata() {
    _exerciseDetailList = _config.exerciseDetailList;
    _config.tabataStyle ? _tabataStylePath() : _circuitPath();

    if (_step == WorkoutState.initial) {
      _step = WorkoutState.starting;

      if (_config.startDelay.inSeconds == 0) {
        nextStep();
      } else {
        speakIt(_config.startDelay.inSeconds.toString());
        _timeLeft = _config.startDelay;
      }
    }
    _timer = Timer.periodic(Duration(seconds: 1), _tick);
    _onStateChange();
  }

  /// Pauses the workout
  pause() {
    _timer.cancel();
    _onStateChange();
  }

  /// Stops the timer without triggering the state change callback.
  dispose() {
    if (_timer != null) _timer.cancel();
  }

  /// Shows the timer delay
  _tick(Timer timer) {
    if (_step != WorkoutState.starting) {
      _elapsedTime += Duration(seconds: 1);
    }

    if (_timeLeft.inSeconds <= 1) {
      nextStep();
    } else {
      _timeLeft -= Duration(seconds: 1);

      if (_config.alertName == '10 Second Count') {
        if (_timeLeft.inSeconds <= 10) speakIt(_timeLeft.inSeconds.toString());
      } else {
        if (_timeLeft.inSeconds <= 3 && _timeLeft.inSeconds >= 1) {
          if (_config.alertName == 'Text-to-Speech with Count') {
            switch (_timeLeft.inSeconds) {
              case 3:
                speakIt('three');
                break;
              case 2:
                speakIt('two');
                break;
              case 1:
                speakIt('one');
                break;
            }
          } else if (_config.alertName == 'Single Beep') {
            playSound('timerBeep.mp3');
          }
        }

        if (_config.vibrate && _timeLeft.inSeconds <= 3) {
          Vibration.vibrate();
        }
      }
//      if (_timeLeft.inSeconds <= 3 && _timeLeft.inSeconds >= 1) {
//        _playSound(_settings.countdownPip);
//      }
    }
    _onStateChange();
  }

  /// Next Step to executed
  String _exerciseName = '';
  int index = 0;
  int hiitCurrentSet = 0;
  int _currentExerciseNo = 0;
  int _currentSetNo = 0;

  nextStep() {
    if (index >= path.length) {
      return;
    }
    _step = path[index].state;

    if (_step == WorkoutState.finished) {
      _finish();
      return;
    }

//    switch (_step) {
//      case WorkoutState.exercising:
//        _currentExerciseIndex = (_currentExerciseIndex + 1) % (totalNoOfExercise + 1);
//        if (_currentExerciseIndex == 0) {
//          _currentSet++;
//          _currentExerciseIndex = 1;
//        }
//        break;
//      case WorkoutState.highIntensity:
//        _currentExerciseIndex = 1;
//        hiitCurrentSet++;
//        _currentSet = hiitCurrentSet;
//        break;
//      case WorkoutState.lowIntensity:
//        _currentExerciseIndex = 2;
//        break;
//      case WorkoutState.finished:
//        _finish();
//        break;
//      default:
//        break;
//    }
    _exerciseName = path[index].stateName;

    if (path[index].state == WorkoutState.finished) {
      speakIt('End of Timer');
    } else {
      if (_config.alertName == 'Text-to-Speech with Count' ||
          _config.alertName == 'Text-to-Speech without Count') {
        speakIt(_exerciseName);
      } else if (_config.alertName == 'Single Beep') {
        playSound('timerEnd.mp3');
      } else if (_config.alertName == '10 Second Count') {
        if (_timeLeft.inSeconds <= 10) speakIt(path[index].duration.inSeconds.toString());
      }
    }
    _currentExerciseNo = path[index].currentExerciseNo;
    _currentSetNo = path[index].currentSetNo;
    _exerciseColor = path[index].color;
    _timeLeft = path[index].duration;

    index--;
  }
  get config => _config;

  get currentSet => _currentSetNo;

  get totalSet => _config.sets;

  get step => _step;

  get timeLeft => _timeLeft;

  get totalTime => _elapsedTime;

  get currentExercise => _currentExerciseNo;

  get totalNoOfExercise => _config.exerciseDetailList.length;

  get isActive => _timer != null && _timer.isActive;

  get exerciseName => _exerciseName;

  get exerciseDescription => _description;

  get exerciseColor => _exerciseColor;

  get colorCountdown => _config.colorCountDown;

  get timerName => _config.timerName;
}

///Path class is used to store each step
class Path {
  WorkoutState state;
  Duration duration;
  String stateName;
  String exerciseDescription;
  Color color;
  int currentExerciseNo;
  int currentSetNo;

  Path(
      {this.state,
      this.duration,
      this.stateName,
      this.exerciseDescription,
      this.color,
      this.currentExerciseNo,
      this.currentSetNo});
}
