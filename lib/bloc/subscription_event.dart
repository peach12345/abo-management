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

class SeletedSubscriptionListChanged extends SubscriptionEvent{
  const SeletedSubscriptionListChanged(this.selectedList);
  final String selectedList;

  @override
  List<Object?> get props => [selectedList];

}

class DateChanged extends SubscriptionEvent{
  const DateChanged(this.date);
  final String date;

  @override
  List<Object?> get props => [date];
}

class CancellationPeriodChanged extends SubscriptionEvent{
  const CancellationPeriodChanged(this.cancellationPeriod);
  final num cancellationPeriod;

  @override
  List<Object?> get props => [cancellationPeriod];
}

class CostMonthlyChanged extends SubscriptionEvent{
  const CostMonthlyChanged(this.costs);
  final String costs;

  @override
  List<Object?> get props => [costs];
}


class SubscriptionSubmitted extends SubscriptionEvent{
}


class SubscriptionInitial extends SubscriptionEvent{

}

class NotificationChanged extends SubscriptionEvent{
  const NotificationChanged(this.notification);
  final bool notification;

  @override
  List<Object?> get props => [notification];
}

class DeleteSubscription extends SubscriptionEvent{
  const DeleteSubscription(this.name);
  final String name;

  @override
  List<Object?> get props => [name];
}



