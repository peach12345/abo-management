import 'package:hive/hive.dart';

part 'subscription.g.dart';

@HiveType(typeId: 0)
class Subscription extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late bool notification;

  @HiveField(2)
  late int days;

  @HiveField(3)
  late DateTime date;

  Subscription({required this.name,required this.notification,required this.days});
}
