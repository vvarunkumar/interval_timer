import 'package:flutter/material.dart';
import 'package:htimer_app/components/round_button.dart';
import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/services/check.dart';
import 'package:htimer_app/services/firebase_user.dart';
import 'package:htimer_app/screens/user/backup_timer.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/screens/auth/google_sign_in.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FirebaseCurrentUser.user != null
          ? Container(
              margin: EdgeInsets.only(top: 50),
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage('${FirebaseCurrentUser.user.photoURL}'),
                        ),
                        TextContainerBox(
                          height: 20.0,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                          text: FirebaseCurrentUser.user.displayName,
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
                      ],
                    ),
                  ),
                  RoundedButton(
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
                ],
              ),
            )
          : Container(
              child: GoogleSignInScreen(
                isDrawer: true,
              ),
            ),
    );
  }
}
