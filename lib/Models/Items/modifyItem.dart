import 'package:flutter/material.dart';
import 'package:lists/Models/Items/Item.dart';

class ModifyItemField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final bool autofocus;
  final Item item;
  ModifyItemField(
      {required this.controller,
      required this.name,
      required this.autofocus,
      required this.item});

  TextInputType KeyboardType(String name) {
    if (name == 'Item Name') return TextInputType.text;
    return TextInputType.number;
  }

  @override
  Widget build(BuildContext context) {
    controller.text = item.name.string;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: autofocus,
        keyboardType: KeyboardType('$name'),
        controller: controller,
        decoration: InputDecoration(
          labelText: '$name: ',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
