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

class DateChanged extends SubscriptionEvent{
  const DateChanged(this.date);
  final String date;

  @override
  List<Object?> get props => [date];
}


class SubscriptionSubmitted extends SubscriptionEvent{

}

class NotificationChanged extends SubscriptionEvent{
  const NotificationChanged(this.notification);
  final bool notification;

  @override
  List<Object?> get props => [notification];
}



