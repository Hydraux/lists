import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes/recipes_controller.dart';
import 'package:lists/models/recipes/recipe.dart';
import 'package:lists/views/recipes/recipe_page.dart';

class RecipeCard extends StatelessWidget {
  final int index;
  final Recipe recipe;
  final controller = Get.find<RecipesController>();

  RecipeCard({required this.recipe, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!controller.editMode.value)
          await Get.to(() => RecipePage(recipe: recipe));
        //TODO: IMPLEMENT RECIPE MODIFICATION
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Stack(
            children: [
              if (controller.editMode.value)
                Positioned(
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          controller.removeRecipe(recipe);
                        },
                        icon: Icon(Icons.delete))),
              if (controller.editMode.value)
                Center(
                  child: TextField(
                    controller: recipe.controller!.recipeName!
                      ..text = recipe.name.string,
                    onSubmitted: (val) {
                      recipe.name.value = val;
                      controller.updateValue(recipe);
                      controller.editMode.value = false;
                    },
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(border: null),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (!controller.editMode.value)
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 55, 8, 8),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.add_a_photo),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(recipe.name.value.toString(),
                            style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
            ],
          )),
    );
  }
}
