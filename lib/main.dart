import 'package:androidapp/bloc/subscription_bloc.dart';
import 'package:androidapp/model/subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Subscription>(SubscriptionAdapter());
  Box<Subscription> box = await Hive.openBox("subscription");
  runApp(MyApp(
    box: box,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.box}) : super(key: key);

  final Box<Subscription> box;

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
        create: (context) => SubscriptionBloc(box),
        child: const SubscriptionView(),
      ),
    );
  }
}

enum Notification { yes, no }

class AddSubscriptionView extends StatelessWidget {
   DateTime selectedDate = DateTime.now();

  AddSubscriptionView({Key? key}) : super(key: key);

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      context.read<SubscriptionBloc>().add(DateChanged(picked.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subscription"),
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
       //   if (state.status == SubscriptionStatus.success) {
        //    Navigator.of(context).pop();
       //   }
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
                          .add(NameChanged(name)),
                        decoration: const InputDecoration(
                            hintText: "Abo name", labelText: "Abo name")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: state.cancellationPeriod.toString(),
                        onChanged: (month) => context.read<SubscriptionBloc>()
                          .add(CancellationPeriodChanged(
                              month.isEmpty ? 0 : num.parse(month))),
                        decoration: const InputDecoration(
                            hintText: "Cancellation period",
                            labelText: "Cancellation period")),
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
                          onPressed: () => {
                                context.read<SubscriptionBloc>()
                                  .add(SubscriptionSubmitted())
                              },
                          child: const Icon(Icons.add)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Table extends StatelessWidget {
  const Table({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
        buildWhen: (previousState, state) {
      return previousState.result.length != state.result.length;
      // return true/false to determine whether or not
      // to rebuild the widget with state
    }, builder: (context, state) {
      return SingleChildScrollView(
        child: DataTable(
          decoration: const BoxDecoration(
              border: Border(
            bottom: BorderSide(
              //                   <--- left side
              color: Colors.black,
              width: 0.5,
            ),
            top: BorderSide(
              //                    <--- top side
              color: Colors.black,
              width: 0.5,
            ),
          )),
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Cancellation Period'))
          ],
          rows: state
              .result // Loops through dataColumnText, each iteration assigning the value to element
              .map(
                ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element.name)),
                        DataCell(Text(element.date)),
                        DataCell(Text(element.cancellationPeriod.toString()))
                        //Extracting from Map element the value
                      ],
                    )),
              )
              .toList(),
        ),
      );
    });
  }
}

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscriptions"),
        actions: [
          IconButton(
              onPressed: () {
                _pushSaved(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Expanded(flex: 1, child: Table()),
              // return widget here based on BlocA's state
            ],
          ),
        ),
      ),
    );
  }

  void _pushSaved(BuildContext mainContext) {
    mainContext.read<SubscriptionBloc>().add(SubscriptionInitial());
    Navigator.of(mainContext).push(MaterialPageRoute<void>(builder: (context) {
      return BlocProvider(
        create: (context) => mainContext.read<SubscriptionBloc>(),
        child: AddSubscriptionView(),
      );
    }));
  }
}
