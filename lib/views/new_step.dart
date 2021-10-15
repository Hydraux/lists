import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/widgets/forms/step_form.dart';

class NewStep extends GetView {
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StepForm();
  }
}
