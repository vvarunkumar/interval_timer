import 'package:flutter/material.dart';
import 'package:htimer_app/components/text_container_box.dart';
import 'package:htimer_app/screens/navigation_bar.dart';

import 'package:htimer_app/services/firebase_user.dart';
import 'package:htimer_app/screens/home_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class GoogleSignInScreen extends StatefulWidget {
  final bool isDrawer;

  const GoogleSignInScreen({Key key, this.isDrawer}) : super(key: key);

  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool inAsyncCall = false;
  bool _isDrawer = false;

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    setState(() {
      inAsyncCall = true;
    });

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User user = userCredential.user;

    print(user);

    if (user == null) {
      return user;
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    FirebaseCurrentUser.user = user;

    return user;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isDrawer == null)
      _isDrawer = false;
    else
      _isDrawer = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: inAsyncCall,
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'titleHtimer',
                  child: TextContainerBox(
                    height: 50.0,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    text: 'H!TIMER',
                  ),
                ),
                GoogleSignInButton(
                  darkMode: true,
                  onPressed: () async {
                    signInWithGoogle()
                        .then((user) {
                          if (user != null) {
                            FirebaseCurrentUser().updateUserData(user);
                            return true;
                          }
                          return false;
                        })
                        .catchError((onError) => print(onError))
                        .then((value) {
                          if (value)
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationBar(),
                                ));

                          setState(() {
                            inAsyncCall = false;
                          });
                        });
                  },
                ),
                _isDrawer
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationBar(),
                                ));
                          },
                          child: Text('Skip'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
