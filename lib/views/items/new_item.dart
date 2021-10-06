import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/widgets/forms/item_form.dart';

class NewItem extends GetView {
  Widget build(BuildContext context) {
    Item item = Get.arguments;
    return ItemForm(item: item, type: 'New');
  }
}
