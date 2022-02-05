import 'package:androidapp/model/subscription.dart';
import 'package:hive/hive.dart';

class DatabaseService  {
  void saveObject(Subscription insurance) async {
    var box = await Hive.openBox('insurance');
    box.add(insurance);
  }

  Future<Subscription> getObject()  async {
    var box = await Hive.openBox('insurance');
    return box.getAt(0);
  }
}
