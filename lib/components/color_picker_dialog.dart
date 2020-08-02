import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ColorPickerDialog extends StatelessWidget {
  final EdgeInsets titlePadding;
  final Color selectedColor;
  final Widget confirmWidget;
  final Widget cancelWidget;

  ColorPickerDialog({
    this.titlePadding,
    this.selectedColor,
    Widget confirmWidget,
    Widget cancelWidget,
  })  : confirmWidget = confirmWidget ?? new Text('OK'),
        cancelWidget = cancelWidget ?? new Text('CANCEL');

  Color pickedColor;

  @override
  Widget build(BuildContext context) {
    pickedColor = selectedColor;
    return AlertDialog(
      title: Text('Pick Color'),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: MaterialColorPicker(
          selectedColor: selectedColor,
          allowShades: false,
          circleSize: 60.0,
          colors: [
            Colors.red,
            Colors.redAccent,
            Colors.pink,
            Colors.pinkAccent,
            Colors.purple,
            Colors.purpleAccent,
            Colors.deepPurple,
            Colors.deepPurpleAccent,
            Colors.indigo,
            Colors.indigoAccent,
            Colors.blue,
            Colors.blueAccent,
            Colors.cyan,
            Colors.cyanAccent,
            Colors.teal,
            Colors.tealAccent,
            Colors.green,
            Colors.greenAccent,
            Colors.lightGreen,
            Colors.lightGreenAccent,
            Colors.yellow,
            Colors.yellowAccent,
            Colors.amber,
            Colors.amberAccent,
            Colors.orange,
            Colors.orangeAccent,
            Colors.deepOrange,
            Colors.deepOrangeAccent,
            Colors.brown,
            Colors.grey,
            Colors.blueGrey,
          ],
          onMainColorChange: (value) {
            pickedColor = value;
          },
        ),
      ),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: cancelWidget,
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop(pickedColor);
          },
          child: confirmWidget,
        ),
      ],
    );
  }
}
