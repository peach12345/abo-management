import 'dart:async';

import 'package:androidapp/model/subscription.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


part 'subscription_event.dart';
part 'subscription_state.dart';


class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState>  {
  SubscriptionBloc() : super(const SubscriptionState()) {
    on<SubscriptionSubmitted>(_onSubscriptionSubmitted);
    on<NameChanged>(_onNameChanged);
    on<DateChanged>(_onDateChangend);
  }

    bool validateInputs() {

      if(state.name.isNotEmpty){
        return true;
      }
      return false;
    }

  FutureOr<void> _onNameChanged(NameChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(name: event.name));
  }

  FutureOr<void> _onSubscriptionSubmitted(SubscriptionSubmitted event, Emitter<SubscriptionState> emit) {
    List<Subscription> newResult = [];
    newResult.addAll(state.result);
    newResult.add(Subscription(name: state.name, date: state.date));
    emit(state.copyWith(result: newResult));
  }

  FutureOr<void> _onDateChangend(DateChanged event, Emitter<SubscriptionState> emit) {
    print("Test");
    emit(state.copyWith(date: event.date));
  }
}
