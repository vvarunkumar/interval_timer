import 'package:flutter/material.dart';
import 'package:interval_timer/components/reusable_card.dart';
import 'package:interval_timer/screens/input_screen/row_data.dart';
import 'package:interval_timer/constants.dart';
import 'package:interval_timer/screens/timer_screen.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _name = TextEditingController();
  final _noOfSets = TextEditingController();

  Duration _exTime1;
  Duration _exTime2;
  Duration _exTime3;

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
                        ),
                      ],
                    ),
                  ),
                  CustomCard(
                    child: Column(
                      children: <Widget>[
                        ExerciseRowData(
                          name: 'Exercise 1',
                          duration: Duration(seconds: 0),
                          onPress: () {},
                        ),
                        ExerciseRowData(
                          name: 'Exercise 2',
                          duration: Duration(seconds: 0),
                          onPress: () {},
                        ),
                        ExerciseRowData(
                          name: 'Exercise 3',
                          duration: Duration(seconds: 0),
                          onPress: () {},
                        ),
                        Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: Color(0xFFB3B3B3),
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomCard(
                    child: Column(
                      children: <Widget>[
                        RowData(
                          text: 'Rest Between Intervals',
                        ),
                        RowData(
                          text: 'Rest Between Sets',
                        ),
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
                            Text('Audio'),
                            Text('No Audio Selected'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Alerts'),
                            Text('Text to Speech'),
                          ],
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TimerScreen()));
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
