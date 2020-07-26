import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;

  const CustomCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Color(0xFF424242),
      elevation: 3,
      child: Container(padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), child: child),
    );
  }
}
