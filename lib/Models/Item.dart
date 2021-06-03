import 'package:get/get.dart';
import 'package:lists/controllers/Item.dart';

class Item {
  ItemController? controller;
  var name = ''.obs;
  var quantity = 0.obs;
  var UID;

  Item({required String input}) {
    controller = Get.put(ItemController(), tag: UID);
    this.name.value = input;
  }
}
