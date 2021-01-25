import 'package:flutter/material.dart';
import 'package:htimer_app/constants.dart';
import 'package:htimer_app/screens/home_screen.dart';
import 'package:htimer_app/screens/sample_timer_screen.dart';
import 'package:htimer_app/widgets/drawer.dart';
import 'package:htimer_app/components/custom_icons.dart';
import 'package:htimer_app/screens/user/user_profile.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;

  var _pageOptions = {
    0: HomeScreen(),
    1: SampleTimerScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 35.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outline,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CustomIcons.htimer_rocket,
              color: Colors.white,
            ),
            label: 'Sample',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: kPrimaryThemeColor,
      ),
    );
  }
}
