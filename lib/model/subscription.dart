import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class Subscription extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(3)
  late String date;

  Subscription({required this.name, required this.date});
}
