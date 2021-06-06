import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Pages/Recipes/RecipeCard.dart';
import 'package:lists/controllers/Recipes/Recipes.dart';

class RecipesPage extends GetView<RecipesController> {
  @override
  Widget build(BuildContext context) {
    return GetX<RecipesController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Recipes'),
          ),
          actions: [
            IconButton(
              onPressed: () {
                controller.editMode.toggle();
              },
              icon: Icon(Icons.edit),
              color: controller.editMode.value ? Colors.yellow : null,
            )
          ],
        ),
        body: GridView.builder(
          itemCount: controller.RecipeListLength,
          itemBuilder: (context, index) {
            return RecipeCard(
              recipe: controller.RecipeList[index],
              index: index,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
        ),
        floatingActionButton: controller.getFloatingActionButton(),
      ),
    );
  }
}
