import 'package:get/get.dart';
import 'package:lists/controllers/items/item_controller.dart';

class Item {
  var name = ''.obs;
  var quantity = 1.obs;
  RxString unit = ''.obs;
  var UID;

  Item({
    required String input,
    required String unit,
  }) {
    if (UID == null) UID = DateTime.now().toString();
    this.name.value = input;
    this.unit.value = unit;
  }
}
