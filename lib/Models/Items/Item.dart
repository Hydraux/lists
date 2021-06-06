import 'package:get/get.dart';
import 'package:lists/controllers/Items/Item.dart';

class Item {
  ItemController? controller;
  var name = ''.obs;
  var quantity = 1.obs;
  var UID;

  Item({required String input}) {
    if (UID == null) UID = DateTime.now().toString();
    this.controller = Get.put(ItemController(this), tag: UID);
    this.name.value = input;
  }
}
