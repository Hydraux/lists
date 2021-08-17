import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/dialogue.dart';

class NewStep extends GetView {
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return NewDialogue(
        textController: textController, name: 'New Step', type: 'step');
  }
}
