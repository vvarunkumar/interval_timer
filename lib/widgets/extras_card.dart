import 'package:flutter/material.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/components/reusable_card.dart';
import 'package:workout_timer/model/timer_data.dart';
import 'file:///D:/Code/AndroidStudioProjects/Github/workout_timer/lib/components/alert_dropdown.dart';

class BuildExtrasCard extends StatelessWidget {
  final TimerData timerData;
  final Function onSwitch;
  final bool vibrate;

  const BuildExtrasCard({Key key, this.timerData, this.vibrate, this.onSwitch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
//          Container(
//            margin: EdgeInsets.symmetric(vertical: 8.0),
//            padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Text(
//                  'Audio',
//                  style: kBoldTextStyle,
//                ),
//                Text('No Audio Selected'),
//              ],
//            ),
//          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Alert',
                  style: kBoldTextStyle,
                ),
                AlertDropdown(
                  timerData: timerData,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Vibrate on Alert',
                style: kBoldTextStyle,
              ),
              Switch(
                value: vibrate,
                activeColor: kSecondaryThemeColor,
                onChanged: onSwitch,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
