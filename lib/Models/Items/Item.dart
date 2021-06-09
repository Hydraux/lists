import 'package:get/get.dart';
import 'package:lists/controllers/Items/Item.dart';

class Item {
  ItemController? controller;
  var name = ''.obs;
  var quantity = 1.obs;
  RxString unit = ''.obs;
  var UID;

  Item({
    required String input,
    required String unit,
  }) {
    if (UID == null) UID = DateTime.now().toString();
    this.controller = Get.put(ItemController(this), tag: UID);
    this.name.value = input;
    this.unit.value = unit;
  }
}
