import 'package:flutter/material.dart';

class TextContainerBox extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding, margin;
  final double height;
  final double width;
  final Color textColor;
  final Alignment textAlign;
  const TextContainerBox({
    Key key,
    this.text,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.textColor,
    this.textAlign,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      height: height,
      width: width,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: textAlign ?? Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
