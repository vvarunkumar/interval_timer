import 'package:flutter/material.dart';
import 'package:workout_timer/components/reusable_card.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/model/timer_data.dart';

class buildNameSetCard extends StatefulWidget {
  final TextEditingController name;
  final bool validateName;
  final TimerData timerData;

  const buildNameSetCard({Key key, this.name, this.validateName, this.timerData}) : super(key: key);

  @override
  _buildNameSetCardState createState() => _buildNameSetCardState();
}

class _buildNameSetCardState extends State<buildNameSetCard> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final deviceWidth = MediaQuery.of(context).size.width;
    widget.timerData.sets ??= 1;
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: widget.name,
            decoration: InputDecoration(
              hintText: 'Enter Timer Name',
              errorText: widget.validateName ? 'Name can\'t be empty' : null,
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Number of Sets',
                style: kBoldTextStyle,
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  child: Text(
                    '${widget.timerData.sets}',
                    style: kDurationTextStyle,
                  ),
                ),
                onTap: () {
                  showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return NumberPickerDialog.integer(
                        minValue: 1,
                        maxValue: 50,
                        initialIntegerValue: widget.timerData.sets,
                        title: Text('Sets in the workout'),
                      );
                    },
                  ).then((sets) {
                    if (sets == null) return;
                    setState(() {
                      widget.timerData.sets = sets;
                    });
                  });
                  kRemoveFocus(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
