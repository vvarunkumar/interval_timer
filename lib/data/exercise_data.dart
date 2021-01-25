import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:htimer_app/components/description_dialog.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/components/color_picker_dialog.dart';

class ExerciseDetails {
  String name;
  Duration duration;
  bool splitInterval;
  Color color;
  String description;

  ExerciseDetails({this.name, this.duration, this.splitInterval, this.color, this.description});

  Map<String, dynamic> toJson() => {
        'name': name,
        'duration': duration.inSeconds,
        'splitInterval': splitInterval,
        'color': color.value,
        'description': description ?? '-',
      };

  factory ExerciseDetails.fromJson(Map<String, dynamic> json) {
    return new ExerciseDetails(
      name: json['name'],
      duration: Duration(seconds: json['duration']),
      splitInterval: json['splitInterval'],
      color: new Color(json['color']),
      description: json['description'],
    );
  }
}

class ExerciseData {
  List<ExerciseDetails> exerciseDetailList = [];

  void addExerciseData(ExerciseDetails exerciseDetail) {
    exerciseDetailList.add(exerciseDetail);
  }

  void deleteExerciseData(ExerciseDetails exerciseDetail) {
    print(listSize);
    exerciseDetailList.remove(exerciseDetail);
    print(listSize);
  }

  get listSize => exerciseDetailList.length;
}

class TabataExerciseRow extends StatelessWidget {
  final String name;
  final Duration duration;
  final Function onNameTap;
  final Function onDurationPress;
  final Function onDelete;
  final Function onSplitIntervalSwitch;
  final Function onColorTap;
  final Function onAddDescription;
  final Color selectedColor;
  final bool splitInterval;
  final bool isDescription;
  final Key key;

  TabataExerciseRow({
    this.name,
    this.duration,
    this.onDurationPress,
    this.onDelete,
    this.onNameTap,
    this.onColorTap,
    this.splitInterval,
    this.selectedColor,
    this.onSplitIntervalSwitch,
    this.key,
    this.onAddDescription,
    this.isDescription,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Dismissible(
      key: key,
      onDismissed: onDelete,
      background: Container(
        color: Colors.grey[700],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        width: (deviceWidth * 0.9),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          height: 120.0,
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: onNameTap,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 32.0,
                          child: Text(
                            '$name',
                            style: kBoldTextStyle,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Split Interval Left-Right',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            height: 35,
                            child: Switch(
                              value: splitInterval,
                              activeColor: kSecondaryThemeColor,
                              onChanged: onSplitIntervalSwitch,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            formatTime(duration),
                            style: kDurationTextStyle,
                          ),
                        ),
                        onTap: onDurationPress,
                      ),
                      buildColorWidget(onColorTap: onColorTap, color: selectedColor),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Icon(
                      Icons.menu,
                      color: Color(0xFFB3B3B3),
                      size: 28.0,
                    ),
                  ),
                ],
              ),
              FlatButton(
                child: Text(isDescription ? 'Edit Description' : 'Add Description'),
                onPressed: onAddDescription,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseRowWidget extends StatelessWidget {
  final String text;
  final Duration duration;
  final Function onDurationTap;
  final Function onColorTap;
  final Color selectedColor;
  final bool splitInterval;
  final Function onSplitIntervalSwitch;

  const ExerciseRowWidget(
      {Key key,
      this.text,
      this.duration,
      this.onDurationTap,
      this.onColorTap,
      this.selectedColor,
      this.splitInterval,
      this.onSplitIntervalSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      width: deviceWidth * 0.9,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        height: 110.0,
        width: deviceWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 32.0,
                  child: Text(
                    '$text',
                    style: kBoldTextStyle,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Split Interval Left-Right',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: 35,
                      child: Switch(
                        value: splitInterval,
                        onChanged: onSplitIntervalSwitch,
                        activeColor: kSecondaryThemeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      formatTime(duration),
                      style: kDurationTextStyle,
                    ),
                  ),
                  onTap: onDurationTap,
                ),
                buildColorWidget(onColorTap: onColorTap, color: selectedColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
