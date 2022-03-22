import 'package:hive/hive.dart';

part 'subscription.g.dart';

@HiveType(typeId: 0)
class Subscription extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String date;

  @HiveField(2)
  late num cancellationPeriod;

  @HiveField(3)
  late num costs;



  Subscription({required this.name, required this.date,required this.cancellationPeriod,required this.costs
  });
}
