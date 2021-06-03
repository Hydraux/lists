import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Item.dart';
import 'package:lists/controllers/Item.dart';
import 'package:lists/controllers/shoppingList.dart';

class ModifyItemField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final bool autofocus;
  ModifyItemField(
      {required this.controller, required this.name, required this.autofocus});

  TextInputType KeyboardType(String name) {
    if (name == 'Item Name') return TextInputType.text;
    return TextInputType.number;
  }

  @override
  Widget build(BuildContext context) {
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
