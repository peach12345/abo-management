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
    on<DeleteSubscription>(_onDeleteSubscription);
    init();
  }

  final Box<Subscription> box;

  Future<void> _onNameChanged(
      NameChanged event, Emitter<SubscriptionState> emit) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onDateChanged(
      DateChanged event, Emitter<SubscriptionState> emit) async {
    emit(state.copyWith(date: event.date));
  }

  Future<void> _onSubscriptionSubmitted(
      SubscriptionSubmitted event, Emitter<SubscriptionState> emit) async {
    try {
      emit(state.copyWith(
          status: SubscriptionStatus.loading));
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
      emit(state.copyWith(
          result: newResult, status: SubscriptionStatus.success));
    } catch(e) {
      emit(state.copyWith(
          status: SubscriptionStatus.failure));
    }
  }

  Future<void> _onCancellationPeriodChanged(
      CancellationPeriodChanged event, Emitter<SubscriptionState> emit) async {
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

  Future<void> _onSubscriptionInitial(
      SubscriptionInitial event, Emitter<SubscriptionState> emit) async {
    emit(state.copyWith(status: SubscriptionStatus.initial));
  }

  FutureOr<void> _onDeleteSubscription(DeleteSubscription event, Emitter<SubscriptionState> emit) {
    List<Subscription> newResult = [];
    newResult.addAll(state.result);
    if (box.get(event.name) != null) {
      box.delete(event.name);
      newResult.remove(newResult.firstWhere((e) => e.name == event.name));
    }
    emit(state.copyWith(result: newResult));
  }
}
