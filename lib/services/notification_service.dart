import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:serene/services/firebase_service.dart';

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

  NotificationService._internal() {
    localNotifications = FlutterLocalNotificationsPlugin();

    var initSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
    var initSettings = InitializationSettings(initSettingsAndroid, null);
    localNotifications.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    configureFirebaseMessaging();
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
    }
  }

  showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await localNotifications.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  scheduleNotifications() async {
    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 5));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_ASSESSMENT,
        CHANNEL_NAME_ASSESSMENT,
        'Erinnerung an den Fragebogen');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await localNotifications.schedule(0, 'scheduled title', 'scheduled body',
        scheduledNotificationDateTime, platformChannelSpecifics);
  }
}
