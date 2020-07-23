import 'package:flutter/material.dart';

class TextContainerBox extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding, margin;
  final double height;
  final double width;
  const TextContainerBox({Key key, this.text, this.padding, this.margin, this.height, this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      height: height,
      width: width,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
