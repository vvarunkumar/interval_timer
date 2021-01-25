import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/screens/timer_screen.dart';
import 'package:htimer_app/widgets/timerCard_widget.dart';

class TimerStream extends StatelessWidget {
  final CollectionReference collectionReference;
  final bool isBackupScreen;
  TimerStream({this.collectionReference, this.isBackupScreen});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference.orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final sampleTimers = snapshot.data.docs.reversed;
        List<TimerCardWidget> timerCardWidgetList = [];
        for (var sampleTimer in sampleTimers) {
          var data = sampleTimer.data();
          String docID = sampleTimer.id;
          TimerData sampleTimerData = TimerData.fromJson(jsonDecode(data['timerData']));

          timerCardWidgetList.add(TimerCardWidget(
            key: Key(
                '${sampleTimerData.timerName}${sampleTimerData.sets}${sampleTimerData.exerciseCount}'),
            timerData: sampleTimerData,
            onPlay: () {
//                    await AnalyticsService().logTimerData(
//                        name: 'Timer_Played',
//                        timerData: sampleTimerData);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(
                      timerData: sampleTimerData,
                    ),
                    settings: RouteSettings(name: 'Timer Screen'),
                  ));
            },
            isBackupScreen: isBackupScreen,
            documentID: docID,
          ));
        }

        return Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: ListView(
            children: timerCardWidgetList,
          ),
        );
      },
    );
  }
}
