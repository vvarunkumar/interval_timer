import 'package:flutter/material.dart';
import 'package:workout_timer/model/timer_data.dart';

class ConfirmationDialog extends StatelessWidget {
  final String name;
  final TimerData timerData;

  const ConfirmationDialog({Key key, this.name, this.timerData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete"),
      content: Text(
        'Do you want to delete "$name"?',
        style: TextStyle(color: Colors.grey),
      ),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('CANCEL'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
