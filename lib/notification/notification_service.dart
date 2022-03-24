/*
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  NotificationService._internal();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');



    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }
  tz.initializeTimeZones();  // <------


  Future<void> zonedSchedule(
  int id,
      String? title,
  String? body,
      TZDateTime scheduledDate,
  NotificationDetails notificationDetails,
  {required UILocalNotificationDateInterpretation uiLocalNotificationDateInterpretation,
  required bool androidAllowWhileIdle,
  String? payload,
      DateTimeComponents? matchDateTimeComponents
  });

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }




}*/
