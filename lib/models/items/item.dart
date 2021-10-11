import 'package:get/get.dart';

class Item {
  var name = ''.obs;
  var quantity = 1.obs;
  RxString unit = ''.obs;
  var uniqueID;

  Item({
    required String name,
    required String unit,
  }) {
    if (uniqueID == null) uniqueID = DateTime.now().toString();
    this.name.value = name;
    this.unit.value = unit;
  }
}
