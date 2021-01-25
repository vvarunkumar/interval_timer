import 'package:flutter/material.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/components/color_picker_dialog.dart';

class RowTextDuration extends StatelessWidget {
  final String text;
  final Duration duration;
  final Function onTap;
  final Function onColorTap;
  final Color selectedColor;

  const RowTextDuration(
      {Key key, this.text, this.duration, this.onTap, this.onColorTap, this.selectedColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
      title: Text(
        text ?? '',
        style: kBoldTextStyle,
      ),
      subtitle: InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            formatTime(duration),
            style: kDurationTextStyle,
          ),
        ),
        onTap: onTap,
      ),
      trailing: buildColorWidget(
        onColorTap: onColorTap,
        color: selectedColor,
      ),
    );
  }
}
