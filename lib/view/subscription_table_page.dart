import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/subscription_bloc.dart';
import 'add_subscription_page.dart';

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
              DataColumn(label: Text('Subscription Name')),
              DataColumn(label: Text('Start Date')),
              DataColumn(label: Text('Cancellation Period in Month')),
              DataColumn(label: Text('Monthly Costs')),
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
                          DataCell(Text(element.costs.toString())),
                          DataCell(const Icon(Icons.delete),
                              onTap: () => {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext newContext) =>
                                          AlertDialog(
                                        title: const Text('Delete entry'),
                                        content: const Text(
                                            'Do you really want to delete this entry?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => {
                                              context
                                                  .read<SubscriptionBloc>()
                                                  .add(DeleteSubscription(
                                                      element.name)),
                                              Navigator.pop(newContext, 'Yes')
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () => {
                                              Navigator.pop(newContext, 'No')
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  })
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Add',
            ),
          ],
          selectedItemColor: Colors.amber[800],
        ),
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
      body: const Table(),
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
