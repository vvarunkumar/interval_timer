import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final height;
  final EdgeInsets margin;

  const CustomCard({Key key, this.child, this.height, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Card(
      margin: isPortrait
          ? EdgeInsets.all(8.0)
          : EdgeInsets.symmetric(vertical: 8.0, horizontal: deviceWidth * 0.15),
      color: Colors.white,
      elevation: 3,
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        child: child,
      ),
    );
  }
}
