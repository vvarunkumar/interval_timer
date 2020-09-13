import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_timer/components/text_container_box.dart';
import 'package:workout_timer/model/default_timer_data.dart';
import 'package:workout_timer/model/timer_data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:workout_timer/constants.dart';
import 'package:workout_timer/services/firebase_share.dart';

class TimerCardWidget extends StatelessWidget {
  final TimerData timerData;
  final Function onPlay;
  final Function onDelete;
  final Function onEdit;
  final Function onTap;
  final bool isExpanded;

  const TimerCardWidget({
    Key key,
    this.timerData,
    this.onPlay,
    this.onDelete,
    this.onTap,
    this.onEdit,
    this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Dismissible(
      confirmDismiss: onDelete,
      key: key,
      background: Container(
        color: Colors.grey[700],
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onPlay,
        child: Container(
//          height: 75.0,
          width: deviceWidth,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: deviceWidth * 0.05),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF88A1F9),
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: isExpanded
              ? Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF1D1D1D),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.timer,
                              size: 25.0,
                            ),
                          ),
                          TextContainerBox(
                            height: 30.0,
                            width: deviceWidth * 0.55,
                            text: timerData.timerName,
                            textAlign: Alignment.centerLeft,
                          ),
                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF1D1D1D),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 25.0,
                              ),
                            ),
                            onTap: onEdit,
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 38.0 * timerData.exerciseDetailList.length,
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AutoSizeText(
                                    '${timerData.exerciseDetailList[index].name}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  AutoSizeText(
                                    '${formatTime(timerData.exerciseDetailList[index].duration)}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: timerData.exerciseDetailList.length,
                        ),
                      ),
                      Center(
                        child: Container(
//                          padding: const EdgeInsets.all(8.0),
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: kSecondaryThemeColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.play_arrow),
                            iconSize: 35.0,
                            onPressed: onPlay,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () async {
                          FirebaseShare _share = FirebaseShare();
                          String docID = await _share.saveTimerFirebase(timerData);
                          print("Received Doc ID $docID");
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Share'),
                                  content: Container(
                                    height: 100.0,
                                    child: Column(
                                      children: <Widget>[
                                        Text('$docID'),
                                        IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: docID));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1D1D1D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.timer,
                        size: 25.0,
                      ),
                    ),
                    TextContainerBox(
                      height: 30.0,
//                      margin: EdgeInsets.only(left: 10.0),
                      width: deviceWidth * 0.72,
                      text: timerData.timerName,
                      textAlign: Alignment.centerLeft,
                    ),
//                    InkWell(
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Icon(
//                          Icons.edit,
//                        ),
//                      ),
//                      onTap: onEdit,
//                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
