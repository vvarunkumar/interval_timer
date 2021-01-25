import 'package:flutter/material.dart';
import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/services/firebase_user.dart';
import 'package:htimer_app/services/firestore_services.dart';

class TimerCardWidget extends StatelessWidget {
  final TimerData timerData;
  final Function onPlay;
  final Function onDelete;
  final Function onEdit;
  final Function onTap;
  final Function onShare;
  final bool isExpanded;

  const TimerCardWidget({
    Key key,
    this.timerData,
    this.onPlay,
    this.onDelete,
    this.onTap,
    this.onEdit,
    this.onShare,
    this.isExpanded,
  }) : super(key: key);

  void onBackup(BuildContext context) async {
    String docID = await FirestoreServices().backupTimer(timerData: timerData);
    bool isSuccessful = docID != null;
    final snackBar = SnackBar(
      content: Text(isSuccessful ? 'Backup created successfully' : 'Backup failed'),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: isSuccessful ? 'Undo' : 'Sign In',
        onPressed: () {
          if (isSuccessful) {
            FirestoreServices().deleteBackupTimer(docID: docID);
          }
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

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
                              text: timerData.timerName,
                              textAlign: Alignment.centerLeft,
                            ),
                          ),
                          PopupMenuButton<String>(
                            elevation: 15,
                            itemBuilder: (context) {
                              return [
                                'Edit',
                                'Backup',
                                'Share',
                              ].map((item) {
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
                              if (value == 'Edit') {
                                print("Edit Button Clicked");
                                onEdit();
                              } else if (value == 'Backup') {
                                if (FirebaseCurrentUser.user != null) onBackup(context);
                              } else if (value == 'Share') {
                                print("Share Button Clicked");
                                onShare();
                              }
                            },
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 38.0 * timerData.exerciseDetailList.length,
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          children: <Widget>[
                            for (int index = 0;
                                index < timerData.exerciseDetailList.length;
                                index++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '${timerData.exerciseDetailList[index].name}',
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
                                        '${formatTime(timerData.exerciseDetailList[index].duration)}',
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
                            onPressed: onPlay,
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
                        text: timerData.timerName,
                        textAlign: Alignment.centerLeft,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
