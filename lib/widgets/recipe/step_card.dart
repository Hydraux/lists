import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/recipes/recipe.dart';

class StepCard extends StatelessWidget {
  const StepCard({required this.recipe, required this.index});

  final Recipe recipe;
  final int index; //step index

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (recipe.editMode.value) {
          String step = await Get.toNamed('/RecipeList/Recipe/ModifyStep',
              arguments: [recipe, index]);
          recipe.controller!.updateStep(recipe, index, step);
        }
      },
      child: Row(
        children: [
          if (recipe.editMode.value)
            IconButton(
              onPressed: () =>
                  recipe.controller!.removeStep(recipe, recipe.Steps[index]),
              icon: Icon(Icons.delete),
            ),
          Text(
            '   Step ${index + 1}: ',
            style: TextStyle(fontSize: 20),
          ),
          Flexible(
            flex: 3,
            child: Text(
              recipe.Steps[index],
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
