import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/subscription_bloc.dart';

class AddSubscriptionView extends StatelessWidget {
  AddSubscriptionView({Key? key}) : super(key: key);
  late final DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    context.read<SubscriptionBloc>().add(DateChanged(picked.toString()));
  }

  @override
  Widget build(BuildContext context) {
    print(context.read<SubscriptionBloc>().state.name);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subscription"),
      ),
      body: BlocListener<SubscriptionBloc, SubscriptionState>(
        listenWhen: (previous,current) {return previous.status != current.status;},
        listener: (context, state) {
          if (state.status == SubscriptionStatus.success) {
            Navigator.of(context).pop();
          } else if (state.status == SubscriptionStatus.failure) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Select a date'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Ok'),
                    child: const Text('Ok'),
                  ),
                ],
              ),
            );
          }
        },
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                            initialValue: state.name,
                            onChanged: (name) => {
                                  context
                                      .read<SubscriptionBloc>()
                                      .add(NameChanged(name))
                                },
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
                            onChanged: (month) => context
                                .read<SubscriptionBloc>()
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
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                              onPressed: () => {
                                    context
                                        .read<SubscriptionBloc>()
                                        .add(SubscriptionSubmitted())
                                  },
                              child: const Icon(Icons.add)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
