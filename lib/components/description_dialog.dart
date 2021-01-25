import 'package:flutter/material.dart';
import 'package:htimer_app/model/timer_data.dart';

class AddDescriptionDialog extends StatelessWidget {
  final _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return AlertDialog(
      scrollable: true,
      title: Text("Exercise Description"),
      content: Container(
        height: height * 0.2,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: TextFormField(
            controller: _description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
      ),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('CANCEL'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop(_description.text);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

class ShowDescriptionDialog extends StatelessWidget {
  final String description;

  const ShowDescriptionDialog({Key key, this.description}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Description"),
      content: Text(
        description ?? '',
        style: TextStyle(color: Colors.black54),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
