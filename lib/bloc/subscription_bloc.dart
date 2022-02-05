import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


part 'subscription_event.dart';
part 'subscription_state.dart';


class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState>  {
  SubscriptionBloc() : super(const SubscriptionState()) {
    on<SubscriptionSubmitted>(_SubscriptionSubmitted);
    on<NameChanged>(_NameChanged);
    on<DaysChanged>(_DaysChanged);
    on<NotificationChanged>(_notificationChanged);

  }

  // ignore: non_constant_identifier_names
  FutureOr<void> _SubscriptionSubmitted(SubscriptionSubmitted event, Emitter<SubscriptionState> emit) {
    if(validateInputs()) {
      
    }
  }
    bool validateInputs() {

      if(state.name.isNotEmpty){
        return true;
      }
      return false;
    }

  FutureOr<void> _NameChanged(NameChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(name: event.name));
  }

  FutureOr<void> _DaysChanged(DaysChanged event, Emitter<SubscriptionState> emit) {
        emit(state.copyWith(days: event.days));

  }

  FutureOr<void> _notificationChanged(NotificationChanged event, Emitter<SubscriptionState> emit) {
            emit(state.copyWith(notification: event.notification));

  }
}
