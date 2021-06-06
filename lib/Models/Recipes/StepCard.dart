import 'package:flutter/material.dart';
import 'package:lists/Models/Recipes/Recipe.dart';

class StepCard extends StatelessWidget {
  const StepCard({required this.recipe, required this.index});

  final Recipe recipe;
  final int index; //step index

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Text(
          recipe.Steps[index],
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
