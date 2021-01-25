import 'package:flutter/material.dart';
import 'package:htimer_app/components/description_dialog.dart';
import 'package:htimer_app/components/reusable_card.dart';
import 'package:htimer_app/components/row_text_duration.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/data/timer_card.dart';
import 'package:htimer_app/data/exercise_data.dart';
import 'package:htimer_app/components/duration_picker.dart';
import 'package:htimer_app/components/textEditing_dialog.dart';
import 'package:htimer_app/widgets/name_set_card.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/components/custom_reorderable_list_view.dart';
import 'package:htimer_app/components/color_picker_dialog.dart';
import 'package:htimer_app/widgets/extras_card.dart';
import 'package:htimer_app/widgets/bottom_button.dart';
import 'package:htimer_app/services/shared_prefs.dart';
import 'package:htimer_app/components/error_dialog.dart';
import 'package:htimer_app/services/analytics_service.dart';

class CustomTimerInputScreen extends StatefulWidget {
  final TimerCards timerCards;
  final TimerData timerData;
  final int index;

  const CustomTimerInputScreen({Key key, this.timerCards, this.timerData, this.index})
      : super(key: key);

  @override
  _CustomTimerInputScreenState createState() => _CustomTimerInputScreenState();
}

class _CustomTimerInputScreenState extends State<CustomTimerInputScreen> {
  final _name = TextEditingController();

  TimerData _customTimerData = TimerData();
  ExerciseData _exerciseData = ExerciseData();

  bool _validateName = false;
  Duration _startCountdownDuration = Duration(seconds: 10);

  void durationPickerDialogue({
    BuildContext context,
    bool startDelayDuration,
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
        if (startDelayDuration)
          _startCountdownDuration = delay;
        else
          _exerciseData.exerciseDetailList[index].duration = delay;
      });
    });
    kRemoveFocus(context);
  }

  void initializeDefault() {
    _customTimerData = defaultTimerData;
    _customTimerData.timerType = TimerType.custom;
  }

  void initializeEditData() {
    _customTimerData = widget.timerData;
    _name.text = widget.timerData.timerName;
    _startCountdownDuration = widget.timerData.startDelay;
    _exerciseData.exerciseDetailList = widget.timerData.exerciseDetailList;
  }

  @override
  void initState() {
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
      appBar: AppBar(
        backgroundColor: kPrimaryThemeColor,
        title: Text('Custom Timer'),
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
                    ///Name-Set Card
                    buildNameSetCard(
                      name: _name,
                      validateName: _validateName,
                      timerData: _customTimerData,
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
                            height: 140.0 * _exerciseData.listSize,
                            constraints: BoxConstraints(
                              maxHeight: 400.0,
                            ),
                            child: MyReorderableListView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
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
                                        onAddDescription: () {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddDescriptionDialog();
                                              }).then((value) {
                                            if (value == null) return;
                                            _exerciseData.exerciseDetailList[index].description =
                                                value;
                                            print(_exerciseData
                                                .exerciseDetailList[index].description);
                                          });
                                        },
                                        isDescription:
                                            _exerciseData.exerciseDetailList[index].description ==
                                                    null
                                                ? false
                                                : true,
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
                                                startDelayDuration: false,
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
                                    color: randomColorSelector(),
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
                        children: <Widget>[
                          RowTextDuration(
                            text: 'Starting Countdown',
                            duration: _startCountdownDuration,
                            selectedColor: _customTimerData.colorCountDown,
                            onColorTap: () {
                              showDialog<Color>(
                                  context: context,
                                  builder: (context) {
                                    return ColorPickerDialog(
                                        selectedColor: _customTimerData.colorCountDown);
                                  }).then((value) {
                                if (value == null) return;
                                setState(() {
                                  _customTimerData.colorCountDown = value;
                                });
                              });
                            },
                            onTap: () {
                              durationPickerDialogue(
                                context: context,
                                startDelayDuration: true,
                                initialDuration: _startCountdownDuration,
                                title: 'Countdown',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    BuildExtrasCard(
                      timerData: _customTimerData,
                      vibrate: _customTimerData.vibrate,
                      onSwitch: (bool value) {
                        setState(() {
                          _customTimerData.vibrate = value;
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
                  _customTimerData.timerName = _name.text.trim();
                  _customTimerData.exerciseCount = _exerciseData.listSize;
                  _customTimerData.startDelay = _startCountdownDuration;
                  _customTimerData.exerciseDetailList = _exerciseData.exerciseDetailList;

                  if (widget.timerData == null) {
                    widget.timerCards.addData(
                        TimerCardData(timerCardName: _name.text, timerData: _customTimerData));

                    await AnalyticsService().logTimerData(
                        name: 'New_Custom_Timer_Created', timerData: _customTimerData);
                  } else {
                    widget.timerCards.replaceData(
                        timerCardData: TimerCardData(
                            timerCardName: _customTimerData.timerName, timerData: _customTimerData),
                        index: widget.index);

                    await AnalyticsService()
                        .logTimerData(name: 'Old_Custom_Timer_Edited', timerData: _customTimerData);
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
