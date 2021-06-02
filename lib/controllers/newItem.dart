import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/Item.dart';

class NewItemController extends GetxController {
  final itemName = TextEditingController();
  final itemQuantity = TextEditingController();

  Item makeItem() {
    Item newItem = new Item(name: itemName.text);
    return newItem;
  }
}
