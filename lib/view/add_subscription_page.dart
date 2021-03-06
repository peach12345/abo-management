import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
            return Padding(
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
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter()
                          ],
                          initialValue: state.cancellationPeriod.toString(),
                          onChanged: (costs) => context
                              .read<SubscriptionBloc>()
                              .add(CostMonthlyChanged(costs)),
                          decoration: const InputDecoration(
                              hintText: "Costs monthly",
                              labelText: "Costs monthly")),
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
                  child: DropdownButton<String>(
                    value: state.selectedSubscriptionList,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                        context.read<SubscriptionBloc>().add(SeletedSubscriptionListChanged(newValue!));
                    },
                    items: <String>['Home', 'Car', 'Bank']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
            );
          },
        ),
      ),
    );
  }
}


class CurrencyInputFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.selection.baseOffset == 0){
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(name: 'EUR', decimalDigits: 2);

    String newText = formatter.format(value/100);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}