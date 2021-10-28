import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/views/units_page.dart';
import 'package:lists/widgets/recipe_card.dart';

class RecipesPage extends GetView<RecipesController> {
  @override
  Widget build(BuildContext context) {
    return GetX<RecipesController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Recipes'),
          ),
          leading: IconButton(
            tooltip: 'Units',
            onPressed: () {
              Get.to(() => UnitsPage());
            },
            icon: Icon(Icons.adjust),
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
          shrinkWrap: true,
          itemCount: controller.recipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(
              recipe: controller.recipes[index],
              index: index,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        ),
      ),
    );
  }
}
