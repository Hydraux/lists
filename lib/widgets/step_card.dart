import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/steps_controller.dart';
import 'package:lists/models/recipe.dart';

class StepCard extends StatelessWidget {
  const StepCard({required this.recipe, required this.index});

  final Recipe recipe;
  final int index; //step index

  @override
  Widget build(BuildContext context) {
    final StepsController ssc = Get.find<StepsController>();
    return GestureDetector(
      onTap: () async {
        if (recipe.editMode.value) {
          String step = await Get.toNamed('/RecipeList/Recipe/ModifyStep', arguments: [recipe, index]);
          ssc.updateStep(recipe, index, step);
        }
      },
      child: Card(
        color: Theme.of(context).secondaryHeaderColor,
        child: Row(
          children: [
            if (recipe.editMode.value)
              IconButton(
                onPressed: () => ssc.removeStep(recipe.steps[index]),
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
