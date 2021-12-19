import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/steps_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/step_form.dart';

class StepCard extends StatelessWidget {
  StepCard({required this.recipe, required this.step, required this.index});

  final Recipe recipe;
  final String step;
  final int index; //step index

  @override
  Widget build(BuildContext context) {
    final StepsController controller = Get.find<StepsController>();
    return GestureDetector(
      onTap: () async {
        //TODO: implement modify step
        controller.modifyStep(step, index);
      },
      child: Card(
        color: Get.theme.secondaryHeaderColor,
        child: Row(
          children: [
            if (recipe.editMode.value)
              IconButton(
                onPressed: () => controller.removeStep(step),
                icon: Icon(Icons.delete),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '   Step ${index + 1}: ',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Flexible(
              flex: 3,
              child: Text(
                step,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
