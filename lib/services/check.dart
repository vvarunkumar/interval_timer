import 'package:flutter/material.dart';
import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/screens/auth/google_sign_in.dart';
import 'package:htimer_app/screens/navigation_bar.dart';
import 'package:htimer_app/services/firebase_user.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  void check() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (FirebaseCurrentUser().currentUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleSignInScreen(),
              settings: RouteSettings(name: 'Sign In Screen'),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBar(),
            ));
      }
    });
  }

  @override
  initState() {
    super.initState();
    check();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Hero(
            tag: 'titleHtimer',
            child: Text(
              'H!TIMER',
              style: TextStyle(color: Colors.black, fontSize: 60.0),
            ),
          ),
        ),
      ),
    );
  }
}

/*
TextContainerBox(
              height: 80.0,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              text: 'H!TIMER',
            )
 */
