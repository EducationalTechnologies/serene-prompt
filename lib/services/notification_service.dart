import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  FlutterLocalNotificationsPlugin localNotifications;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static const String CHANNEL_ID_ASSESSMENT = "serene assessment";
  static const String CHANNEL_NAME_ASSESSMENT = "Assessment Erinnerung";
  static const String CHANNEL_DESCRIPTION_ASSESSMENT = "Erinnerung Fragebogen";

  static const String CHANNEL_ID_DEADLINE = "serene deadline";
  static const String CHANNEL_NAME_DEADLINE = "Deadline Erinnerung";

  static const String PAYLOAD_DAILY_LEARN = "DAILY_LEARNING";

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NotificationService._internal() {
    localNotifications = FlutterLocalNotificationsPlugin();

    configureFirebaseMessaging();
  }

  Future initialize() async {
    var initSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
    var initSettings = InitializationSettings(initSettingsAndroid, null);
    return await localNotifications.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  configureFirebaseMessaging() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("RECEIVED onMessage: $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("RECEIVED onLaunch: $message");
    }, onResume: (Map<String, dynamic> message) async {
      print("RECEIVED onResume: $message");
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  _saveDeviceToken() async {
    String uid = "db";

    String fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      // var tokens =
      FirebaseService().saveFcmToken(uid, fcmToken);
    }
  }

  showReminderNotification() {}

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);

      if (payload == PAYLOAD_DAILY_LEARN) {
        await navigatorKey.currentState.pushNamed(
            RouteNames.DAILY_LEARNING_QUESTIONS,
            arguments: AssessmentScreenArguments(AssessmentType.preLearning));
        await navigatorKey.currentState.pushNamed(RouteNames.GOAL_SHIELDING);
      }
    }
  }

  showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        CHANNEL_ID_ASSESSMENT,
        CHANNEL_NAME_ASSESSMENT,
        'Erinnerung an den Fragebogen',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await localNotifications.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  scheduleNotifications() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(minutes: 1));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_ASSESSMENT,
        CHANNEL_NAME_ASSESSMENT,
        'Erinnerung an den Fragebogen');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await localNotifications.schedule(11, 'scheduled title', 'scheduled body',
        scheduledNotificationDateTime, platformChannelSpecifics,
        androidAllowWhileIdle: true, payload: PAYLOAD_DAILY_LEARN);
  }

  scheduleDailyNotification() async {
    var time = new Time(13, 49, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_ASSESSMENT,
        CHANNEL_NAME_ASSESSMENT,
        'Erinnerung an den Fragebogen');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await localNotifications.showDailyAtTime(12, 'Täglicher Lernerinnerung',
        'Bitte füll den Fragebogen für dein Lernverhalten aus', time, platformChannelSpecifics);
  }

  getPendingNotifications() async {
    return await localNotifications.pendingNotificationRequests();
  }
}
