import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/views/new_unit.dart';

class ItemController extends GetxController {
  TextEditingController? itemName;
  TextEditingController? Quantity;
  Item? item;

  ItemController(this.item) {
    if (this.itemName == null) itemName = TextEditingController();
    if (this.Quantity == null) Quantity = TextEditingController();
  }

  Item makeItem(String name, int quantity, RxString unit) {
    Item newItem = new Item(name: name, unit: unit.string);
    newItem.quantity.value = quantity;
    return newItem;
  }
}
