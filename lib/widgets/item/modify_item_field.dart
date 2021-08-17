import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/items/item.dart';

class ModifyItemField extends StatelessWidget {
  late final TextEditingController controller;
  final String name;
  final bool autofocus;
  final Item item;
  final suffix;

  ModifyItemField({
    required this.name,
    required this.autofocus,
    required this.item,
    required this.suffix,
  }) {
    controller = Get.find<TextEditingController>(tag: item.UID.toString());
  }

  TextInputType KeyboardType(String name) {
    if (name == 'Item Name') return TextInputType.text;
    return TextInputType.number;
  }

  @override
  Widget build(BuildContext context) {
    if (name == 'Item Name') controller.text = item.name.string;
    if (name == 'Quantity') controller.text = item.quantity.string;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: autofocus,
        keyboardType: KeyboardType('$name'),
        controller: controller,
        decoration: InputDecoration(
          labelText: '$name: ',
          border: OutlineInputBorder(),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
