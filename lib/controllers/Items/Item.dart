import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Items/Item.dart';
import 'package:lists/Pages/newUnit.dart';

class ItemController extends GetxController {
  TextEditingController? itemName;
  TextEditingController? Quantity;
  Item? item;

  ItemController(this.item) {
    if (this.itemName == null) itemName = TextEditingController();
    if (this.Quantity == null) Quantity = TextEditingController();
  }

  void increment() => item!.quantity.value++;
  void decrement() => item!.quantity.value--;

  Item makeItem(String name, int quantity, RxString unit) {
    if (unit.string == 'New...') {
      Get.to(NewUnit());
    }
    Item newItem = new Item(input: name, unit: unit.string);
    newItem.quantity.value = quantity;
    return newItem;
  }
}
