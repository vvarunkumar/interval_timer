import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:htimer_app/services/check.dart';
import 'package:provider/provider.dart';
import 'package:htimer_app/services/analytics_service.dart';
import 'package:htimer_app/data/timer_card.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AnalyticsService().logAppOpen();
  Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TimerCards.initialize(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xFF3A63F6),
          accentColor: Color(0xFF7591F8),
        ),
        home: Check(),
        navigatorObservers: [AnalyticsService().getAnalyticsObserver()],
      ),
    );
  }
}
