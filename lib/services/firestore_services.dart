import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/services/firebase_user.dart';

class FirestoreServices {
  final _firestore = FirebaseFirestore.instance;

  Future<String> saveSharedTimer({@required TimerData timerData}) {
    String docID;
    return _firestore.collection("shareData").add({
      "json": jsonEncode(timerData.toJson()),
      "time": Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
    }).then((value) {
      docID = value.id;
      print(docID);
      return docID;
    }).catchError((error) => print("Failed to add: $error"));
  }

  Future<String> backupTimer({@required TimerData timerData}) {
    String docID;
    String uid = FirebaseCurrentUser.user.uid;
    if (uid == null) return null;

    return _firestore.collection("users").doc(uid).collection("backupTimer").add({
      "timerData": jsonEncode(timerData.toJson()),
      "time": Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
    }).then((value) {
      docID = value.id;
      print(docID);
      return docID;
    }).catchError((error) => print("Failed to add: $error"));
  }

  Future<void> deleteBackupTimer({@required String docID}) {
    String uid = FirebaseCurrentUser.user.uid;
    print("Delete BackupTimer Doc:$docID UID:$uid");
    if (uid == null) return null;
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("backupTimer")
        .doc(docID)
        .delete()
        .catchError((error) => print("Failed to delete: $error"));
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
