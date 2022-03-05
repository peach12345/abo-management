import 'package:androidapp/bloc/subscription_bloc.dart';
import 'package:androidapp/model/subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      home:  BlocProvider(
        create: (context) => SubscriptionBloc(),
        child: const MyHomePage(title: 'Insurance end reminder'),
      ),
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

  DateTime selectedDate = DateTime.now();
  List<Subscription> result = [];

  @override
  void initState() {
    super.initState();
  }


  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        context.read<SubscriptionBloc>().add(DateChanged(picked.toString()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {},
        buildWhen: (previous,current) {
          return previous.result != current.result;
    },

        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                        initialValue: state.name,
                        onChanged: (name) => context.read<SubscriptionBloc>()
                          ..add(NameChanged(name)),
                        decoration: const InputDecoration(hintText: "Abo name",labelText: "Abo name"
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context), // Refer step 3
                      child: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Date: " + selectedDate.toLocal().toString()),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          onPressed:  () => {context.read<SubscriptionBloc>()
                            ..add(SubscriptionSubmitted())},
                          child: const Icon(Icons.add)),
                    ),
                  ),
                  const Text("Data in database"),

                  BlocBuilder<SubscriptionBloc, SubscriptionState>(
                      buildWhen: (previousState, state) {
                       return previousState.result.length != state.result.length;
                        // return true/false to determine whether or not
                        // to rebuild the widget with state
                      },
                      builder: (context, state) {
                      return  Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: state.result.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.result[index].name + " " +  state.result[index].date),
                              );
                            },
                          ),
                        );
                        // return widget here based on BlocA's state
                      }
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
