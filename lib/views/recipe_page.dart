import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/controllers/steps_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/widgets/ingredient_list.dart';
import 'package:lists/widgets/step_list.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  final bool local;
  final String user;

  RecipePage({required this.recipe, required this.local, required this.user}) {
    recipe.editMode.value = false;
  }

  @override
  Widget build(BuildContext context) {
    RecipesController controller;
    try {
      controller = Get.find<RecipesController>(tag: user);
    } catch (e) {
      controller = RecipesController(user: FirebaseAuth.instance.currentUser!.uid);
    }
    Get.put(ItemsController(tag: 'ingredients', recipe: recipe, user: user), tag: recipe.id);
    Get.put(
        StepsController(recipe: recipe, database: FirebaseDatabase.instance.ref('${user}/recipes/${recipe.id}/steps')));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(recipe.name),
        actions: local == true
            ? [
                Obx(
                  () => IconButton(
                      onPressed: () {
                        recipe.editMode.toggle();
                      },
                      color: recipe.editMode.value ? Colors.yellow : null,
                      icon: Icon(Icons.edit)),
                )
              ]
            : [
                IconButton(
                    onPressed: () {
                      controller.storeLocally(recipe);
                      try {
                        Get.find<RecipesController>(tag: FirebaseAuth.instance.currentUser!.uid);
                      } catch (e) {
                        Get.lazyPut(() => RecipesController(user: FirebaseAuth.instance.currentUser!.uid),
                            tag: FirebaseAuth.instance.currentUser!.uid);
                      }
                      Get.off(
                          () => RecipePage(
                                local: true,
                                recipe: recipe,
                                user: FirebaseAuth.instance.currentUser!.uid,
                              ),
                          preventDuplicates: false,
                          transition: Transition.rightToLeft);

                      Get.snackbar(
                        'Saved',
                        'A copy of recipe has been saved to your account',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Get.theme.cardColor,
                      );
                    },
                    icon: Icon(
                      Icons.save,
                      color: Colors.green,
                    ))
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.theme.cardColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ExpansionTile(
                collapsedBackgroundColor: context.theme.cardColor,
                iconColor: context.theme.colorScheme.onBackground,
                textColor: context.theme.colorScheme.onBackground,
                collapsedTextColor: context.theme.textTheme.bodyText1!.color,
                collapsedIconColor: context.theme.textTheme.bodyText1!.color,
                backgroundColor: context.theme.cardColor,
                title: Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  Divider(
                    color: context.theme.secondaryHeaderColor,
                    thickness: 2,
                  ),
                  IngredientList(recipe: recipe, local: local),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.theme.cardColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ExpansionTile(
                collapsedBackgroundColor: context.theme.cardColor,
                iconColor: context.theme.textTheme.bodyText1!.color,
                textColor: context.theme.textTheme.bodyText1!.color,
                collapsedTextColor: context.theme.textTheme.bodyText1!.color,
                collapsedIconColor: context.theme.textTheme.bodyText1!.color,
                backgroundColor: context.theme.cardColor,
                title: Text(
                  "Instructions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  StepList(
                    recipe: recipe,
                    user: user,
                    local: local,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: local
          ? FloatingActionButton(
              onPressed: () {
                Get.snackbar('Added!', 'checked ingredients added to shopping list',
                    snackPosition: SnackPosition.BOTTOM, backgroundColor: Get.theme.cardColor);
                controller.addToShoppingList(recipe);
              },
              child: Icon(Icons.add_shopping_cart),
            )
          : null,
    );
  }
}
