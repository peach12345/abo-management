import 'dart:async';

import 'package:androidapp/model/subscription.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'subscription_event.dart';

part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc(this.box) : super( const SubscriptionState()) {
    on<SubscriptionSubmitted>(_onSubscriptionSubmitted);
    on<NameChanged>(_onNameChanged);
    on<DateChanged>(_onDateChanged);
    on<CancellationPeriodChanged>(_onCancellationPeriodChanged);
    on<SubscriptionInitial>(_onSubscriptionInitial);
    init();
  }

  final Box<Subscription> box;

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
    final sub = Subscription(
        name: state.name,
        date: outputFormat.format(DateTime.parse(state.date)),
        cancellationPeriod: state.cancellationPeriod);
    List<Subscription> newResult = [];
    newResult.addAll(state.result);
    if (box.get(sub.name) != null) {
      box.delete(sub.name);
      newResult.remove(newResult.firstWhere((e) => e.name == sub.name));
    }
    emit(state.copyWith(status: SubscriptionStatus.loading));
    newResult.add(sub);
    box.put(sub.name, sub);
    emit(state.copyWith(result: newResult, status: SubscriptionStatus.success));
  }

  FutureOr<void> _onCancellationPeriodChanged(
      CancellationPeriodChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(cancellationPeriod: event.cancellationPeriod));
  }

  void init() {
    List<Subscription> newResult = [];
    newResult = box.values
        .map(
          (e) => Subscription(
              name: e.name,
              date: e.date,
              cancellationPeriod: e.cancellationPeriod),
        )
        .toList();
    emit(state.copyWith(result: newResult));
  }

  FutureOr<void> _onSubscriptionInitial(
      SubscriptionInitial event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(status: SubscriptionStatus.initial));
  }
}
