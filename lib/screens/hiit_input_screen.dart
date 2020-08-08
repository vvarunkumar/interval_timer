import 'package:flutter/material.dart';
import 'package:workout_timer/components/color_picker_dialog.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/custom_widgets/extras_card.dart';
import 'package:workout_timer/custom_widgets/name_set_card.dart';
import 'package:workout_timer/components/reusable_card.dart';
import 'package:workout_timer/components/exercise_data.dart';
import 'package:workout_timer/model.dart';
import 'package:workout_timer/components/row_text_duration.dart';
import 'package:workout_timer/components/duration_picker.dart';

class HIITInputScreen extends StatefulWidget {
  @override
  _HIITInputScreenState createState() => _HIITInputScreenState();
}

class _HIITInputScreenState extends State<HIITInputScreen> {
  final _name = TextEditingController();
  bool _validateName = false;
  TimerData _hiitData;

  void durationPickerDialogue({
    BuildContext context,
    Duration initialDuration,
    String title,
  }) {
    showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return DurationPickerDialog(
          initialDuration: initialDuration,
          title: Text('$title'),
        );
      },
    ).then((delay) {
      if (delay == null) return;
      setState(() {
        if (title == _hiitData.exerciseDetailList[0].name) {
          _hiitData.exerciseDetailList[0].duration = delay;
        } else if (title == _hiitData.exerciseDetailList[1].name) {
          _hiitData.exerciseDetailList[1].duration = delay;
        } else if (title == 'Starting Countdown') {
          _hiitData.startDelay = delay;
        }
      });
    });
    kRemoveFocus(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hiitData = defaultTimerData;
    _hiitData.exerciseDetailList.add(ExerciseDetails(
      name: 'High Intensity',
      duration: Duration(seconds: 0),
      color: Colors.deepOrangeAccent,
    ));
    _hiitData.exerciseDetailList.add(ExerciseDetails(
      name: 'Low Intensity',
      duration: Duration(seconds: 0),
      color: Colors.indigoAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            kRemoveFocus(context);
          },
          child: Column(
            children: <Widget>[
              Container(
                height: deviceHeight * 0.92,
                child: ListView(
                  children: <Widget>[
                    buildNameSetCard(
                      name: _name,
                      validateName: _validateName,
                      timerData: _hiitData,
                    ),
                    CustomCard(
                      child: Column(
                        children: <Widget>[
                          RowTextDuration(
                            text: _hiitData.exerciseDetailList[0].name,
                            duration: _hiitData.exerciseDetailList[0].duration,
                            onTap: () {
                              durationPickerDialogue(
                                context: context,
                                title: _hiitData.exerciseDetailList[0].name,
                                initialDuration: _hiitData.exerciseDetailList[0].duration,
                              );
                            },
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _hiitData.exerciseDetailList[0].color);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _hiitData.exerciseDetailList[0].color = value;
                                });
                              });
                            },
                            selectedColor: _hiitData.exerciseDetailList[0].color,
                          ),
                          RowTextDuration(
                            text: _hiitData.exerciseDetailList[1].name,
                            duration: _hiitData.exerciseDetailList[1].duration,
                            onTap: () {
                              durationPickerDialogue(
                                context: context,
                                title: _hiitData.exerciseDetailList[1].name,
                                initialDuration: _hiitData.exerciseDetailList[1].duration,
                              );
                            },
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _hiitData.exerciseDetailList[1].color);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _hiitData.exerciseDetailList[1].color = value;
                                });
                              });
                            },
                            selectedColor: _hiitData.exerciseDetailList[1].color,
                          ),
                        ],
                      ),
                    ),
                    CustomCard(
                      child: RowTextDuration(
                        text: 'Starting Countdown',
                        duration: _hiitData.startDelay,
                        onTap: () {
                          durationPickerDialogue(
                              title: 'Starting Countdown', initialDuration: _hiitData.startDelay);
                        },
                        selectedColor: _hiitData.colorCountDown,
                        onColorTap: () {
                          showDialog<Color>(
                              context: context,
                              builder: (context) {
                                return ColorPickerDialog(selectedColor: _hiitData.colorCountDown);
                              }).then((value) {
                            if (value == null) return;
                            setState(() {
                              _hiitData.colorCountDown = value;
                            });
                          });
                        },
                      ),
                    ),
                    BuildExtrasCard(
                      timerData: _hiitData,
                      vibrate: _hiitData.vibrate,
                      onSwitch: (bool value) {
                        setState(() {
                          _hiitData.vibrate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: deviceHeight * 0.08,
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Center(
                      child: Text(
                        'START',
                        style: TextStyle(fontSize: deviceHeight * 0.03),
                      ),
                    ),
                    color: Color(0xFF12C99B),
                    margin: EdgeInsets.only(top: 10.0),
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
