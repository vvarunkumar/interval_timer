import 'package:flutter/material.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/model/timer_data.dart';

class AlertDropdown extends StatefulWidget {
  final TimerData timerData;

  const AlertDropdown({Key key, this.timerData}) : super(key: key);

  @override
  _AlertDropdownState createState() => _AlertDropdownState();
}

class _AlertDropdownState extends State<AlertDropdown> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.timerData.alertName = alertList[2];
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      elevation: 15,
      itemBuilder: (context) {
        return alertList.map((item) {
          return PopupMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('${widget.timerData.alertName}'),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      onSelected: (value) {
        setState(() {
          widget.timerData.alertName = value;
        });
        kRemoveFocus(context);
        print(value);
      },
    );
  }
}
