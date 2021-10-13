import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/models/unit.dart';

class ItemController extends GetxController {
  TextEditingController? itemName;
  TextEditingController? quantity;
  Item? item;

  ItemController(this.item) {
    if (this.itemName == null) itemName = TextEditingController();
    if (this.quantity == null) quantity = TextEditingController();
  }

  Item makeItem(String name, int quantity, Unit unit) {
    Item newItem = new Item(name: name, unit: unit);
    newItem.quantity = quantity;
    return newItem;
  }
}
