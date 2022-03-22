part of 'subscription_bloc.dart';

@immutable
enum SubscriptionStatus {initial,loading,failure,success}

class SubscriptionState extends Equatable {
  const SubscriptionState(
      {this.name = "", this.result = const[], this.date = "", this.cancellationPeriod =  3, this.status = SubscriptionStatus.initial, this.costs = 0});

  final String name;
  final String date;
  final SubscriptionStatus status;
  final num cancellationPeriod;
  final num costs;
  final List<Subscription> result;

  SubscriptionState copyWith({String? name,  List<Subscription>? result, String? date, num? cancellationPeriod, SubscriptionStatus? status, num? costs}) {
    return SubscriptionState(
        name: name ?? this.name,
        result: result ?? this.result,
        date: date ?? this.date,cancellationPeriod: cancellationPeriod ?? this.cancellationPeriod,
    status: status ?? this.status, costs: costs ?? this.costs);
  }

  @override
  List<Object?> get props => [name, result, date,cancellationPeriod,status,costs ];
}
