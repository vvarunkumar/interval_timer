import 'package:flutter/material.dart';
import 'package:htimer_app/components/round_button.dart';
import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/services/check.dart';
import 'package:htimer_app/services/firebase_user.dart';
import 'package:htimer_app/screens/user/backup_timer.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                    'https://lh5.googleusercontent.com/-pMWNsuSPrGw/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucmKAFR07CCZxc3tU1eMWd8TpsUKHw/s96-c/photo.jpg'),
              ),
              TextContainerBox(
                height: 20.0,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                text: 'Sample Name',
              ),
              RoundedButton(
                text: 'My Backup Timers',
                buttonColor: kSecondaryThemeColor,
                onPress: () {
                  if (FirebaseCurrentUser.user == null) return;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BackupTimerScreen(),
                      ));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RoundedButton(
                    onPress: null,
                    text: 'Backup',
                    textStyle: TextStyle(color: Colors.black),
                    height: 30.0,
                    width: 100.0,
                    buttonColor: Colors.white,
                  ),
                  RoundedButton(
                    onPress: null,
                    text: 'Restore',
                    textStyle: TextStyle(color: Colors.black),
                    height: 30.0,
                    width: 100.0,
                    buttonColor: Colors.white,
                  ),
                ],
              ),
              FirebaseCurrentUser.user != null
                  ? RoundedButton(
                      text: 'Logout',
                      height: 30.0,
                      width: 100.0,
                      buttonColor: Colors.redAccent,
                      onPress: () async {
                        if (FirebaseCurrentUser.user != null)
                          FirebaseCurrentUser().signOut().then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Check(),
                                ));
                          });
                        else
                          print('User not signed in');
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
