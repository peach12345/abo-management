part of 'subscription_bloc.dart';

@immutable

enum SubscriptionStatus {initial,loading,failure,success}

class SubscriptionState extends Equatable {
  const SubscriptionState(
      {this.name = "", this.result = const[], this.date = "", this.cancellationPeriod =  3, this.status = SubscriptionStatus.initial});

  final String name;
  final String date;
  final SubscriptionStatus status;
  final num cancellationPeriod;
  final List<Subscription> result;

  SubscriptionState copyWith({String? name,  List<Subscription>? result, String? date, num? cancellationPeriod, SubscriptionStatus? status}) {
    return SubscriptionState(
        name: name ?? this.name,
        result: result ?? this.result,
        date: date ?? this.date,cancellationPeriod: cancellationPeriod ?? this.cancellationPeriod,
    status: status ?? this.status);
  }

  @override
  List<Object?> get props => [name, result, date,cancellationPeriod,status ];
}
