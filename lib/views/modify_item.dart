import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/item.dart';
import 'package:lists/widgets/forms/item_form.dart';

class ModifyItem extends GetView {
  Widget build(BuildContext context) {
    Item item = Get.arguments;
    return ItemForm(
      item: item,
      type: 'Modify',
    );
  }
}
