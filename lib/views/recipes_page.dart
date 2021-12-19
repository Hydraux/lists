import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/widgets/recipe_card.dart';

class RecipesPage extends GetView<RecipesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Recipes'),
        ),
      ),
      body: StreamBuilder<Object>(
          stream: controller.database.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.data! as DatabaseEvent).snapshot.value != null) {
                Map<dynamic, dynamic> map = (snapshot.data as DatabaseEvent).snapshot.value as Map;
                List<dynamic> list = map.values.toList();
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                      recipe: Recipe.fromJson(list[index]),
                      index: index,
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Press',
                        style: TextStyle(
                          fontSize: 20,
                          color: Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                        ),
                      ),
                      Text(
                        '+',
                        style: TextStyle(
                          fontSize: 20,
                          color: Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                        ),
                      ),
                      Text(
                        'to add a recipe',
                        style: TextStyle(
                          fontSize: 20,
                          color: Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
