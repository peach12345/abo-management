part of 'subscription_bloc.dart';

@immutable
class SubscriptionEvent extends Equatable  {
  const SubscriptionEvent();
  @override
  List<Object?> get props => [];
}

class NameChanged extends SubscriptionEvent{
  const NameChanged(this.name);
  final String name;
  
  @override
  List<Object?> get props => [name];
}

class DaysChanged extends SubscriptionEvent{
  const DaysChanged(this.days);
  final num days;

  @override
  List<Object?> get props => [days];
}

class NotificationChanged extends SubscriptionEvent{
  const NotificationChanged(this.notification);
  final bool notification;

  @override
  List<Object?> get props => [notification];
}


class SubscriptionSubmitted extends SubscriptionEvent{
  @override
  List<Object?> get props => [];
}
