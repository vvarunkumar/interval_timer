import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:htimer_app/services/firestore_services.dart';
import 'package:htimer_app/services/analytics_service.dart';
import 'package:htimer_app/model/timer_data.dart';
import 'package:htimer_app/data/timer_card.dart';

class DynamicLinkService {
  TimerCards _timerCards;

  Future handleDynamicLinks(TimerCards timerCards) async {
    _timerCards = timerCards;

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        _handleDeepLink(dynamicLink);
      },
      onError: (OnLinkErrorException e) async {
        print('Link Failed: ${e.message}');
      },
    );
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    String timerDocID;
    if (deepLink != null) {
      print('Deeplink Query ${deepLink.queryParameters['share']}');
      timerDocID = deepLink.queryParameters['share'].toString();
      if (timerDocID.length == 20) addSharedData(timerDocID);
    }
  }

  void addSharedData(String timerDocID) async {
    print('Add share data method called');
    FirestoreServices _firebaseShare = FirestoreServices();

    TimerData timerData = await _firebaseShare.getTimerDataFirebase(timerDocID);

    _timerCards
        .addData(TimerCardData(timerCardName: "${timerData.timerName}1", timerData: timerData));

    await AnalyticsService().logTimerData(name: 'Shared-Timer-Added', timerData: timerData);

    print('timerData added $timerDocID');
  }

  Future<String> generateShareLink(String timerDocId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://wellmo.page.link/',
      link: Uri.parse('https://www.wellmo.in/htimer?share=$timerDocId'),
      androidParameters: AndroidParameters(
        packageName: 'com.regalcoder.workout_timer',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'share-timer',
        medium: 'social',
        source: 'documentID',
      ),
    );

//    final Uri dynamicUrl = await parameters.buildUrl();
//    return dynamicUrl.toString();

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }
}
