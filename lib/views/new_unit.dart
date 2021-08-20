import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items/item_controller.dart';
import 'package:lists/widgets/dialogue.dart';

class NewUnit extends GetView<ItemController> {
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return NewDialogue(
      textController: textController,
      name: 'New Unit',
      type: 'unit',
    );
  }
}
