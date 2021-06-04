import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Recipe.dart';
import 'package:lists/Pages/Recipe.dart';
import 'package:lists/controllers/Recipes.dart';

class RecipeCard extends StatelessWidget {
  final RecipesController recipesController;

  final int index;
  final Recipe recipe;

  RecipeCard(
      {required this.recipe,
      required this.index,
      required this.recipesController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() =>
            RecipePage(recipe: recipe, recipesController: recipesController));
        // controller.updateValue(index);
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => Text(recipe.name.value.toString(),
                      style: TextStyle(fontSize: 20))),
                ),
              ),
            ],
          )),
    );
  }
}
