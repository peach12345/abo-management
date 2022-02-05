part of 'subscription_bloc.dart';

@immutable
 class SubscriptionState extends Equatable {
const SubscriptionState({this.name = "",  this.notification = true, this.days = 30});

final String name;
final bool notification;
final num days;


SubscriptionState copyWith({

String? name,

bool? notification,
num? days
}) {return SubscriptionState(name: name ?? this.name, notification: notification ?? this.notification, days: days ?? this.days);
}

  @override
  // TODO: implement props
  List<Object?> get props => [name,notification,days];
 }