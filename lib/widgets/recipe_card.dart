import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_page.dart';

// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  final int index;
  Recipe recipe;
  final controller = Get.find<RecipesController>();

  RecipeCard({required this.recipe, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!controller.editMode.value) await Get.to(() => RecipePage(recipe: recipe));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            controller.removeRecipe(recipe);
                          },
                          icon: Icon(Icons.delete))),
                ],
              ),
            ),
            Flexible(
                child: Text(
              recipe.name,
              style: TextStyle(backgroundColor: Get.theme.cardColor, fontSize: 20),
            ))
          ],
        ),
      ),
    );
  }
}
