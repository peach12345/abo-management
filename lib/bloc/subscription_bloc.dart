import 'dart:async';

import 'package:androidapp/model/subscription.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../notification/notifications_helper.dart';

part 'subscription_event.dart';

part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc(this.homeBox, this.notifsPlugin, this.bankBox, this.carBox)
      : super(const SubscriptionState()) {
    on<SubscriptionSubmitted>(_onSubscriptionSubmitted);
    on<NameChanged>(_onNameChanged);
    on<DateChanged>(_onDateChanged);
    on<CancellationPeriodChanged>(_onCancellationPeriodChanged);
    on<SubscriptionInitial>(_onSubscriptionInitial);
    on<DeleteSubscription>(_onDeleteSubscription);
    on<CostMonthlyChanged>(_onCostMonthlyChanged);
    init();
  }

  final Box<Subscription> homeBox;
  final Box<Subscription> bankBox;
  final Box<Subscription> carBox;

  final FlutterLocalNotificationsPlugin notifsPlugin;

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
      emit(state.copyWith(status: SubscriptionStatus.loading));
      var outputFormat = DateFormat('dd.MM.yyyy');
      if (state.date.isEmpty) {
        var outputDate = outputFormat.format(DateTime.now());
        emit(state.copyWith(date: outputDate));
      }
      List<Subscription> newResult = _addSubscription(outputFormat, emit);
      emit(state.copyWith(
          homeSubscriptionList: newResult, status: SubscriptionStatus.success));
      _createNotification();
    } catch (e) {
      emit(state.copyWith(status: SubscriptionStatus.failure));
    }
  }

  List<Subscription> _addSubscription(DateFormat outputFormat, Emitter<SubscriptionState> emit) {
    final sub = Subscription(
        name: state.name,
        costs: state.costs,
        date: outputFormat.format(DateTime.parse(state.date)),
        cancellationPeriod: state.cancellationPeriod);
    List<Subscription> newResult = [];
    newResult.addAll(state.homeSubscriptionList);
    if (homeBox.get(sub.name) != null) {
      homeBox.delete(sub.name);
      newResult.remove(newResult.firstWhere((e) => e.name == sub.name));
    }
    emit(state.copyWith(status: SubscriptionStatus.loading));
    newResult.add(sub);
    homeBox.put(sub.name, sub);
    return newResult;
  }

  void _createNotification() {
    DateTime test = DateTime.parse(state.date);
    var timeToSchedule =
        test.subtract(Duration(days: state.cancellationPeriod.toInt()));
    scheduleNotification(
        notifsPlugin: notifsPlugin,
        //Or whatever you've named it in main.dart
        id: timeToSchedule.toString(),
        body: "Reminder to cancel you subscription for: " + state.name,
        scheduledTime: timeToSchedule,
        title: "Reminder");
  }

  Future<void> _onCancellationPeriodChanged(
      CancellationPeriodChanged event, Emitter<SubscriptionState> emit) async {
    emit(state.copyWith(cancellationPeriod: event.cancellationPeriod));
  }

  void init() {
    List<Subscription> newResult = [];
    newResult = homeBox.values
        .map(
          (e) => Subscription(
              costs: e.costs,
              name: e.name,
              date: e.date,
              cancellationPeriod: e.cancellationPeriod),
        )
        .toList();
    emit(state.copyWith(homeSubscriptionList: newResult));
  }

  Future<void> _onSubscriptionInitial(
      SubscriptionInitial event, Emitter<SubscriptionState> emit) async {
    emit(state.copyWith(status: SubscriptionStatus.initial));
  }

  FutureOr<void> _onDeleteSubscription(
      DeleteSubscription event, Emitter<SubscriptionState> emit) {
    List<Subscription> newResult = [];
    newResult.addAll(state.homeSubscriptionList);
    if (homeBox.get(event.name) != null) {
      homeBox.delete(event.name);
      newResult.remove(newResult.firstWhere((e) => e.name == event.name));
    }
    emit(state.copyWith(homeSubscriptionList: newResult));
  }

  FutureOr<void> _onCostMonthlyChanged(
      CostMonthlyChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(costs: event.costs));
  }
}
