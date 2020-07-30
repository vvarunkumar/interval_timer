import 'package:flutter/material.dart';
import 'package:workout_timer/components/text_container_box.dart';
import 'file:///D:/Code/AndroidStudioProjects/Github/workout_timer/lib/model.dart';
import 'package:workout_timer/constants.dart';
import 'package:screen/screen.dart';

class TimerScreen extends StatefulWidget {
  final TimerData timerData;

  const TimerScreen({Key key, this.timerData}) : super(key: key);
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Workout _workout;
  bool isFinished = false;

  String stepName(WorkoutState step) {
    switch (step) {
//    case WorkoutState.exercising:
//      return 'Exercise';
//    case WorkoutState.intervalRest:
//      return 'Interval Rest';
//    case WorkoutState.setRest:
//      return 'Set Rest';
//    case WorkoutState.finished:
//      return 'Finished';
      case WorkoutState.starting:
        return 'Starting';
      default:
        return _workout.exerciseName;
    }
  }

  @override
  void initState() {
    super.initState();
    _workout = Workout(widget.timerData, _onWorkoutChanged); // _onWorkoutChanged()
    _start();
    _pause();
  }

  _onWorkoutChanged() {
    if (_workout.step == WorkoutState.finished) {
      isFinished = true;
      Screen.keepOn(false);
    }
    this.setState(() {
      print('_onWorkoutChanged() called.');
    });
  }

  _start() {
    _workout.start();
    Screen.keepOn(true);
  }

  _pause() {
    _workout.pause();
    Screen.keepOn(false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final deviceWidth = MediaQuery.of(context).size.width;

    final kHorizontalDivider = Divider(
      thickness: deviceHeight * 0.002,
      color: Color(0xFF707070),
      indent: deviceWidth * 0.1,
      endIndent: deviceWidth * 0.1,
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              TextContainerBox(
                text: 'Timer Name',
                padding: EdgeInsets.all(10.0),
                height: deviceHeight * 0.08,
                width: double.infinity,
              ),
              kHorizontalDivider,
              TextContainerBox(
                text: formatTime(
                    _workout.timeLeft == null ? Duration(seconds: 0) : _workout.timeLeft),
                height: deviceHeight * 0.2,
                width: deviceWidth * 0.8,
              ),
              kHorizontalDivider,
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextContainerBox(
                        text: '${_workout.currentExercise}/${_workout.totalNoOfExercise}',
                        height: deviceHeight * 0.05,
                      ),
                      TextContainerBox(
                        text: 'Exercise No',
                        height: deviceHeight * 0.025,
                        margin: EdgeInsets.only(top: deviceHeight * 0.003),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextContainerBox(
                        text: '${_workout.set}/${_workout.totalSet}',
                        height: deviceHeight * 0.05,
                      ),
                      TextContainerBox(
                        text: 'Sets',
                        height: deviceHeight * 0.025,
                        margin: EdgeInsets.only(top: deviceHeight * 0.003),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              Container(
                height: deviceHeight * 0.3,
                width: deviceWidth * 0.8,
//                margin: EdgeInsets.only(top: deviceHeight * 0.05),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextContainerBox(
                  text: stepName(_workout.step),
                  height: deviceHeight * .10,
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: isFinished
                        ? CircleAvatar(
                            radius: deviceHeight * 0.05,
                            backgroundColor: Colors.teal,
                            child: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.replay,
                                color: Colors.white,
                              ),
                              iconSize: deviceHeight * 0.08,
                              onPressed: () {
                                _workout = Workout(widget.timerData, _onWorkoutChanged);
                                isFinished = false;
                                _start();
                              },
                            ),
                          )
                        : CircleAvatar(
                            radius: deviceHeight * 0.05,
                            backgroundColor: _workout.isActive ? Colors.black54 : Colors.blueAccent,
                            child: IconButton(
                              icon: Icon(
                                _workout.isActive ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              iconSize: deviceHeight * 0.08,
                              onPressed: _workout.isActive ? _pause : _start,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
