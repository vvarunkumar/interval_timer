import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts;

flutterTtsInitialize() async {
  flutterTts = FlutterTts();
  await flutterTts.setSpeechRate(0.9);
}

Future speakIt(String str) async {
  var spoken = await flutterTts.speak(str);
}

void stopTextToSpeech() async {
  await flutterTts.stop();
}

String speakTime(Duration duration) {
  int minutes = int.parse((duration.inMinutes).toString().padLeft(2, '0'));
  int seconds = int.parse((duration.inSeconds % 60).toString().padLeft(2, '0'));

  if (minutes == 0) {
    if (seconds <= 1) {
      return '$seconds second';
    } else {
      return '$seconds seconds';
    }
  }

  if (seconds == 0) {
    if (minutes == 1) {
      return '$minutes minute';
    } else {
      return '$minutes minutes';
    }
  }

  if (minutes <= 1) {
    if (seconds <= 1) {
      return '$minutes minute $seconds second';
    } else {
      return '$minutes minute $seconds seconds';
    }
  } else {
    if (seconds <= 1) {
      return '$minutes minutes $seconds second';
    } else {
      return '$minutes minutes $seconds seconds';
    }
  }
}
