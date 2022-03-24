import 'package:androidapp/bloc/subscription_bloc.dart';
import 'package:androidapp/model/subscription.dart';
import 'package:androidapp/view/SubscriptionTablePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'notification/notification_service.dart';
import 'view/AddSubscriptionPage.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Subscription>(SubscriptionAdapter());
  Box<Subscription> box = await Hive.openBox("subscription");

  WidgetsFlutterBinding.ensureInitialized();
 // await NotificationService().init();
  runApp(MyApp(
    subscriptionBloc: SubscriptionBloc(box),
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
        create: (context) =>  subscriptionBloc,
        child: const SubscriptionView(),
      ),
    );
  }
}




