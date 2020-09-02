import 'package:flutter/material.dart';
import 'package:workout_timer/components/text_container_box.dart';

class BottomButton extends StatelessWidget {
  final Function onTap;
  final String buttonName;

  const BottomButton({Key key, this.onTap, this.buttonName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final containerHeight = (deviceHeight * 0.075) < 60.0 ? 60.0 : deviceHeight * 0.075;
    return Container(
      height: containerHeight,
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: Center(
            child: TextContainerBox(
              text: 'SAVE',
              height: containerHeight * 0.5,
            ),
          ),
          color: Color(0xFF4D72F6),
          margin: EdgeInsets.only(top: 10.0),
        ),
      ),
    );
  }
}
