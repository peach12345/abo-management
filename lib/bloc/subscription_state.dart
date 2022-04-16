part of 'subscription_bloc.dart';

@immutable
enum SubscriptionStatus { initial, loading, failure, success }

class SubscriptionState extends Equatable {
  const SubscriptionState(
      {this.name = "",
      this.homeSubscriptionList = const [],
      this.date = "",
      this.cancellationPeriod = 3,
      this.status = SubscriptionStatus.initial,
      this.costs = "",
      this.bankSubscriptionList = const [],
      this.carSubscriptionList = const []});

  final String name;
  final String date;
  final SubscriptionStatus status;
  final num cancellationPeriod;
  final String costs;
  final List<Subscription> homeSubscriptionList;

  final List<Subscription> bankSubscriptionList;
  final List<Subscription> carSubscriptionList;

  SubscriptionState copyWith(
      {String? name,
      List<Subscription>? homeSubscriptionList,
      List<Subscription>? bankSubscriptionList,
      List<Subscription>? carSubscriptionList,
      String? date,
      num? cancellationPeriod,
      SubscriptionStatus? status,
      String? costs}) {
    return SubscriptionState(
        name: name ?? this.name,
        homeSubscriptionList: homeSubscriptionList ?? this.homeSubscriptionList,
        date: date ?? this.date,
        cancellationPeriod: cancellationPeriod ?? this.cancellationPeriod,
        status: status ?? this.status,
        carSubscriptionList: carSubscriptionList ?? this.carSubscriptionList,
        bankSubscriptionList: bankSubscriptionList ?? this.bankSubscriptionList,
        costs: costs ?? this.costs);
  }

  @override
  List<Object?> get props => [
        name,
        homeSubscriptionList,
        bankSubscriptionList,
        carSubscriptionList,
        date,
        cancellationPeriod,
        status,
        costs
      ];
}
