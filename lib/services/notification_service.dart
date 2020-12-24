import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:serene/locator.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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

  static const String CHANNEL_ID_II_REMINDER = "WDP Erinnerung";
  static const String CHANNEL_NAME_II_REMINDER = "Wenn-Dann-Plan Erinnerung";
  static const String CHANNEL_DESCRIPTION_II_REMINDER =
      "Wenn-Dann-Plan Erinnerung";

  static const String CHANNEL_ID_TASK = "Aufgabenerinnerung";
  static const String CHANNEL_NAME_TASK = "Aufgabenerinnerung";
  static const String CHANNEL_DESCRIPTION_TASK = "Aufgabenerinnerung";

  static const String CHANNEL_ID_DEADLINE = "serene deadline";
  static const String CHANNEL_NAME_DEADLINE = "Deadline Erinnerung";

  static const String PAYLOAD_DAILY_LEARN = "DAILY_LEARNING";

  static const int ID_INTERNALISATION = 69;

  NotificationService._internal() {
    localNotifications = FlutterLocalNotificationsPlugin();

    configureFirebaseMessaging();
  }

  Future initialize() async {
    var initSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
    var initSettings = InitializationSettings(android: initSettingsAndroid);

    await _configureLocalTimeZone();

    await localNotifications.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    var pendingNotifications = await getPendingNotifications();
    var dailyScheduleExists = pendingNotifications
        .firstWhere((n) => n.id == ID_INTERNALISATION, orElse: () => null);
    if (dailyScheduleExists == null) {
      await scheduleInternalisationReminder(new Time(6, 30, 0));
      await scheduleTaskReminder(new Time(16, 30, 0));
    }
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
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
        await locator<NavigationService>().navigateTo(
            RouteNames.INTERNALISATION,
            arguments: AssessmentScreenArguments(AssessmentType.preLearning));
      }
    }
  }

  _getNextScheduleTimeFromTime(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  scheduleInternalisationReminder(Time time) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_II_REMINDER,
        CHANNEL_NAME_II_REMINDER,
        CHANNEL_DESCRIPTION_II_REMINDER);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var notificationDetails = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await localNotifications.zonedSchedule(
        ID_INTERNALISATION,
        "Nutze deinen Wenn-Dann-Plan",
        "Bitte nutze deinen Wenn-Dann-Plan",
        _getNextScheduleTimeFromTime(time),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true);
  }

  scheduleTaskReminder(Time time) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_TASK, CHANNEL_NAME_TASK, CHANNEL_DESCRIPTION_TASK);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var notificationDetails = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await localNotifications.zonedSchedule(
        ID_INTERNALISATION,
        "Nutze deinen Wenn-Dann-Plan",
        "Bitte nutze deinen Wenn-Dann-Plan",
        _getNextScheduleTimeFromTime(time),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await localNotifications.pendingNotificationRequests();
  }

  clearPendingNotifications() async {
    await localNotifications.cancelAll();
  }
}
