import 'package:androidapp/model/subscription.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //   var insurance = databaseService.getObject();
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Insurance end reminder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Notification { yes, no }

class _MyHomePageState extends State<MyHomePage> {
  late Box _insuranceBox;
  late String name;
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerDays = TextEditingController();
  Notification? _character = Notification.no;
  DateTime selectedDate = DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hive.registerAdapter(SubscriptionAdapter());
    _openBox();
  }

  Future _openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _insuranceBox = await Hive.openBox('subscriptionBox');
    return;
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
        }

      @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                    decoration: const InputDecoration(hintText: "name"),
                    controller: textEditingControllerName),
              ),
              const Text("Notification when the contract expires"),

              RadioListTile<Notification>(
                  title: const Text("no"),
                  value: Notification.no,
                  onChanged: (Notification? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                  groupValue: _character),
              RadioListTile<Notification>(
                  title: const Text("yes"),
                  value: Notification.yes,
                  onChanged: (Notification? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                  groupValue: _character),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "days"),
                controller: textEditingControllerDays,
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context), // Refer step 3
                  child: const Text(
                    'Select date',
                    style:
                    TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Text(selectedDate.toLocal().toString()),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      var insurance = Subscription(
                          name: textEditingControllerName.value.text,
                          notification:
                              _character == Notification.yes ? true : false,
                          days:
                              int.parse(textEditingControllerDays.value.text));
                      _insuranceBox.add(insurance);
                    },
                    child: const Text("Add")),
              ),
              const Text("Data in database"),
                   Expanded(
                      child: WatchBoxBuilder(
                        box: _insuranceBox,
                        builder: (context, box) {
                          Map<dynamic, dynamic> raw = box.toMap();
                          List list = raw.values.toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              Subscription insurance = list[index];
                              return Card(
                                child: ListTile(
                                  title: Text(insurance.name),
                                  leading:  GestureDetector(child: Icon(Icons.delete), onTap: () => (value) {
                                    setState(() {
                                      print("delete");
                                    _insuranceBox.delete(value);
                                    });
                                  }),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
