import 'package:flutter/material.dart';
import 'package:interval_timer/components/text_container_box.dart';
import 'package:interval_timer/constants.dart';
import 'package:screen/screen.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final deviceWidth = MediaQuery.of(context).size.width;

    final kHorizontalDivider = Divider(
      thickness: deviceHeight * 0.002,
      color: Color(0xFF707070),
      indent: deviceWidth * 0.1,
      endIndent: deviceWidth * 0.1,
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              TextContainerBox(
                text: 'Timer Name',
                padding: EdgeInsets.all(10.0),
                height: deviceHeight * 0.08,
                width: double.infinity,
              ),
              kHorizontalDivider,
              TextContainerBox(
                text: '12:20',
                height: deviceHeight * 0.2,
                width: deviceWidth * 0.8,
              ),
              kHorizontalDivider,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextContainerBox(
                        text: '2/5',
                        height: deviceHeight * 0.05,
                        margin: EdgeInsets.only(top: deviceHeight * 0.03),
                      ),
                      TextContainerBox(
                        text: 'Exercise No',
                        height: deviceHeight * 0.025,
                        margin: EdgeInsets.only(top: deviceHeight * 0.003),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextContainerBox(
                        text: '1/3',
                        height: deviceHeight * 0.05,
                        margin: EdgeInsets.only(top: deviceHeight * 0.03),
                      ),
                      TextContainerBox(
                        text: 'Sets',
                        height: deviceHeight * 0.025,
                        margin: EdgeInsets.only(top: deviceHeight * 0.003),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: deviceHeight * 0.25,
                width: deviceWidth * 0.8,
                margin: EdgeInsets.all(deviceHeight * 0.05),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextContainerBox(
                  text: 'WORK',
                  height: deviceHeight * .10,
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        radius: deviceHeight * 0.05,
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(
                            Icons.pause,
                            color: Colors.white,
                          ),
                          iconSize: deviceHeight * 0.08,
                          onPressed: () {},
                        ),
                      ),
                      CircleAvatar(
                        radius: deviceHeight * 0.05,
                        backgroundColor: Colors.redAccent,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(
                            Icons.stop,
                            color: Colors.white,
                          ),
                          iconSize: deviceHeight * 0.08,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
