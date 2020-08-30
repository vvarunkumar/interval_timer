import 'package:flutter/material.dart';
import 'package:workout_timer/components/color_picker_dialog.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/custom_widgets/bottom_button.dart';
import 'package:workout_timer/custom_widgets/extras_card.dart';
import 'package:workout_timer/custom_widgets/name_set_card.dart';
import 'package:workout_timer/components/reusable_card.dart';
import 'package:workout_timer/components/exercise_data.dart';
import 'package:workout_timer/components/row_text_duration.dart';
import 'package:workout_timer/components/duration_picker.dart';
import 'package:workout_timer/screens/timer_screen.dart';
import 'package:workout_timer/screens/home_screen/timer_data_card.dart';
import 'package:workout_timer/model/timer_data.dart';
import 'package:workout_timer/services/timer_shared_prefs.dart';
import 'package:workout_timer/services/analytics_service.dart';

class HIITInputScreen extends StatefulWidget {
  final TimerCards timerCards;
  final TimerData timerData;
  final int index;

  const HIITInputScreen({Key key, this.timerCards, this.timerData, this.index}) : super(key: key);

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
    int step,
  }) {
    showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return DurationPickerDialog(
          initialDuration: initialDuration,
          title: Text('$title'),
          step: step ?? 1,
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

  void initializeDefault() {
    _hiitData = defaultTimerData;
    _hiitData.timerType = TimerType.hiit;
    _hiitData.exerciseCount = 2;
    _hiitData.exerciseDetailList.add(ExerciseDetails(
      name: 'High Intensity',
      duration: Duration(seconds: 30),
      color: Colors.deepOrangeAccent,
      splitInterval: false,
    ));
    _hiitData.exerciseDetailList.add(ExerciseDetails(
      name: 'Low Intensity',
      duration: Duration(seconds: 30),
      color: Colors.indigoAccent,
      splitInterval: false,
    ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.timerData == null)
      initializeDefault();
    else {
      _hiitData = widget.timerData;
      _name.text = widget.timerData.timerName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            kRemoveFocus(context);
          },
          child: Column(
            children: <Widget>[
              Expanded(
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
                          ExerciseRowWidget(
                            text: _hiitData.exerciseDetailList[0].name,
                            duration: _hiitData.exerciseDetailList[0].duration,
                            splitInterval: _hiitData.exerciseDetailList[0].splitInterval,
                            onSplitIntervalSwitch: (value) {
                              setState(() {
                                _hiitData.exerciseDetailList[0].splitInterval = value;
                              });
                            },
                            onDurationTap: () {
                              durationPickerDialogue(
                                context: context,
                                title: _hiitData.exerciseDetailList[0].name,
                                initialDuration: _hiitData.exerciseDetailList[0].duration,
                                step: 10,
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
                          ExerciseRowWidget(
                            text: _hiitData.exerciseDetailList[1].name,
                            duration: _hiitData.exerciseDetailList[1].duration,
                            splitInterval: _hiitData.exerciseDetailList[1].splitInterval,
                            onSplitIntervalSwitch: (value) {
                              setState(() {
                                _hiitData.exerciseDetailList[1].splitInterval = value;
                              });
                            },
                            onDurationTap: () {
                              durationPickerDialogue(
                                context: context,
                                title: _hiitData.exerciseDetailList[1].name,
                                initialDuration: _hiitData.exerciseDetailList[1].duration,
                                step: 10,
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
                              context: context,
                              title: 'Starting Countdown',
                              initialDuration: _hiitData.startDelay);
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
              BottomButton(
                buttonName: 'SAVE',
                onTap: () async {
                  setState(() {
                    _name.text.isEmpty ? _validateName = true : _validateName = false;
                  });
                  if (_validateName == true) return;
                  _hiitData.timerName = _name.text;

                  if (widget.timerData == null) {
                    widget.timerCards.timerCardList
                        .add(TimerCardData(timerCardName: _name.text, timerData: _hiitData));
                    await AnalyticsService()
                        .logTimerData(name: 'New_HIIT_Timer_Created', timerData: _hiitData);
                  } else {
                    widget.timerCards.timerCardList[widget.index] =
                        TimerCardData(timerCardName: _name.text, timerData: _hiitData);

                    await AnalyticsService()
                        .logTimerData(name: 'Old_HIIT_Timer_Edited', timerData: _hiitData);
                  }
                  saveHomeData(timerCards: widget.timerCards);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
