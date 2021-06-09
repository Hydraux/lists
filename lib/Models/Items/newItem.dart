import 'package:flutter/material.dart';

class NewItemField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final bool autofocus;
  final suffix;
  NewItemField(
      {required this.controller,
      required this.name,
      required this.autofocus,
      required this.suffix});

  TextInputType KeyboardType(String name) {
    if (name == 'New Item' || name == 'New Recipe' || name == 'New Step')
      return TextInputType.text;
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
          suffixIcon: suffix,
        ),
      ),
    );
  }
}