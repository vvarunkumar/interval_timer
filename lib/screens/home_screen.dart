import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:animated_rotation/animated_rotation.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';

import 'package:htimer_app/data/timer_card.dart';
import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/services/analytics_service.dart';
import 'package:htimer_app/screens/input_screens/tabata_input_screen.dart';
import 'package:htimer_app/screens/input_screens/hiit_input_screen.dart';
import 'package:htimer_app/screens/input_screens/round_input_screen.dart';
import 'package:htimer_app/screens/timer_screen.dart';
import 'package:htimer_app/components/confirmation_dialog.dart';
import 'package:htimer_app/screens/input_screens/custom_timer_input_screen.dart';
import 'package:htimer_app/widgets/home_timercard_widget.dart';
import 'package:htimer_app/services/firestore_services.dart';
import 'package:htimer_app/services/dynamic_links.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool isLoaded = false;
  bool inAsyncCall = false;
  int expandIndex = 0;
  int angle = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final timerCards = Provider.of<TimerCards>(context);
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    isLoaded = timerCards.isLoaded;

    return Scaffold(
      floatingActionButton: BoomMenu(
        marginLeft: isPortrait ? 36.0 : 336.0,
        marginRight: isPortrait ? 0.0 : 20.0,
        child: AnimatedRotation(
          angle: angle,
          child: Icon(
            Icons.add,
            size: 35.0,
          ),
          duration: Duration(milliseconds: 500),
        ),
        onOpen: () {
          setState(() {
            angle = 45;
          });
        },
        onClose: () {
          setState(() {
            angle = 0;
          });
        },
        backgroundColor: Color(0xFF6182F7),
        overlayColor: Color(0xFF121212),
        overlayOpacity: 0.7,
        children: [
          MenuItem(
            child: Icon(
              Icons.timer,
              color: Colors.black,
            ),
            title: 'Tabata Timer',
            subtitle: "Circuit & Tabata Timer",
            backgroundColor: Colors.white,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabataInputScreen(
                      timerCards: timerCards,
                    ),
                    settings: RouteSettings(name: 'Tabata Input Screen'),
                  ));
            },
          ),
          MenuItem(
            child: Icon(
              Icons.timer,
              color: Colors.black,
            ),
            title: 'HIIT Timer',
            titleColor: Colors.black,
            subtitle: "High Intensity & Low Intensity Timer",
            backgroundColor: Colors.white,
            subTitleColor: Colors.black,
//            backgroundColor: Color(0xFF1F1B24),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HIITInputScreen(
                      timerCards: timerCards,
                    ),
                    settings: RouteSettings(name: 'HIIT Input Screen'),
                  ));
            },
          ),
          MenuItem(
            child: Icon(
              Icons.timer,
              color: Colors.black,
            ),
            title: 'Round Timer',
            titleColor: Colors.black,
            subtitle: "Set number of Rounds",
            backgroundColor: Colors.white,
            subTitleColor: Colors.black,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoundInputScreen(
                      timerCards: timerCards,
                    ),
                    settings: RouteSettings(name: 'RoundTimer Input Screen'),
                  ));
            },
          ),
          MenuItem(
            child: Icon(
              Icons.timer,
              color: Colors.black,
            ),
            title: 'Custom Timer',
            titleColor: Colors.black,
            subtitle: "User Customised Timer",
            backgroundColor: Colors.white,
            subTitleColor: Colors.black,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomTimerInputScreen(
                      timerCards: timerCards,
                    ),
                    settings: RouteSettings(name: 'Custom Timer Input Screen'),
                  ));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: inAsyncCall,
          child: Column(
            children: <Widget>[
              Hero(
                tag: 'titleHtimer',
                child: TextContainerBox(
                  height: isPortrait ? 50.0 : 35.0,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  text: 'H!TIMER',
                ),
              ),
//              Container(
//                width: deviceWidth,
//                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: deviceWidth * 0.05),
//                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//                decoration: BoxDecoration(
//                  border: Border.all(
//                    color: Color(0xFF88A1F9),
//                  ),
//                  borderRadius: BorderRadius.circular(7.0),
//                ),
//                child: InkWell(
//                  onTap: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => SampleTimerScreen(),
//                          settings: RouteSettings(name: 'Sample Timer Screen'),
//                        ));
//                  },
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Icon(
//                        Icons.folder,
//                        size: 40.0,
//                      ),
//                      TextContainerBox(
//                        height: 30.0,
////                      margin: EdgeInsets.only(left: 10.0),
//                        width: deviceWidth * 0.72,
//                        text: 'Sample Timers',
//                        textAlign: Alignment.centerLeft,
//                      ),
//                    ],
//                  ),
//                ),
//              ),
              Expanded(
                child: isLoaded
                    ? Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return TimerCardWidget(
                              key: Key(
                                  '${timerCards.timerCardList[index].timerCardName}${timerCards.timerCardList[index].timerData.sets}${timerCards.timerCardList[index].timerData.exerciseCount}'),
                              timerData: timerCards.timerCardList[index].timerData,
                              onTap: () {
                                setState(() {
                                  if (timerCards.timerCardList[index].isExpanded) {
                                    timerCards.timerCardList[index].isExpanded = false;
                                  } else {
                                    timerCards.timerCardList[expandIndex].isExpanded = false;
                                    expandIndex = index;
                                    timerCards.timerCardList[index].isExpanded = true;
                                  }
                                });
                              },
                              isExpanded: timerCards.timerCardList[index].isExpanded,
                              onPlay: () async {
                                await AnalyticsService().logTimerData(
                                    name: 'Timer_Played',
                                    timerData: timerCards.timerCardList[index].timerData);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TimerScreen(
                                        timerData: timerCards.timerCardList[index].timerData,
                                      ),
                                      settings: RouteSettings(name: 'Timer Screen'),
                                    ));
                              },
                              onDelete: (direction) => showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmationDialog(
                                      timerData: timerCards.timerCardList[index].timerData,
                                    );
                                  }).then((value) {
                                print("Deleted Called $value");
                                if (value != true) return;

                                timerCards.removeData(index);
                              }),
                              onEdit: () {
                                switch (timerCards.timerCardList[index].timerData.timerType) {
                                  case TimerType.hiit:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HIITInputScreen(
                                            timerCards: timerCards,
                                            timerData: timerCards.timerCardList[index].timerData,
                                            index: index,
                                          ),
                                          settings: RouteSettings(name: 'HIIT Edit Screen'),
                                        ));
                                    break;
                                  case TimerType.tabata:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TabataInputScreen(
                                            timerCards: timerCards,
                                            timerData: timerCards.timerCardList[index].timerData,
                                            index: index,
                                          ),
                                          settings: RouteSettings(name: 'Tabata Edit Screen'),
                                        ));
                                    break;
                                  case TimerType.round:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RoundInputScreen(
                                            timerCards: timerCards,
                                            timerData: timerCards.timerCardList[index].timerData,
                                            index: index,
                                          ),
                                          settings: RouteSettings(name: 'RoundTimer Edit Screen'),
                                        ));
                                    break;
                                  case TimerType.custom:
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CustomTimerInputScreen(
                                            timerCards: timerCards,
                                            timerData: timerCards.timerCardList[index].timerData,
                                            index: index,
                                          ),
                                          settings: RouteSettings(name: 'CustomTimer Edit Screen'),
                                        ));
                                    break;
                                }
                              },
                              onShare: () async {
                                setState(() {
                                  inAsyncCall = true;
                                });
                                FirestoreServices _firebaseShare = FirestoreServices();
                                String docID = await _firebaseShare.saveSharedTimer(
                                  timerData: timerCards.timerCardList[index].timerData,
                                );

                                String dynamicLink =
                                    await DynamicLinkService().generateShareLink(docID);
                                print(dynamicLink);
                                await AnalyticsService().logTimerData(
                                    name: 'Share-Timer-Generated',
                                    timerData: timerCards.timerCardList[index].timerData);
                                setState(() {
                                  inAsyncCall = false;
                                });

                                Share.share(
                                    'Check out the ${timerCards.timerCardList[index].timerData.timerName} timer. Add it to your H!Timer app $dynamicLink',
                                    subject:
                                        'H!Timer - ${timerCards.timerCardList[index].timerData.timerName}');
                              },
                            );
                          },
                          itemCount: timerCards.timerCardList.length,
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
//      appBar: AppBar(
//        actions: <Widget>[
//          FlatButton(
//            child: Text(
//              'Logout',
//              style: TextStyle(color: Colors.white),
//            ),
//            splashColor: Colors.white30,
//            onPressed: () async {
//              FirebaseAuth.instance.signOut();
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => LoginScreen(),
//                    settings: RouteSettings(name: 'Login Screen'),
//                  ));
//            },
//          )
//        ],
//        backgroundColor: Theme.of(context).canvasColor,
//      ),
 */
