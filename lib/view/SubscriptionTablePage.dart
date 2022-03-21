import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/subscription_bloc.dart';
import 'AddSubscriptionPage.dart';

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
    Navigator.of(mainContext).push(MaterialPageRoute(builder: (context) {
      return BlocProvider(
        create: (context) => mainContext.read<SubscriptionBloc>(),
        child: AddSubscriptionView(),
      );
    }));
  }
}