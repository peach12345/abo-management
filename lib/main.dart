import 'package:androidapp/bloc/subscription_bloc.dart';
import 'package:androidapp/model/subscription.dart';
import 'package:androidapp/view/subscription_table_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'notification/notifications_helper.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Subscription>(SubscriptionAdapter());
  Box<Subscription> box = await Hive.openBox("subscription");
  Box<Subscription> bankBox = await Hive.openBox("bank");
  Box<Subscription> carBox = await Hive.openBox("car");

  WidgetsFlutterBinding.ensureInitialized();

  NotificationAppLaunchDetails notifLaunch;
  final FlutterLocalNotificationsPlugin notifsPlugin =
      FlutterLocalNotificationsPlugin();
  notifLaunch = (await notifsPlugin.getNotificationAppLaunchDetails())!;
  await initNotifications(notifsPlugin);

  runApp(MyApp(
    subscriptionBloc: SubscriptionBloc(box,notifsPlugin,bankBox,carBox),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.subscriptionBloc}) : super(key: key);

  final SubscriptionBloc subscriptionBloc;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //   var insurance = databaseService.getObject();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => subscriptionBloc,
        child: const SubscriptionView(),
      ),
    );
  }
}
