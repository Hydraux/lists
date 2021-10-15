import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/widgets/forms/step_form.dart';

class ModifyStep extends GetView {
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final Recipe recipe = args[0];
    final int index = args[1];
    return StepForm(
      recipe: recipe,
      index: index,
    );
  }
}
