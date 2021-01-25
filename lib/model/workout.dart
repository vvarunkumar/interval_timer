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

    _exerciseDetailList = _config.exerciseDetailList;

    switch (_config.timerType) {
      case TimerType.hiit:
        _hiitPath();
        break;
      case TimerType.tabata:
        _config.tabataStyle ? _tabataStylePath() : _circuitPath();
        break;
      case TimerType.round:
        _roundTimerPath();
        break;
      case TimerType.custom:
        _circuitPath();
        break;
    }

    _totalDuration = _calculateTotalDuration();

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

  ///Skip
  skip() {
    nextStep();
    _onStateChange();
  }

  ///Called when workout is over
  _finish() async {
    _timer.cancel();
    _timeLeft = Duration(seconds: 0);
    await AnalyticsService().logTimerData(name: 'Timer_Finished_Fully', timerData: _config);
    print("Workout finished. This is finish method");
  }

  /// Stops the timer without triggering the state change callback.
  dispose() {
    if (_timer != null) _timer.cancel();
    stopTextToSpeech();
  }

  int currentPathDuration = 0;

  /// Shows the timer delay
  _tick(Timer timer) {
    if (_step != WorkoutState.starting) {
      _elapsedTime += Duration(seconds: 1);
    }

    if (_timeLeft.inSeconds <= 1) {
      nextStep();
    } else {
      _timeLeft -= Duration(seconds: 1);

      if (_step == WorkoutState.starting) {
        speakIt('${_timeLeft.inSeconds}');
      } else {
        if (_config.alertName == '10 Second Count') {
          if (_timeLeft.inSeconds <= 10) speakIt(_timeLeft.inSeconds.toString());
        } else {
          bool flag = currentPathDuration < 14;

          if (_timeLeft.inSeconds <= (flag ? 5 : 10) && _timeLeft.inSeconds >= 1) {
            if (_config.alertName == 'Text-to-Speech with Count') {
              speakIt('${_timeLeft.inSeconds}');
            } else if (_config.alertName == 'Single Beep') {
              playSound('timerBeep.mp3');
            }
          }

          if (_config.vibrate && _timeLeft.inSeconds <= 3) {
            Vibration.vibrate();
          }
        }
      }
    }
    _onStateChange();
  }

  /// Next Step to executed
  String _exerciseName = '';
  String _description;
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
    }

    _exerciseName = path[index].stateName;
    _description = path[index].exerciseDescription;

    if (path[index].state == WorkoutState.finished) {
      speakIt('End of Timer');
    } else {
      if (_config.alertName == 'Text-to-Speech with Count' ||
          _config.alertName == 'Text-to-Speech without Count') {
        speakIt('${_exerciseName} for ${speakTime(path[index].duration)}');
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
    currentPathDuration = path[index].duration.inSeconds;

    index++;
  }

  ///Total Duration
  Duration _calculateTotalDuration() {
    Duration total = Duration(seconds: 0);
    for (Path currentPath in path) {
      total += currentPath.duration;
    }
    return total;
  }

  ///Circuit/Tabata Path Creation
  _circuitPath() {
    int totalExercise = _config.exerciseCount;
    int totalSets = _config.sets;
    int setNo = 1;
    int exerciseNo = 0;
    WorkoutState state = WorkoutState.exercising;

    if (_config.randomise == true) {
      _exerciseDetailList.shuffle();
    }

    while (state != WorkoutState.finished) {
      if (state == WorkoutState.exercising) {
        if (_exerciseDetailList[exerciseNo].splitInterval) {
          Duration splitDuration =
              Duration(seconds: _exerciseDetailList[exerciseNo].duration.inSeconds ~/ 2);

          path.add(Path(
            state: WorkoutState.exercising,
            duration: splitDuration,
            stateName: '${_exerciseDetailList[exerciseNo].name}\n(Left)',
            exerciseDescription: '${_exerciseDetailList[exerciseNo].description}',
            color: _exerciseDetailList[exerciseNo].color,
            currentExerciseNo: exerciseNo + 1,
            currentSetNo: setNo,
          ));
          path.add(Path(
            state: WorkoutState.exercising,
            duration: splitDuration,
            stateName: '${_exerciseDetailList[exerciseNo].name}\n(Right)',
            exerciseDescription: '${_exerciseDetailList[exerciseNo].description}',
            color: _exerciseDetailList[exerciseNo].color,
            currentExerciseNo: exerciseNo + 1,
            currentSetNo: setNo,
          ));
        } else {
          path.add(Path(
            state: WorkoutState.exercising,
            duration: _exerciseDetailList[exerciseNo].duration,
            stateName: _exerciseDetailList[exerciseNo].name,
            exerciseDescription: '${_exerciseDetailList[exerciseNo].description}',
            color: _exerciseDetailList[exerciseNo].color,
            currentExerciseNo: exerciseNo + 1,
            currentSetNo: setNo,
          ));
        }

        exerciseNo++;

        if (exerciseNo == totalExercise)
          state = WorkoutState.setRest;
        else
          state = WorkoutState.intervalRest;
      } else if (state == WorkoutState.intervalRest) {
        if (_config.restIntervals != Duration(seconds: 0)) {
          path.add(Path(
            state: WorkoutState.intervalRest,
            duration: _config.restIntervals,
            stateName: 'Interval Rest',
            exerciseDescription: 'Interval Rest',
            color: _config.colorInterval,
            currentExerciseNo: exerciseNo,
            currentSetNo: setNo,
          ));
        }
        state = WorkoutState.exercising;
      } else if (state == WorkoutState.setRest) {
        if (setNo == totalSets) {
          state = WorkoutState.finished;
          path.add(Path(
            state: WorkoutState.finished,
            duration: Duration(seconds: 0),
            stateName: 'Finished',
            exerciseDescription: 'Finished',
            color: Colors.black54,
            currentSetNo: totalSets,
            currentExerciseNo: totalExercise,
          ));
          continue;
        }
        if (_config.randomise == true) {
          _exerciseDetailList.shuffle();
        }

        if (_config.restSets != Duration(seconds: 0)) {
          path.add(Path(
            state: WorkoutState.setRest,
            duration: _config.restSets,
            stateName: 'Set Rest',
            exerciseDescription: 'Set Rest',
            color: _config.colorSetRest,
            currentExerciseNo: totalExercise,
            currentSetNo: setNo,
          ));
        }
        setNo++;
        exerciseNo = 0;
        state = WorkoutState.exercising;
      }
    }
  }

  /// Tabata Style Path
  _tabataStylePath() {
    int totalExercise = _config.exerciseCount;
    int totalSets = _config.sets;
    int setNo;

    for (int exerciseNo = 0; exerciseNo < totalExercise; exerciseNo++) {
      for (setNo = 1; setNo <= totalSets; setNo++) {
        if (_exerciseDetailList[exerciseNo].splitInterval) {
          Duration splitDuration =
              Duration(seconds: _exerciseDetailList[exerciseNo].duration.inSeconds ~/ 2);
          path.add(Path(
            state: WorkoutState.exercising,
            duration: splitDuration,
            stateName: '${_exerciseDetailList[exerciseNo].name}\n(Left)',
            exerciseDescription: '${_exerciseDetailList[exerciseNo].description}',
            color: _exerciseDetailList[exerciseNo].color,
            currentExerciseNo: exerciseNo + 1,
            currentSetNo: setNo,
          ));
          path.add(Path(
            state: WorkoutState.exercising,
            duration: splitDuration,
            stateName: '${_exerciseDetailList[exerciseNo].name}\n(Right)',
            exerciseDescription: '${_exerciseDetailList[exerciseNo].description}',
            color: _exerciseDetailList[exerciseNo].color,
            currentExerciseNo: exerciseNo + 1,
            currentSetNo: setNo,
          ));
        } else {
          path.add(Path(
            state: WorkoutState.exercising,
            duration: _exerciseDetailList[exerciseNo].duration,
            stateName: _exerciseDetailList[exerciseNo].name,
            exerciseDescription: '${_exerciseDetailList[exerciseNo].description}',
            color: _exerciseDetailList[exerciseNo].color,
            currentExerciseNo: exerciseNo + 1,
            currentSetNo: setNo,
          ));
        }

        if (setNo != totalSets) {
          path.add(Path(
            state: WorkoutState.intervalRest,
            duration: _config.restIntervals,
            stateName: 'Interval Rest',
            exerciseDescription: 'Interval Rest',
            color: _config.colorSetRest,
            currentExerciseNo: exerciseNo + 1,
            currentSetNo: setNo,
          ));
        }
      }

      if (exerciseNo == totalExercise - 1) {
        path.add(Path(
          state: WorkoutState.finished,
          duration: Duration(seconds: 0),
          stateName: 'Finished',
          exerciseDescription: 'Finished',
          color: Colors.black54,
          currentExerciseNo: exerciseNo + 1,
          currentSetNo: totalSets,
        ));
      } else {
        path.add(Path(
          state: WorkoutState.setRest,
          duration: _config.restSets,
          stateName: 'Set Rest',
          exerciseDescription: 'Set Rest',
          color: _config.colorSetRest,
          currentExerciseNo: exerciseNo + 1,
          currentSetNo: totalSets,
        ));
      }
    }
  }

  ///HIIT Path
  _hiitPath() {
    int totalSet = _config.sets;
    int currentSet = 1;

    for (currentSet = 1; currentSet <= totalSet; currentSet++) {
      if (_exerciseDetailList[0].splitInterval) {
        Duration splitDuration = Duration(seconds: _exerciseDetailList[0].duration.inSeconds ~/ 2);
        path.add(Path(
          state: WorkoutState.highIntensity,
          stateName: '${_exerciseDetailList[0].name}\n(Left)',
          duration: splitDuration,
          color: _exerciseDetailList[0].color,
          currentExerciseNo: 1,
          currentSetNo: currentSet,
        ));
        path.add(Path(
          state: WorkoutState.highIntensity,
          stateName: '${_exerciseDetailList[0].name}\n(Right)',
          duration: splitDuration,
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
        Duration splitDuration = Duration(seconds: _exerciseDetailList[1].duration.inSeconds ~/ 2);
        path.add(Path(
          state: WorkoutState.lowIntensity,
          stateName: '${_exerciseDetailList[1].name}\n(Left)',
          duration: splitDuration,
          color: _exerciseDetailList[1].color,
          currentExerciseNo: 2,
          currentSetNo: currentSet,
        ));
        path.add(Path(
          state: WorkoutState.lowIntensity,
          stateName: '${_exerciseDetailList[1].name}\n(Right)',
          duration: splitDuration,
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

  ///Round Timer Path
  _roundTimerPath() {
    int totalSet = _config.sets;
    int currentSet = 1;

    for (currentSet = 1; currentSet <= totalSet; currentSet++) {
      path.add(Path(
        state: WorkoutState.rounds,
        stateName: 'Round $currentSet',
        duration: Duration(seconds: _exerciseDetailList[0].duration.inSeconds),
        color: _exerciseDetailList[0].color,
        currentExerciseNo: 1,
        currentSetNo: currentSet,
      ));

      if (currentSet != totalSet) {
        path.add(Path(
          state: WorkoutState.breaks,
          stateName: 'Break',
          duration: Duration(seconds: _exerciseDetailList[1].duration.inSeconds),
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
