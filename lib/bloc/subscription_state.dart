part of 'subscription_bloc.dart';

@immutable
class SubscriptionState extends Equatable {
  const SubscriptionState(
      {this.name = "", this.result = const[], this.date = ""});

  final String name;
  final String date;
  final List<Subscription> result;

  SubscriptionState copyWith({String? name,  List<Subscription>? result, String? date}) {
    return SubscriptionState(
        name: name ?? this.name,
        result: result ?? this.result,
        date: date ?? this.date);
  }

  @override
  List<Object?> get props => [name, result, date ];
}
