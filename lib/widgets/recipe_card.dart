import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/recipes_controller.dart';
import 'package:Recipedia/models/recipe.dart';
import 'package:Recipedia/views/recipe_page.dart';

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
          Get.put(() => RecipesController(user: user));
        }
        await Get.to(() => RecipePage(
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
                  child: ListTile(
                    minLeadingWidth: 0,
                    dense: true,
                    leading: Container(
                      height: double.infinity,
                      child: Icon(Icons.camera_alt),
                    ),
                    title: Text(recipe.name, style: Get.theme.textTheme.bodyLarge),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('servings: ${recipe.servings.toString()}'),
                      RatingBarIndicator(
                        itemSize: 20,
                        rating: recipe.rating.toDouble(),
                        itemBuilder: (BuildContext context, int index) {
                          return Icon(
                            Icons.star,
                            color: Colors.yellow,
                          );
                        },
                      )
                    ]),
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
