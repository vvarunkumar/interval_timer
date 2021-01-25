import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:htimer_app/services/timer_stream.dart';
import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/services/firebase_user.dart';

class BackupTimerScreen extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextContainerBox(
              height: 50.0,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              text: 'Backup Timers',
            ),
            Expanded(
              child: TimerStream(
                collectionReference: _firestore
                    .collection("users")
                    .doc(FirebaseCurrentUser.user.uid)
                    .collection("backupTimer"),
                isBackupScreen: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
