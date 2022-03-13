part of 'subscription_bloc.dart';

@immutable
class SubscriptionState extends Equatable {
  const SubscriptionState(
      {this.name = "", this.result = const[], this.date = "", this.cancellationPeriod =  3});

  final String name;
  final String date;
  final num cancellationPeriod;
  final List<Subscription> result;

  SubscriptionState copyWith({String? name,  List<Subscription>? result, String? date, num? cancellationPeriod}) {
    return SubscriptionState(
        name: name ?? this.name,
        result: result ?? this.result,
        date: date ?? this.date,cancellationPeriod: cancellationPeriod ?? this.cancellationPeriod);
  }

  @override
  List<Object?> get props => [name, result, date,cancellationPeriod ];
}
