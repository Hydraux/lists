import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Item.dart';

class ItemController extends GetxController {
  TextEditingController? itemName;
  Item? item;

  ItemController() {
    if (this.itemName == null) itemName = TextEditingController();
  }

  void increment() => item!.quantity.value++;
  void decrement() => item!.quantity.value--;

  Item makeItem(String name) {
    Item newItem = new Item(input: name);
    return newItem;
  }
}
