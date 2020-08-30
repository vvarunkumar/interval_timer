import 'package:flutter/material.dart';
import 'package:workout_timer/components/reusable_card.dart';
import 'package:workout_timer/components/row_text_duration.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/screens/home_screen/timer_data_card.dart';
import 'package:workout_timer/components/exercise_data.dart';
import 'package:workout_timer/components/duration_picker.dart';
import 'package:workout_timer/components/textEditing_dialog.dart';
import 'package:workout_timer/custom_widgets/name_set_card.dart';
import 'package:workout_timer/model/timer_data.dart';
import 'package:workout_timer/components/custom_reorderable_list_view.dart';
import 'package:workout_timer/components/color_picker_dialog.dart';
import 'package:workout_timer/custom_widgets/extras_card.dart';
import 'package:workout_timer/custom_widgets/bottom_button.dart';
import 'package:workout_timer/services/timer_shared_prefs.dart';
import 'package:workout_timer/components/error_dialog.dart';
import 'package:workout_timer/services/analytics_service.dart';

enum currentRow { setRest, intervalRest, startCountdown, exerciseTime }

class TabataInputScreen extends StatefulWidget {
  final TimerCards timerCards;
  final TimerData timerData;
  final int index;

  const TabataInputScreen({Key key, this.timerCards, this.timerData, this.index}) : super(key: key);

  @override
  _TabataInputScreenState createState() => _TabataInputScreenState();
}

class _TabataInputScreenState extends State<TabataInputScreen> {
  final _name = TextEditingController();

  TimerData _tabataData = TimerData();
  ExerciseData _exerciseData = ExerciseData();

  bool _validateName = false;

  Duration _intervalRestDuration = Duration(seconds: 0);
  Duration _setRestDuration = Duration(seconds: 0);
  Duration _startCountdownDuration = Duration(seconds: 3);

  void durationPickerDialogue({
    BuildContext context,
    currentRow rowName,
    int index,
    int step,
    Duration initialDuration,
    String title,
  }) {
    showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return DurationPickerDialog(
          initialDuration: initialDuration,
          step: step ?? 1,
          title: Text('$title'),
        );
      },
    ).then((delay) {
      if (delay == null) return;
      setState(() {
        if (rowName == currentRow.intervalRest)
          _intervalRestDuration = delay;
        else if (rowName == currentRow.setRest)
          _setRestDuration = delay;
        else if (rowName == currentRow.startCountdown)
          _startCountdownDuration = delay;
        else
          _exerciseData.exerciseDetailList[index].duration = delay;
      });
    });
    kRemoveFocus(context);
  }

  void initializeDefault() {
    _tabataData = defaultTimerData;
    _tabataData.timerType = TimerType.tabata;
  }

  void initializeEditData() {
    _tabataData = widget.timerData;
    _name.text = widget.timerData.timerName;
    _intervalRestDuration = widget.timerData.restIntervals;
    _setRestDuration = widget.timerData.restSets;
    _startCountdownDuration = widget.timerData.startDelay;
    _exerciseData.exerciseDetailList = widget.timerData.exerciseDetailList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.timerData == null) {
      initializeDefault();
    } else {
      initializeEditData();
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
                    ///Name-Set Card
                    buildNameSetCard(
                      name: _name,
                      validateName: _validateName,
                      timerData: _tabataData,
                    ),
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Exercises',
                            style: TextStyle(
                              color: Color(0xFFA6A6A6),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.02,
                          ),
                          Container(
                            height: 110.0 * _exerciseData.listSize,
                            constraints: BoxConstraints(
                              maxHeight: 350.0,
                            ),
                            child: MyReorderableListView(
                              scrollDirection: Axis.vertical,
                              onReorder: (int oldIndex, int newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final item = _exerciseData.exerciseDetailList[oldIndex];
                                  _exerciseData.exerciseDetailList.removeAt(oldIndex);
                                  _exerciseData.exerciseDetailList.insert(newIndex, item);
                                });
                              },
                              children: List.generate(
                                  _exerciseData.exerciseDetailList.length,
                                  (index) => TabataExerciseRow(
                                        key: Key('$index'),
                                        name: _exerciseData.exerciseDetailList[index].name,
                                        duration: _exerciseData.exerciseDetailList[index].duration,
                                        splitInterval:
                                            _exerciseData.exerciseDetailList[index].splitInterval,
                                        onSplitIntervalSwitch: (value) {
                                          setState(() {
                                            _exerciseData.exerciseDetailList[index].splitInterval =
                                                value;
                                          });
                                        },
                                        selectedColor:
                                            _exerciseData.exerciseDetailList[index].color,
                                        onColorTap: () {
                                          showDialog<Color>(
                                              context: context,
                                              builder: (context) {
                                                return ColorPickerDialog(
                                                    selectedColor: _exerciseData
                                                        .exerciseDetailList[index].color);
                                              }).then((value) {
                                            if (value == null) return;
                                            setState(() {
                                              _exerciseData.exerciseDetailList[index].color = value;
                                            });
                                          });
                                        },
                                        onNameTap: () {
                                          kRemoveFocus(context);
                                          showDialog<String>(
                                              context: context,
                                              builder: (context) {
                                                return TextEditingDialog(
                                                    initialVal: _exerciseData
                                                        .exerciseDetailList[index].name);
                                              }).then((value) {
                                            if (value == null) return;
                                            setState(() {
                                              _exerciseData.exerciseDetailList[index].name = value;
                                            });
                                          });
                                        },
                                        onDurationPress: () {
                                          setState(() {
                                            durationPickerDialogue(
                                                context: context,
                                                index: index,
                                                step: 10,
                                                initialDuration: _exerciseData
                                                    .exerciseDetailList[index].duration,
                                                title:
                                                    _exerciseData.exerciseDetailList[index].name);
                                          });
                                        },
                                        onDelete: (direction) {
                                          setState(() {
                                            _exerciseData.deleteExerciseData(
                                                _exerciseData.exerciseDetailList[index]);
                                          });
                                          kRemoveFocus(context);
                                        },
                                      )),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Color(0xFFB3B3B3),
                              ),
                              onPressed: () {
                                setState(() {
                                  _exerciseData.addExerciseData(ExerciseDetails(
                                    name: 'Exercise ${_exerciseData.listSize + 1}',
                                    duration: Duration(seconds: 30),
                                    splitInterval: false,
                                    color: Colors.indigoAccent,
                                  ));
                                });
                                kRemoveFocus(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    CustomCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Randomise Order',
                                style: kBoldTextStyle,
                              ),
                              Switch(
                                value: _tabataData.randomise,
                                activeColor: kSecondaryThemeColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    _tabataData.randomise = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Tabata Style',
                                style: kBoldTextStyle,
                              ),
                              Switch(
                                value: _tabataData.tabataStyle,
                                activeColor: kSecondaryThemeColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    _tabataData.tabataStyle = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomCard(
                      child: Column(
                        children: <Widget>[
                          RowTextDuration(
                            text: 'Starting Countdown',
                            duration: _startCountdownDuration,
                            selectedColor: _tabataData.colorCountDown,
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _tabataData.colorCountDown);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _tabataData.colorCountDown = value;
                                });
                              });
                            },
                            onTap: () {
                              durationPickerDialogue(
                                context: context,
                                rowName: currentRow.startCountdown,
                                initialDuration: _startCountdownDuration,
                                title: 'Countdown',
                              );
                            },
                          ),
                          RowTextDuration(
                            text: 'Rest Between Intervals',
                            duration: _intervalRestDuration,
                            selectedColor: _tabataData.colorInterval,
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _tabataData.colorInterval);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _tabataData.colorInterval = value;
                                });
                              });
                            },
                            onTap: () {
                              durationPickerDialogue(
                                  context: context,
                                  rowName: currentRow.intervalRest,
                                  initialDuration: _intervalRestDuration,
                                  step: 5,
                                  title: 'Rest');
                            },
                          ),
                          RowTextDuration(
                            text: 'Rest Between Sets',
                            duration: _setRestDuration,
                            selectedColor: _tabataData.colorSetRest,
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _tabataData.colorSetRest);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _tabataData.colorSetRest = value;
                                });
                              });
                            },
                            onTap: () {
                              durationPickerDialogue(
                                  context: context,
                                  rowName: currentRow.setRest,
                                  initialDuration: _setRestDuration,
                                  step: 5,
                                  title: 'Break');
                            },
                          ),
                        ],
                      ),
                    ),
                    BuildExtrasCard(
                      timerData: _tabataData,
                      vibrate: _tabataData.vibrate,
                      onSwitch: (bool value) {
                        setState(() {
                          _tabataData.vibrate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              BottomButton(
                buttonName: 'SAVE',
                onTap: () async {
                  print("Button Pressed");
                  setState(() {
                    _name.text.isEmpty ? _validateName = true : _validateName = false;
                  });

                  if (_validateName == true) return;

                  if (_exerciseData.listSize == 0) {
                    errorDialog(context, 'Exercise List can\'t be empty.');
                    return;
                  }

                  if (widget.timerData == null) {
                    _tabataData.timerName = _name.text;
                    _tabataData.exerciseCount = _exerciseData.listSize;
                    _tabataData.startDelay = _startCountdownDuration;
                    _tabataData.restSets = _setRestDuration;
                    _tabataData.restIntervals = _intervalRestDuration;
                    _tabataData.exerciseDetailList = _exerciseData.exerciseDetailList;

                    widget.timerCards.timerCardList
                        .add(TimerCardData(timerCardName: _name.text, timerData: _tabataData));

                    await AnalyticsService()
                        .logTimerData(name: 'New_Tabata_Timer_Created', timerData: _tabataData);
                  } else {
                    widget.timerCards.timerCardList[widget.index] =
                        TimerCardData(timerCardName: _name.text, timerData: _tabataData);

                    await AnalyticsService()
                        .logTimerData(name: 'Old_Tabata_Timer_Edited', timerData: _tabataData);
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
