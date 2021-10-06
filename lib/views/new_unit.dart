import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/controllers/items/item_controller.dart';
import 'package:lists/widgets/forms/unit_form.dart';

class NewUnit extends GetView<ItemController> {
  @override
  Widget build(BuildContext context) {
    Item? item = Get.arguments;
    return UnitForm(item: item);
  }
}
