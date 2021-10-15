import 'package:flutter/material.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/widgets/list_reorderable.dart';
import 'package:lists/models/recipe.dart';

class IngredientList extends StatelessWidget {
  final Recipe recipe;

  const IngredientList({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListReorderable(parentObject: recipe),
              if (recipe.editMode.value)
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          recipe.controller!.addIngredient(context, recipe);
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
