import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/logging_service.dart';
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
  static const String PAYLOAD_TASK_REMINDER = "PAYLOAD_RECALL_TASK_REMINDER";

  static const String CHANNEL_ID_LDT_REMINDER = "LDT Erinnerung";
  static const String CHANNEL_NAME_LDT_REMINDER = "LDT Erinnerung";
  static const String CHANNEL_DESCRIPTION_LDT_REMINDER = "LDT Erinnerung";
  static const String PAYLOAD_LDT_REMINDER = "PAYLOAD_LDT_REMINDER";

  static const int ID_LDT_REMINDER = 87;
  static const int ID_INTERNALISATION = 69;
  static const int ID_TASK_REMINDER = 42;

  NotificationService._internal() {
    localNotifications = FlutterLocalNotificationsPlugin();
  }

  Future initialize() async {
    var initSettingsAndroid =
        new AndroidInitializationSettings('ic_notification');
    var initSettingsIOS = new IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSettings = InitializationSettings(
        android: initSettingsAndroid, iOS: initSettingsIOS);

    await _configureLocalTimeZone();

    await localNotifications.initialize(initSettings,
        onSelectNotification: onSelectNotification);

    await scheduleInternalisationReminder(new Time(6, 30, 0));

    return true;
  }

  onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  deleteScheduledInternalisationReminder() async {
    var pendingNotifications = await getPendingNotifications();
    var taskReminderExists = pendingNotifications
        .firstWhere((n) => n.id == ID_INTERNALISATION, orElse: () => null);
    if (taskReminderExists == null) {
      localNotifications.cancel(ID_INTERNALISATION);
    }
  }

  deleteScheduledRecallReminderTask() async {
    var pendingNotifications = await getPendingNotifications();
    var taskReminderExists = pendingNotifications
        .firstWhere((n) => n.id == ID_TASK_REMINDER, orElse: () => null);
    if (taskReminderExists == null) {}
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);

      if (payload == PAYLOAD_II_REMINDER) {
        locator
            .get<LoggingService>()
            .logEvent("NotificationClickInternalisation");
      }
      if (payload == PAYLOAD_TASK_REMINDER) {
        locator.get<LoggingService>().logEvent("NotificationClickRecallTask");
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
        CHANNEL_DESCRIPTION_II_REMINDER,
        ongoing: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var notificationDetails = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await localNotifications.zonedSchedule(
        ID_INTERNALISATION,
        "🧪👩‍🔬👨‍🔬🧪 Zeit für die Wissenschaft!",
        "Bitte nutze deinen Wenn-Dann-Plan",
        _getNextScheduleTimeFromTime(time),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: PAYLOAD_II_REMINDER,
        androidAllowWhileIdle: true);
  }

  getMillisecondsUntilMidnight(DateTime time) {
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day, 23, 59);

    return midnight.difference(now).inMilliseconds;
  }

  scheduleRecallTaskReminder(DateTime time) async {
    var timeoutAfter = getMillisecondsUntilMidnight(time);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_TASK, CHANNEL_NAME_TASK, CHANNEL_DESCRIPTION_TASK,
        ongoing: true, timeoutAfter: timeoutAfter);

    var notificationDetails =
        new NotificationDetails(android: androidPlatformChannelSpecifics);

    var scheduledDate = tz.TZDateTime(
        tz.local, time.year, time.month, time.day, time.hour, time.minute);

    // var textReminder =
    //     "Klicke hier, um deine Erinnerung an den Wenn-Dann-Plan zu überprüfen";
    // TODO: Remove the timestamp
    var textReminder = "Erinnerungserinnerung: ${time.toIso8601String()}";

    locator.get<LoggingService>().logEvent("TaskReminderNotificationSchedule");

    await localNotifications.zonedSchedule(
        ID_TASK_REMINDER,
        "🧪👩‍🔬👨‍🔬🧪 Zeit für die Wissenschaft!",
        textReminder,
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: PAYLOAD_TASK_REMINDER,
        androidAllowWhileIdle: true);
  }

  scheduleLDTReminder(DateTime time) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        CHANNEL_ID_LDT_REMINDER,
        CHANNEL_NAME_LDT_REMINDER,
        CHANNEL_DESCRIPTION_LDT_REMINDER,
        ongoing: true);

    var notificationDetails =
        new NotificationDetails(android: androidPlatformChannelSpecifics);

    var scheduledDate = tz.TZDateTime(
        tz.local, time.year, time.month, time.day, time.hour, time.minute);

    await localNotifications.zonedSchedule(ID_LDT_REMINDER, "LDT Erinnerung",
        "LDT Erinnerung", scheduledDate, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: PAYLOAD_LDT_REMINDER,
        androidAllowWhileIdle: true);
  }

  sendDebugReminder() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        "WURST", CHANNEL_NAME_TASK, CHANNEL_DESCRIPTION_TASK);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var notificationDetails = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, now.hour, now.minute, now.second + 5);

    await localNotifications.zonedSchedule(
        123123123,
        "Ich bin eine Benachrichtigung",
        "Ich bin eine Benachrichtigung",
        scheduledDate,
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
