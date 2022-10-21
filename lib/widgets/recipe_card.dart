import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_page.dart';

// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool local;
  final String user;
  final controller = Get.find<RecipesController>();

  RecipeCard({required this.recipe, required this.local, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          Get.find<RecipesController>(tag: user);
        } catch (e) {
          Get.lazyPut(() => RecipesController(user: user));
        }
        await Get.to(RecipePage(
          recipe: recipe,
          local: local,
          user: user,
        ));
      },
      child: Card(
        color: local ? Get.theme.cardColor : Get.theme.secondaryHeaderColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: local
              ? Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direciton) async {
                    Map JsonRecipe = await controller.removeRecipe(recipe);
                    Get.snackbar(
                      'Deleted',
                      '${recipe.name} removed from list',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Get.theme.cardColor,
                      mainButton: TextButton.icon(
                          onPressed: (() {
                            controller.uploadRecipe(JsonRecipe);
                            Get.closeCurrentSnackbar();
                          }),
                          icon: Icon(Icons.undo),
                          label: Text('Undo')),
                    );
                  },
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          recipe.name,
                          style: TextStyle(
                              backgroundColor: local ? context.theme.cardColor : context.theme.secondaryHeaderColor,
                              fontSize: 20,
                              color: context.theme.textTheme.bodyText1!.color),
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        recipe.name,
                        style: TextStyle(
                            backgroundColor: local ? context.theme.cardColor : context.theme.secondaryHeaderColor,
                            fontSize: 20,
                            color: context.theme.textTheme.bodyText1!.color),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
