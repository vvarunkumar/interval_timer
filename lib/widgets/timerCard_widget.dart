import 'package:flutter/material.dart';
import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/services/firestore_services.dart';
import 'package:provider/provider.dart';
import 'package:htimer_app/data/timer_card.dart';

class TimerCardWidget extends StatefulWidget {
  final TimerData timerData;
  final Function onPlay;
  final Function onShare;
  final String documentID;
  final bool isBackupScreen;

  const TimerCardWidget({
    Key key,
    this.timerData,
    this.onPlay,
    this.onShare,
    this.documentID,
    this.isBackupScreen,
  }) : super(key: key);

  @override
  _TimerCardWidgetState createState() => _TimerCardWidgetState();
}

class _TimerCardWidgetState extends State<TimerCardWidget> {
  bool isExpanded = false;
  List<String> timerCardPopUpMenuOptions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerCardPopUpMenuOptions = widget.isBackupScreen
        ? [
            'Restore',
            'Share',
            'Delete',
          ]
        : [
            'Save',
            'Share',
          ];
  }

  @override
  Widget build(BuildContext context) {
    TimerCards timerCards = Provider.of<TimerCards>(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
        print("Expanded: $isExpanded");
      },
      onLongPress: widget.onPlay,
      child: Container(
//          height: 75.0,
        width: deviceWidth,
        margin: EdgeInsets.symmetric(
            vertical: 10.0, horizontal: isPortrait ? (deviceWidth * 0.05) : (deviceWidth * 0.15)),
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
                            color: Color(0xFFC4C4C4),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.timer,
                            size: 25.0,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: TextContainerBox(
                            height: 30.0,
                            width: deviceWidth * 0.55,
                            text: widget.timerData.timerName,
                            textAlign: Alignment.centerLeft,
                          ),
                        ),
                        PopupMenuButton<String>(
                          elevation: 15,
                          itemBuilder: (context) {
                            return timerCardPopUpMenuOptions.map((item) {
                              return PopupMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
//                                color: Color(0xFF1D1D1D),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.more_vert,
                              size: 25.0,
                            ),
                          ),
                          onSelected: (value) {
                            if (value == 'Save' || value == 'Restore') {
                              timerCards.addData(TimerCardData(
                                  timerData: widget.timerData,
                                  timerCardName: "${widget.timerData.timerName}s"));
                            } else if (value == 'Delete') {
                              FirestoreServices().deleteBackupTimer(docID: widget.documentID);
                            } else if (value == 'Share') {
                              print("Share Button Clicked");
                              widget.onShare();
                            }
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 38.0 * widget.timerData.exerciseDetailList.length,
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        children: <Widget>[
                          for (int index = 0;
                              index < widget.timerData.exerciseDetailList.length;
                              index++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      '${widget.timerData.exerciseDetailList[index].name}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      '${formatTime(widget.timerData.exerciseDetailList[index].duration)}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
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
                          color: Colors.white,
                          onPressed: widget.onPlay,
                        ),
                      ),
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
                      color: Color(0xFFC4C4C4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.timer,
                      size: 25.0,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextContainerBox(
                      height: 30.0,
                      text: widget.timerData.timerName,
                      textAlign: Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
