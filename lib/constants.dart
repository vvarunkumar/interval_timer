import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:audioplayers/audio_cache.dart';

final kPrimaryThemeColor = Color(0xFF3A63F6);
final kSecondaryThemeColor = Color(0xFF7591F8);

enum WorkoutState {
  initial,
  starting,
  exercising,
  intervalRest,
  setRest,
  finished,
  highIntensity,
  lowIntensity,
  rounds,
  breaks,
}

enum TimerType {
  hiit,
  tabata,
  round,
  custom,
}

String formatTime(Duration duration) {
  String minutes = (duration.inMinutes).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

const kBoldTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const kDurationTextStyle = TextStyle(
  color: Color(0xFFD2D2D2),
  fontWeight: FontWeight.w600,
  fontSize: 16.0,
);

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF7591F8), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF7591F8), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

void kRemoveFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

final List<String> alertList = [
  'Single Beep',
  '10 Second Count',
  'Text-to-Speech with Count',
  'Text-to-Speech without Count',
];

///Audio Player
var audioPlayer = AudioCache();
Future playSound(String sound) {
  return audioPlayer.play(sound);
}

const String kSharedPrefKey = 'HomeScreenTimerData';
