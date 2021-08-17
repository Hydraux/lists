import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/item_controller.dart';
import 'package:lists/models/dialogue.dart';

class NewItem extends GetView<ItemController> {
  final TextEditingController textController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return NewDialogue(
      textController: textController,
      name: 'New Item',
      type: 'item',
      quantityController: quantityController,
    );
  }
}
