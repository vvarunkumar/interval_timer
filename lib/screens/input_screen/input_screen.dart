import 'package:flutter/material.dart';
import 'package:interval_timer/components/reusable_card.dart';
import 'package:interval_timer/screens/input_screen/row_data.dart';
import 'package:interval_timer/constants.dart';
import 'package:interval_timer/screens/timer_screen.dart';

enum currentRow { setRest, intervalRest, startCountdown, exerciseTime }

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _name = TextEditingController();
  final _noOfSets = TextEditingController();

  TimerData _timerData;
  ExerciseData _exerciseData = ExerciseData();

  bool _validateName = false;
  bool _validateSets = false;

  Duration _intervalRestDuration = Duration(seconds: 0);
  Duration _setRestDuration = Duration(seconds: 0);
  Duration _startCountdownDuration = Duration(seconds: 3);

  void durationPickerDialogue(
      {BuildContext context,
      currentRow rowName,
      int index,
      Duration initialDuration}) {
    showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return DurationPickerDialog(
          initialDuration: initialDuration,
          title: Text('Rest Duration'),
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
          _exerciseData.exerciseDataList[index].duration = delay;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timerData = defaultTimerData;
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: deviceHeight * 0.92,
              child: ListView(
                children: <Widget>[
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Name',
                          style: TextStyle(
                            color: Color(0xFFA6A6A6),
                            fontSize: deviceHeight * 0.02,
                          ),
                        ),
                        TextField(
                          controller: _name,
                          decoration: InputDecoration(
                            errorText:
                                _validateName ? 'Name can\'t be empty' : null,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Sets',
                          style: TextStyle(
                            color: Color(0xFFA6A6A6),
                            fontSize: deviceHeight * 0.02,
                          ),
                        ),
                        TextField(
                          controller: _noOfSets,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText: _validateSets
                                ? 'No of Sets can\'t be empty'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Exercises',
                          style: TextStyle(
                            color: Color(0xFFA6A6A6),
                            fontSize: deviceHeight * 0.02,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ExerciseRowData(
                              name: _exerciseData.exerciseDataList[index].name,
                              duration: _exerciseData
                                  .exerciseDataList[index].duration,
                              onPress: () {
                                setState(() {
                                  durationPickerDialogue(
                                      context: context,
                                      index: index,
                                      initialDuration: _exerciseData
                                          .exerciseDataList[index].duration);
                                });
                              },
                              onDelete: () {
                                setState(() {
                                  _exerciseData.deleteExerciseData(
                                      _exerciseData.exerciseDataList[index]);
                                });
                              },
                            );
                          },
                          itemCount: _exerciseData.exerciseDataList.length,
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
                                  name: 'Exercise ${_exerciseData.listSize}',
                                  duration: Duration(seconds: 0),
                                ));
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomCard(
                    child: Column(
                      children: <Widget>[
                        RowData(
                          text: 'Starting Countdown',
                          duration: _startCountdownDuration,
                          onPress: () {
                            durationPickerDialogue(
                              context: context,
                              rowName: currentRow.startCountdown,
                              initialDuration: _startCountdownDuration,
                            );
                          },
                        ),
                        RowData(
                          text: 'Rest Between Intervals',
                          duration: _intervalRestDuration,
                          onPress: () {
                            durationPickerDialogue(
                              context: context,
                              rowName: currentRow.intervalRest,
                              initialDuration: _intervalRestDuration,
                            );
                          },
                        ),
                        RowData(
                          text: 'Rest Between Sets',
                          duration: _setRestDuration,
                          onPress: () {
                            durationPickerDialogue(
                                context: context,
                                rowName: currentRow.setRest,
                                initialDuration: _setRestDuration);
                          },
                        ),
                      ],
                    ),
                  ),
                  CustomCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Audio'),
                              Text('No Audio Selected'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Alerts'),
                              Text('Text to Speech'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Vibrate on Alert',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Switch(
                              value: true,
                              onChanged: (bool value) {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: deviceHeight * 0.08,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  print("Button Pressed");
                  setState(() {
                    _name.text.isEmpty
                        ? _validateName = true
                        : _validateName = false;
                    _noOfSets.text.isEmpty
                        ? _validateSets = true
                        : _validateSets = false;
                  });

                  if (_validateName == true || _validateSets == true) return;

                  _timerData.sets = int.parse(_noOfSets.text);
                  _timerData.exerciseCount = _exerciseData.listSize;
                  _timerData.startDelay = _startCountdownDuration;
                  _timerData.restSets = _setRestDuration;
                  _timerData.restIntervals = _intervalRestDuration;

                  List<Duration> _exerciseList = [];

                  for (var value in _exerciseData.exerciseDataList) {
                    _exerciseList.add(value.duration);
                    print(value.duration);
                  }

                  _timerData.exerciseList = _exerciseList;

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimerScreen(
                                timerData: _timerData,
                              )));
                },
                child: Container(
                  child: Center(
                    child: Text(
                      'SAVE',
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
    );
  }
}
