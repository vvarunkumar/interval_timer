import 'package:flutter/cupertino.dart';
import 'package:htimer_app/model/default_timer_data.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/services/shared_prefs.dart';
import 'package:htimer_app/services/dynamic_links.dart';
import 'package:htimer_app/services/analytics_service.dart';

final DynamicLinkService _dynamicLinkService = DynamicLinkService();

class TimerCards with ChangeNotifier {
  List<TimerCardData> timerCardList;
  bool isLoaded = false;

  TimerCards({this.timerCardList});

  TimerCards.initialize() {
    initialize();
    print("Timer Card Initialized");
  }

  void initialize() async {
    getSharedPrefInstance().then((value) {
      this.timerCardList = getHomeScreenData().timerCardList;
      isLoaded = true;
    });
    await _dynamicLinkService.handleDynamicLinks(this);
    notifyListeners();
  }

  void addData(TimerCardData timerCardData) {
    timerCardList.add(timerCardData);
    saveHomeData(timerCards: this);
    notifyListeners();
  }

  void removeData(int index) async {
    await AnalyticsService()
        .logTimerData(name: 'Deleted_Timer', timerData: timerCardList[index].timerData);
    timerCardList.removeAt(index);
    saveHomeData(timerCards: this);
    notifyListeners();
  }

  void replaceData({TimerCardData timerCardData, int index}) {
    timerCardList[index] = timerCardData;
    saveHomeData(timerCards: this);
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
        'timerCardList': timerCardList,
      };

  factory TimerCards.fromJson(Map<String, dynamic> json) {
    var timerListFromJson = json['timerCardList'];
    List<dynamic> exerciseList = new List<dynamic>.from(timerListFromJson);
    List<TimerCardData> temp = [];
    for (var timerDataItem in exerciseList) {
      temp.add(TimerCardData.fromJson(timerDataItem));
    }
    return TimerCards(timerCardList: temp);
  }
}

class TimerCardData {
  String timerCardName;
  TimerData timerData;
  bool isExpanded = false;

  TimerCardData({this.timerCardName, this.timerData});

  Map<String, dynamic> toJson() => {
        'timerCardName': timerCardName,
        'timerData': timerData,
      };

  factory TimerCardData.fromJson(Map<String, dynamic> json) {
    return new TimerCardData(
      timerCardName: json['timerCardName'],
      timerData: TimerData.fromJson(json['timerData']),
    );
  }
}

get defaultTimerCard => TimerCards(timerCardList: [
//      TimerCardData(
//        timerCardName: 'Jump Rope Calisthenics',
//        timerData: day1,
//      ),
//      TimerCardData(
//        timerCardName: 'Jump Rope & Upper Body',
//        timerData: day2,
//      ),
//      TimerCardData(
//        timerCardName: 'Jump Rope & Core Body',
//        timerData: day3,
//      ),
//      TimerCardData(
//        timerCardName: 'Jump Rope & Lower Body',
//        timerData: day4,
//      ),
//      TimerCardData(
//        timerCardName: 'Jump Rope Tabata',
//        timerData: day5,
//      ),
    ]);
