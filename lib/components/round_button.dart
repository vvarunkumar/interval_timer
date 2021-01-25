import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {this.buttonColor, this.text, this.textStyle, this.onPress, this.width, this.height});
  final String text;
  final TextStyle textStyle;
  final Color buttonColor;
  final Function onPress;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: width ?? 200.0,
          height: height ?? 42.0,
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
