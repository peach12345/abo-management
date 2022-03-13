import 'dart:async';

import 'package:androidapp/model/subscription.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'subscription_event.dart';

part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(const SubscriptionState()) {
    on<SubscriptionSubmitted>(_onSubscriptionSubmitted);
    on<NameChanged>(_onNameChanged);
    on<DateChanged>(_onDateChanged);
    on<CancellationPeriodChanged>(_onCancellationPeriodChanged);
  }

  bool validateInputs() {
    if (state.name.isNotEmpty) {
      return true;
    }
    return false;
  }

  FutureOr<void> _onNameChanged(
      NameChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(name: event.name));
  }

  FutureOr<void> _onDateChanged(
      DateChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(date: event.date));
  }

  FutureOr<void> _onSubscriptionSubmitted(
      SubscriptionSubmitted event, Emitter<SubscriptionState> emit) {
    var outputFormat = DateFormat('dd.MM.yyyy');

    if (state.date.isEmpty) {
      var outputDate = outputFormat.format(DateTime.now());
      emit(state.copyWith(date: outputDate));
    }
    List<Subscription> newResult = [];
    newResult.addAll(state.result);
    newResult.add(Subscription(
        name: state.name,
        date: outputFormat.format(DateTime.parse(state.date)),
        cancellationPeriod: state.cancellationPeriod));
    emit(state.copyWith(result: newResult));
  }

  FutureOr<void> _onCancellationPeriodChanged(
      CancellationPeriodChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(cancellationPeriod: event.cancellationPeriod));
  }
}
