import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_timer/model/timer_data.dart';

class FirebaseShare {
  final _firestore = FirebaseFirestore.instance;

  Future<String> saveTimerFirebase(TimerData timerData) {
    String docID;
    Map<String, dynamic> map = timerData.toJson();
    print(map);
    return _firestore.collection("shareData").add({
      "json": jsonEncode(timerData.toJson()),
    }).then((value) {
      docID = value.id;
      print(docID);
      return docID;
    }).catchError((error) => print("Failed to add: $error"));
    ;
  }

  Future<TimerData> getTimerDataFirebase(String docId) {
    return _firestore.collection("shareData").doc(docId).get().then((value) {
      var data = value.data();
      String jsonTimerData = data['json'];
      TimerData timerData = TimerData.fromJson(jsonDecode(jsonTimerData));
      return timerData;
    });
  }
}
//"timerData": timerData.toJson()
