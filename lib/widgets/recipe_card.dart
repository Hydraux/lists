import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_page.dart';

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
                  if (controller.editMode.value)
                    Positioned(
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              controller.removeRecipe(recipe);
                              controller.editMode.toggle();
                            },
                            icon: Icon(Icons.delete))),
                  if (controller.editMode.value)
                    Positioned(
                        left: 0,
                        child: IconButton(
                          onPressed: () async {
                            XFile? image = await controller.pickImage(ImageSource.gallery);
                            if (image != null) {
                              recipe = recipe.copyWith(image: File(image.path));
                              controller.updateStorage(recipe);
                            }
                            controller.editMode.toggle();
                          },
                          icon: Icon(Icons.photo),
                        )),
                  if (!controller.editMode.value)
                    Center(
                        child: recipe.image == null
                            ? IconButton(
                                onPressed: () async {
                                  XFile? image = await controller.pickImage(ImageSource.gallery);
                                  if (image != null) {
                                    recipe = recipe.copyWith(image: File(image.path));
                                    controller.updateStorage(recipe);
                                  }
                                },
                                icon: Icon(Icons.add_a_photo),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                child: Container(
                                  foregroundDecoration: BoxDecoration(
                                      image: DecorationImage(image: FileImage(recipe.image!), fit: BoxFit.fill)),
                                ),
                              )),
                ],
              ),
            ),
            Flexible(
                child: Text(
              recipe.name,
              style: TextStyle(backgroundColor: Theme.of(context).cardColor, fontSize: 20),
            ))
          ],
        ),
      ),
    );
  }
}
