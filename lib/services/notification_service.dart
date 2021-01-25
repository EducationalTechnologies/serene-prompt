import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  FlutterLocalNotificationsPlugin localNotifications;

  static const String CHANNEL_ID_II_REMINDER = "WDP Erinnerung";
  static const String CHANNEL_NAME_II_REMINDER = "Wenn-Dann-Plan Erinnerung";
  static const String CHANNEL_DESCRIPTION_II_REMINDER =
      "Wenn-Dann-Plan Erinnerung";
  static const String PAYLOAD_II_REMINDER = "PAYLOAD_II_REMINDER";

  static const String CHANNEL_ID_TASK = "Aufgabenerinnerung";
  static const String CHANNEL_NAME_TASK = "Aufgabenerinnerung";
  static const String CHANNEL_DESCRIPTION_TASK = "Aufgabenerinnerung";
  static const String PAYLOAD_TASK_REMINDER = "PAYLOAD_TASK_REMINDER";

  static const int ID_INTERNALISATION = 69;
  static const int ID_TASK_REMINDER = 42;

  NotificationService._internal() {
    localNotifications = FlutterLocalNotificationsPlugin();
  }

  Future initialize() async {
    var initSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
    var initSettings = InitializationSettings(android: initSettingsAndroid);

    await _configureLocalTimeZone();

    await localNotifications.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    await scheduleInternalisationReminder(new Time(6, 30, 0));
    // await scheduleTaskReminder(new Time(17, 00, 0));
    var pendingNotifications = await getPendingNotifications();
    var internalisationReminderExists = pendingNotifications
        .firstWhere((n) => n.id == ID_INTERNALISATION, orElse: () => null);
    if (internalisationReminderExists == null) {}

    var taskReminderExists = pendingNotifications
        .firstWhere((n) => n.id == ID_TASK_REMINDER, orElse: () => null);
    if (taskReminderExists == null) {}

    return true;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);

      // if (payload == PAYLOAD_II_REMINDER) {
      //   await locator<NavigationService>()
      //       .navigateTo(RouteNames.INTERNALISATION);
      // }
      // if (payload == PAYLOAD_TASK_REMINDER) {
      //   await locator<NavigationService>().navigateTo(RouteNames.RECALL_TASK);
      // }
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
        payload: PAYLOAD_II_REMINDER,
        androidAllowWhileIdle: true);
  }

  sendDebugReminder() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_TASK, CHANNEL_NAME_TASK, CHANNEL_DESCRIPTION_TASK);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var notificationDetails = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute + 2);

    await localNotifications.zonedSchedule(
        123123123,
        "Versuche dich, an deinen Wenn-Dann-Plan zu erinnern",
        "Klicke hier, um deine Erinnerung an den Wenn-Dann-Plan zu überprüfen",
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: PAYLOAD_TASK_REMINDER,
        androidAllowWhileIdle: true);
  }

  scheduleRecallTaskReminder(DateTime time) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_TASK, CHANNEL_NAME_TASK, CHANNEL_DESCRIPTION_TASK);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var notificationDetails = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var scheduledDate =
        tz.TZDateTime(tz.local, time.year, time.month, time.day);

    await localNotifications.zonedSchedule(
        ID_TASK_REMINDER,
        "Versuche dich, an deinen Wenn-Dann-Plan zu erinnern",
        "Klicke hier, um deine Erinnerung an den Wenn-Dann-Plan zu überprüfen",
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: PAYLOAD_TASK_REMINDER,
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
        ID_TASK_REMINDER,
        "Versuche dich, an deinen Wenn-Dann-Plan zu erinnern",
        "Klicke hier, um deine Erinnerung an den Wenn-Dann-Plan zu überprüfen",
        _getNextScheduleTimeFromTime(time),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: PAYLOAD_TASK_REMINDER,
        androidAllowWhileIdle: true);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await localNotifications.pendingNotificationRequests();
  }

  clearPendingNotifications() async {
    await localNotifications.cancelAll();
  }
}
