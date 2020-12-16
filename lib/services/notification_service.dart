import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  static const int ID_DAILY_REMINDER = 69;

  NotificationService._internal() {
    localNotifications = FlutterLocalNotificationsPlugin();

    configureFirebaseMessaging();
  }

  Future initialize() async {
    var initSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
    var initSettings = InitializationSettings(android: initSettingsAndroid);
    await localNotifications.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    var pendingNotifications = await getPendingNotifications();
    var dailyScheduleExists = pendingNotifications
        .firstWhere((n) => n.id == ID_DAILY_REMINDER, orElse: () => null);
    if (dailyScheduleExists == null) {
      await scheduleDailyNotification();
    }
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

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);

      if (payload == PAYLOAD_DAILY_LEARN) {
        await locator<NavigationService>().navigateTo(
            RouteNames.DAILY_LEARNING_QUESTIONS,
            arguments: AssessmentScreenArguments(AssessmentType.preLearning));
        await locator<NavigationService>().navigateTo(RouteNames.GOAL_SHIELDING,
            arguments: AssessmentScreenArguments(AssessmentType.preLearning));
      }
    }
  }

  showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        CHANNEL_ID_ASSESSMENT,
        CHANNEL_NAME_ASSESSMENT,
        'Erinnerung an den Fragebogen',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await localNotifications.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  scheduleNotifications() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_ASSESSMENT,
        CHANNEL_NAME_ASSESSMENT,
        'Erinnerung an den Fragebogen');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await localNotifications.zonedSchedule(
        11,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: PAYLOAD_DAILY_LEARN);
  }

  scheduleDailyNotification() async {
    var time = new Time(7, 0, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_ASSESSMENT,
        CHANNEL_NAME_ASSESSMENT,
        'Erinnerung an den Fragebogen');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await localNotifications.showDailyAtTime(
        ID_DAILY_REMINDER,
        'Tägliche Lernerinnerung',
        'Bitte fülle den Fragebogen für dein Lernverhalten aus',
        time,
        platformChannelSpecifics);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await localNotifications.pendingNotificationRequests();
  }

  clearPendingNotifications() async {
    await localNotifications.cancelAll();
  }
}
