import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        scrollDirection: Axis.vertical,
        child: FittedBox(
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
              DataColumn(label: Text('Cancellation Period')),
              DataColumn(label: Text('Delete'))
            ],
            rows: state
                .result // Loops through dataColumnText, each iteration assigning the value to element
                .map(
                  ((element) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(element.name)),
                          DataCell(Text(element.date)),
                          DataCell(Text(element.cancellationPeriod.toString())),
                          DataCell(const Icon(Icons.delete),onTap: () => {context.read<SubscriptionBloc>().add(DeleteSubscription(element.name))})
                          //Extracting from Map element the value
                        ],
                      )),
                )
                .toList(),
          ),
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
                _openAddSubscriptionView(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body:  Container(child: const Table()),
    );
  }

  void _openAddSubscriptionView(BuildContext context) {
    context.read<SubscriptionBloc>().add(SubscriptionInitial());
    Navigator.of(context).push(MaterialPageRoute(builder: (newcontext) {
      return BlocProvider.value(
        value: BlocProvider.of<SubscriptionBloc>(context),
        child: AddSubscriptionView(),
      );
    }));
  }
}
