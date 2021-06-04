import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Pages/RecipeCard.dart';
import 'package:lists/controllers/Recipes.dart';

class RecipesPage extends GetView<RecipesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Recipes'),
        ),
      ),
      body: GridView.builder(
        itemCount: controller.RecipeListLength,
        itemBuilder: (context, index) {
          return RecipeCard(
            recipe: controller.RecipeList[index],
            index: index,
            recipesController: controller,
          );
        },
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addRecipe(context);
        },
        child: Icon(Icons.add),
        heroTag: RecipesPage,
      ),
    );
  }
}
