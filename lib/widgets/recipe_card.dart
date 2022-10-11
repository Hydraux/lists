import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_page.dart';

// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  Recipe recipe;
  final controller = Get.find<RecipesController>();

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direciton) => controller.removeRecipe(recipe),
          background: Container(
            color: Theme.of(Get.context!).errorColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ),
          child: GestureDetector(
              onTap: () async {
                await Get.to(RecipePage(recipe: recipe));
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      recipe.name,
                      style: TextStyle(
                          backgroundColor: Get.theme.cardColor,
                          fontSize: 20,
                          color: Get.theme.textTheme.bodyText1!.color),
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
