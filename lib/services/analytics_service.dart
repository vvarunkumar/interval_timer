import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:htimer_app/model/timer_data.dart';

final FirebaseAnalytics _analytics = FirebaseAnalytics();

class AnalyticsService {
  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  Future<void> logTimerData({String name, TimerData timerData}) async {
    Map<String, dynamic> parameters = {
      'timerName': timerData.timerName,
      'timerType': timerData.timerType.toString(),
      'sets': timerData.sets,
      'exerciseCount': timerData.exerciseCount,
      'startDelay': timerData.startDelay.inSeconds,
      'restIntervals': timerData.restIntervals.inSeconds,
      'restSets': timerData.restSets.inSeconds,
      'colorSetRest': timerData.colorSetRest.value,
      'colorInterval': timerData.colorInterval.value,
      'colorCountDown': timerData.colorCountDown.value,
      'randomise': timerData.randomise,
      'tabataStyle': timerData.tabataStyle,
      'vibrate': timerData.vibrate,
      'alertName': timerData.alertName,
    };

    for (int i = 1; i < timerData.exerciseDetailList.length; i++) {
      var exercise = timerData.exerciseDetailList[i];
      parameters["Exercise_$i"] = exercise.toJson().toString();
    }

    name = name.trim();

    await _analytics.logEvent(
        name: name.replaceAll(new RegExp(r'[!@#<>?".:_`~;[\]\\|=+)(*&^%\s-]'), "_"),
        parameters: parameters);
  }

  Future<void> logCustomData({String eventName}) async {
    await _analytics.logEvent(
        name: eventName.replaceAll(new RegExp(r'[!@#<>?".:_`~;[\]\\|=+)(*&^%\s-]'), "_"));
  }
}
