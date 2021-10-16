import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/step_form.dart';

class StepCard extends StatelessWidget {
  const StepCard({required this.recipe, required this.index});

  final Recipe recipe;
  final int index; //step index

  @override
  Widget build(BuildContext context) {
    final RecipesController rsc = Get.find<RecipesController>();
    final List<String> tempSteps = recipe.steps;
    return GestureDetector(
      onTap: () async {
        if (recipe.editMode.value) {
          String step = await Get.to(StepForm(
            recipe: recipe,
            index: index,
          ));
          tempSteps[index] = step;
          recipe.copyWith(steps: tempSteps);
        }
      },
      child: Card(
        color: Theme.of(context).secondaryHeaderColor,
        child: Row(
          children: [
            if (recipe.editMode.value)
              IconButton(
                onPressed: () => rsc.removeStep(recipe, recipe.steps[index]),
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
                recipe.steps[index],
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
