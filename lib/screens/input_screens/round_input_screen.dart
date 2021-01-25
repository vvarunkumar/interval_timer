import 'package:flutter/material.dart';
import 'package:htimer_app/components/color_picker_dialog.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/widgets/bottom_button.dart';
import 'package:htimer_app/widgets/extras_card.dart';
import 'package:htimer_app/widgets/name_set_card.dart';
import 'package:htimer_app/components/reusable_card.dart';
import 'package:htimer_app/data/exercise_data.dart';
import 'package:htimer_app/components/row_text_duration.dart';
import 'package:htimer_app/components/duration_picker.dart';
import 'package:htimer_app/data/timer_card.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/services/analytics_service.dart';

class RoundInputScreen extends StatefulWidget {
  final TimerCards timerCards;
  final TimerData timerData;
  final int index;

  const RoundInputScreen({Key key, this.timerCards, this.timerData, this.index}) : super(key: key);

  @override
  _RoundInputScreenState createState() => _RoundInputScreenState();
}

class _RoundInputScreenState extends State<RoundInputScreen> {
  final _name = TextEditingController();
  bool _validateName = false;
  TimerData _roundTimerData;

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
        if (title == _roundTimerData.exerciseDetailList[0].name) {
          _roundTimerData.exerciseDetailList[0].duration = delay;
        } else if (title == _roundTimerData.exerciseDetailList[1].name) {
          _roundTimerData.exerciseDetailList[1].duration = delay;
        } else if (title == 'Starting Countdown') {
          _roundTimerData.startDelay = delay;
        }
      });
    });
    kRemoveFocus(context);
  }

  void initializeDefault() {
    _roundTimerData = defaultTimerData;
    _roundTimerData.timerType = TimerType.round;
    _roundTimerData.exerciseCount = 2;
    _roundTimerData.exerciseDetailList.add(ExerciseDetails(
      name: 'Rounds',
      duration: Duration(seconds: 30),
      color: Colors.deepOrangeAccent,
      splitInterval: false,
    ));
    _roundTimerData.exerciseDetailList.add(ExerciseDetails(
      name: 'Breaks',
      duration: Duration(seconds: 10),
      color: Colors.indigoAccent,
      splitInterval: false,
    ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.timerData == null) {
      initializeDefault();
    } else {
      _roundTimerData = widget.timerData;
      _name.text = widget.timerData.timerName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kPrimaryThemeColor,
        title: Text('Round Timer'),
      ),
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
                      timerData: _roundTimerData,
                    ),
                    CustomCard(
                      child: Column(
                        children: <Widget>[
                          RowTextDuration(
                            text: _roundTimerData.exerciseDetailList[0].name,
                            duration: _roundTimerData.exerciseDetailList[0].duration,
                            onTap: () {
                              durationPickerDialogue(
                                context: context,
                                title: _roundTimerData.exerciseDetailList[0].name,
                                initialDuration: _roundTimerData.exerciseDetailList[0].duration,
                                step: 10,
                              );
                            },
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _roundTimerData.exerciseDetailList[0].color);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _roundTimerData.exerciseDetailList[0].color = value;
                                });
                              });
                            },
                            selectedColor: _roundTimerData.exerciseDetailList[0].color,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          RowTextDuration(
                            text: _roundTimerData.exerciseDetailList[1].name,
                            duration: _roundTimerData.exerciseDetailList[1].duration,
                            onTap: () {
                              durationPickerDialogue(
                                context: context,
                                title: _roundTimerData.exerciseDetailList[1].name,
                                initialDuration: _roundTimerData.exerciseDetailList[1].duration,
                                step: 5,
                              );
                            },
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _roundTimerData.exerciseDetailList[1].color);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _roundTimerData.exerciseDetailList[1].color = value;
                                });
                              });
                            },
                            selectedColor: _roundTimerData.exerciseDetailList[1].color,
                          ),
                        ],
                      ),
                    ),
                    CustomCard(
                      child: RowTextDuration(
                        text: 'Starting Countdown',
                        duration: _roundTimerData.startDelay,
                        onTap: () {
                          durationPickerDialogue(
                              context: context,
                              title: 'Starting Countdown',
                              initialDuration: _roundTimerData.startDelay);
                        },
                        selectedColor: _roundTimerData.colorCountDown,
                        onColorTap: () {
                          showDialog<Color>(
                              context: context,
                              builder: (context) {
                                return ColorPickerDialog(
                                    selectedColor: _roundTimerData.colorCountDown);
                              }).then((value) {
                            if (value == null) return;
                            setState(() {
                              _roundTimerData.colorCountDown = value;
                            });
                          });
                        },
                      ),
                    ),
                    BuildExtrasCard(
                      timerData: _roundTimerData,
                      vibrate: _roundTimerData.vibrate,
                      onSwitch: (bool value) {
                        setState(() {
                          _roundTimerData.vibrate = value;
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
                  _roundTimerData.timerName = _name.text.trim();

                  if (widget.timerData == null) {
                    widget.timerCards.addData(
                        TimerCardData(timerCardName: _name.text, timerData: _roundTimerData));

                    await AnalyticsService()
                        .logTimerData(name: 'New_Round_Timer_Created', timerData: _roundTimerData);
                  } else {
                    widget.timerCards.replaceData(
                        timerCardData:
                            TimerCardData(timerCardName: _name.text, timerData: _roundTimerData),
                        index: widget.index);

                    await AnalyticsService()
                        .logTimerData(name: 'Old_Round_Timer_Edited', timerData: _roundTimerData);
                  }
//                  saveHomeData(timerCards: widget.timerCards);

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

/*
                          ExerciseRowWidget(
                            text: _roundTimerData.exerciseDetailList[0].name,
                            duration: _roundTimerData.exerciseDetailList[0].duration,
                            splitInterval: _roundTimerData.exerciseDetailList[0].splitInterval,
                            onSplitIntervalSwitch: (value) {
                              setState(() {
                                _roundTimerData.exerciseDetailList[0].splitInterval = value;
                              });
                            },
                            onDurationTap: () {
                              durationPickerDialogue(
                                context: context,
                                title: _roundTimerData.exerciseDetailList[0].name,
                                initialDuration: _roundTimerData.exerciseDetailList[0].duration,
                                step: 10,
                              );
                            },
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _roundTimerData.exerciseDetailList[0].color);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _roundTimerData.exerciseDetailList[0].color = value;
                                });
                              });
                            },
                            selectedColor: _roundTimerData.exerciseDetailList[0].color,
                          ),
                          ExerciseRowWidget(
                            text: _roundTimerData.exerciseDetailList[1].name,
                            duration: _roundTimerData.exerciseDetailList[1].duration,
                            splitInterval: _roundTimerData.exerciseDetailList[1].splitInterval,
                            onSplitIntervalSwitch: (value) {
                              setState(() {
                                _roundTimerData.exerciseDetailList[1].splitInterval = value;
                              });
                            },
                            onDurationTap: () {
                              durationPickerDialogue(
                                context: context,
                                title: _roundTimerData.exerciseDetailList[1].name,
                                initialDuration: _roundTimerData.exerciseDetailList[1].duration,
                                step: 10,
                              );
                            },
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _roundTimerData.exerciseDetailList[1].color);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _roundTimerData.exerciseDetailList[1].color = value;
                                });
                              });
                            },
                            selectedColor: _roundTimerData.exerciseDetailList[1].color,
                          ),
 */
