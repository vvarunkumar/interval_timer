import 'package:flutter/material.dart';
import 'package:htimer_app/components/description_dialog.dart';
import 'package:screen/screen.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/model/workout.dart';

class TimerScreen extends StatefulWidget {
  final TimerData timerData;

  const TimerScreen({Key key, this.timerData}) : super(key: key);
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Workout _workout;
  bool isFinished = false;
  bool showSkip = false;

  String stepName(WorkoutState step) {
    switch (step) {
      case WorkoutState.initial:
        return 'Ready';
      case WorkoutState.starting:
        return 'Starting';
      case WorkoutState.finished:
        showSkip = false;
        return _workout.exerciseName;
      default:
        return _workout.exerciseName;
    }
  }

  Color textColour(Color color) {
    if (color == null) return Colors.white;
    final brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.light ? Colors.black : Colors.white;
  }

  @override
  void initState() {
    super.initState();
    _workout = Workout(widget.timerData, _onWorkoutChanged); // _onWorkoutChanged()
  }

  @override
  dispose() {
//    stopTextToSpeech();
    _workout.dispose();
    Screen.keepOn(false);
    super.dispose();
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
    showSkip = true;
    _workout.start();
    Screen.keepOn(true);
  }

  _pause() {
    _workout.pause();
    Screen.keepOn(false);
  }

  Widget bottomButtons() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: showSkip ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          isFinished
              ? CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    alignment: Alignment.center,
                    icon: Icon(
                      Icons.replay,
                      color: Colors.white,
                    ),
                    iconSize: 40.0,
                    onPressed: () {
                      _workout = Workout(widget.timerData, _onWorkoutChanged);
                      isFinished = false;
                      _start();
                    },
                  ),
                )
              : CircleAvatar(
                  radius: 30.0,
                  backgroundColor: _workout.isActive ? Color(0xFF7391C8) : Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(
                      _workout.isActive ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    iconSize: 40.0,
                    onPressed: _workout.isActive ? _pause : _start,
                  ),
                ),
          showSkip
              ? CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Color(0x9052688F),
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                    ),
                    iconSize: 40.0,
                    onPressed: () {
                      _workout.skip();
                    },
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final deviceWidth = MediaQuery.of(context).size.width;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final kHorizontalDivider = Divider(
      thickness: deviceHeight * 0.002,
      color: Color(0xFF707070),
      indent: deviceWidth * 0.1,
      endIndent: deviceWidth * 0.1,
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: isPortrait
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        '${_workout.timerName}',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    kHorizontalDivider,
                    TextContainerBox(
                      text: formatTime(_workout.timeLeft ?? Duration(seconds: 0)),
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
                              text: '${_workout.currentSet}/${_workout.totalSet}',
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
                    GestureDetector(
                      onTap: () {
                        if (_workout.exerciseDescription == null) return;
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return ShowDescriptionDialog(
                                description: _workout.exerciseDescription,
                              );
                            });
                      },
                      child: Container(
                        height: deviceHeight * 0.3,
                        width: deviceWidth * 0.8,
//                margin: EdgeInsets.only(top: deviceHeight * 0.05),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _workout.exerciseColor ??
                              (_workout.step == WorkoutState.starting
                                  ? _workout.colorCountdown
                                  : Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            stepName(_workout.step),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textColour(_workout.exerciseColor),
                              fontSize: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: bottomButtons(),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        '${_workout.timerName}',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 35.0,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextContainerBox(
                              text: '${_workout.currentExercise}/${_workout.totalNoOfExercise}',
                              height: 30.0,
                              width: 100.0,
                            ),
                            TextContainerBox(
                              text: 'Exercise No',
                              height: 20.0,
                              width: 100.0,
                              margin: EdgeInsets.only(top: deviceHeight * 0.003),
                            ),
                          ],
                        ),
                        AutoSizeText(
                          formatTime(_workout.timeLeft ?? Duration(seconds: 0)),
                          style: TextStyle(
                            fontSize: 135.0,
                          ),
                        ),
//                        TextContainerBox(
//                          text: formatTime(_workout.timeLeft ?? Duration(seconds: 0)),
//                          height: deviceHeight * 0.2,
//                          width: deviceWidth * 0.8,
//                        ),
                        Column(
                          children: <Widget>[
                            TextContainerBox(
                              text: '${_workout.currentSet}/${_workout.totalSet}',
                              height: 30.0,
                              width: 100.0,
                            ),
                            TextContainerBox(
                              text: 'Sets',
                              height: 20.0,
                              width: 100.0,
                              margin: EdgeInsets.only(top: deviceHeight * 0.003),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 80.0,
                      width: deviceWidth * 0.8,
//                      margin: EdgeInsets.only(top: deviceHeight * 0.05),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _workout.exerciseColor ??
                            (_workout.step == WorkoutState.starting
                                ? _workout.colorCountdown
                                : Colors.indigoAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          stepName(_workout.step),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColour(_workout.exerciseColor),
                            fontSize: 50.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: bottomButtons(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
