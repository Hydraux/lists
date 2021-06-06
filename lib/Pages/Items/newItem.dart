import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Dialogue.dart';
import 'package:lists/controllers/Items/Item.dart';

class NewItem extends GetView<ItemController> {
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return NewDialogue(
        textController: textController, name: 'New Item', type: 'item');
  }
}
