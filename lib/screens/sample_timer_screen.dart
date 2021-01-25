import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htimer_app/services/timer_stream.dart';
import 'package:htimer_app/components/text_container_box.dart';

class SampleTimerScreen extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextContainerBox(
              height: isPortrait ? 50.0 : 35.0,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              text: 'Sample Timers',
            ),
            Expanded(
              child: TimerStream(
                collectionReference: _firestore.collection("sampleTimers"),
                isBackupScreen: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
//  bool isLoaded = false;
//  List<TimerCardData> timerCardList = [];
//
//  void getSampleTimerStreamData() {
//    _firestore.collection("sampleTimers").snapshots().listen((QuerySnapshot querySnapshot) {
//      querySnapshot.docs.forEach((document) {
//        var data = document.data();
//        TimerData sampleTimerData = TimerData.fromJson(jsonDecode(data['timerData']));
//        TimerCardData timerCardData = TimerCardData(
//          timerCardName: sampleTimerData.timerName,
//          timerData: sampleTimerData,
//        );
//        timerCardList.add(timerCardData);
//      });
//      setState(() {
//        isLoaded = true;
//      });
//    });
//  }

 */

/*
    return isLoaded
        ? Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return TimerCardWidget(
                  key: Key(
                      '${timerCardData.timerCardName}${timerCardData.timerData.sets}${timerCardData.timerData.exerciseCount}'),
                  timerData: timerCardData.timerData,
                  onTap: () {
                    print(
                        'Sample Timer Tapped: Expanded Index: $expandIndex  Original Index: $index');
                    setState(() {
                      if (timerCardData.isExpanded) {
                        timerCardData.isExpanded = false;
                      } else {
                        timerCardList[expandIndex].isExpanded = false;
                        expandIndex = index;
                        timerCardData.isExpanded = true;
                      }
                    });
                  },
                  isExpanded: timerCardData.isExpanded,
                  onPlay: () {
//                    await AnalyticsService().logTimerData(
//                        name: 'Timer_Played',
//                        timerData: timerCardData.timerData);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimerScreen(
                            timerData: timerCardData.timerData,
                          ),
                          settings: RouteSettings(name: 'Timer Screen'),
                        ));
                  },
                );
              },
              itemCount: timerCardList.length,
            ),
          )
        : Center(child: CircularProgressIndicator());
 */
