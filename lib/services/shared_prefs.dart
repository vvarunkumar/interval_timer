import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:htimer_app/data/timer_card.dart';
import 'package:htimer_app/constants.dart';

SharedPreferences prefs;

Future<dynamic> getSharedPrefInstance() async {
  prefs = await SharedPreferences.getInstance();
  return prefs;
}

saveHomeData({TimerCards timerCards}) {
  prefs.setString(kSharedPrefKey, jsonEncode(timerCards.toJson()));
}

TimerCards getHomeScreenData() {
  var json = prefs.getString(kSharedPrefKey);
  if (json == null) {
    saveHomeData(timerCards: defaultTimerCard);
    return defaultTimerCard;
  }
  TimerCards timerCards = TimerCards.fromJson(jsonDecode(json));
  return timerCards;
}
