import 'package:flutter_local_notifications/flutter_local_notifications.dart'as notifs;
import 'package:rxdart/subjects.dart' as rxSub;


final rxSub.BehaviorSubject<NotificationClass> didReceiveLocalNotificationSubject =
rxSub.BehaviorSubject<NotificationClass>();
final rxSub.BehaviorSubject<String> selectNotificationSubject =
rxSub.BehaviorSubject<String>();

Future<void> initNotifications(
    notifs.FlutterLocalNotificationsPlugin
    notifsPlugin) async {
  var initializationSettingsAndroid =
  notifs.AndroidInitializationSettings('icon');
  var initializationSettingsIOS = notifs.IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject
            .add(NotificationClass(id: id, title: title!, body: body!, payload: payload!));
      });
  var initializationSettings = notifs.InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await notifsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          print('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      });
  print("Notifications initialised successfully");
}


Future<void> scheduleNotification(
    {required notifs.FlutterLocalNotificationsPlugin notifsPlugin,
      required String id,
      required String title,
      required String body,
      required DateTime scheduledTime}) async {
  var androidSpecifics = notifs.AndroidNotificationDetails(
    id, // This specifies the ID of the Notification
    'Scheduled notification',
    icon: '@mipmap/notificationwhite',
    channelDescription: "My notification",
    largeIcon: const notifs.DrawableResourceAndroidBitmap('@mipmap/notification')
    // This specifies the name of the notification channel
  );
  var platformChannelSpecifics = notifs.NotificationDetails(
      android: androidSpecifics,iOS: null);
  await notifsPlugin.schedule(0, title, body,
      scheduledTime, platformChannelSpecifics); // This literally schedules the notification
}


class NotificationClass{
  final int id;
  final String title;
  final String body;
  final String payload;
  NotificationClass({required this.id, required this.body, required this.payload, required this.title});
}