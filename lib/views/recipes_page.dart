import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';

class RecipesPage extends GetView<RecipesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Recipes'),
        ),
      ),
      body: Obx(() => controller.recipeWidgets.isNotEmpty
          ? ListView(shrinkWrap: true, children: controller.recipeWidgets)
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Press',
                  style: TextStyle(
                    fontSize: 20,
                    color: context.theme.bottomNavigationBarTheme.unselectedItemColor,
                  ),
                ),
                Text(
                  '+',
                  style: TextStyle(
                    fontSize: 20,
                    color: context.theme.bottomNavigationBarTheme.unselectedItemColor,
                  ),
                ),
                Text(
                  'to add a recipe',
                  style: TextStyle(
                    fontSize: 20,
                    color: context.theme.bottomNavigationBarTheme.unselectedItemColor,
                  ),
                ),
              ],
            ))),
    );
  }
}
