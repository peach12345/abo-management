import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


part 'subscription_event.dart';
part 'subscription_state.dart';


class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState>  {
  SubscriptionBloc() : super(const SubscriptionState()) {
    on<SubscriptionSubmitted>(_SubscriptionSubmitted);
  }

  // ignore: non_constant_identifier_names
  FutureOr<void> _SubscriptionSubmitted(SubscriptionSubmitted event, Emitter<SubscriptionState> emit) {
    if(validateInputs()) {
      
    }
    
    
  }

    bool validateInputs() {
      return false;
    }
}
