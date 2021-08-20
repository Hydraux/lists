import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes/recipes_controller.dart';
import 'package:lists/models/recipes/recipe.dart';
import 'package:lists/widgets/recipe/ingredient_list.dart';
import 'package:lists/widgets/recipe/step_list.dart';

class RecipePage extends GetView<RecipesController> {
  final Recipe recipe;

  RecipePage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GetX<RecipesController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Center(child: Text(recipe.name.string)),
          actions: [
            IconButton(
                onPressed: () {
                  recipe.editMode.toggle();
                },
                color: recipe.editMode.value ? Colors.yellow : null,
                icon: Icon(Icons.edit))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              IngredientList(recipe: recipe, controller: controller),
              StepList(recipe: recipe, controller: controller)
            ],
          ),
        ),
        floatingActionButton:
            recipe.controller!.getFloatingActionButton(recipe, context),
      ),
    );
  }
}