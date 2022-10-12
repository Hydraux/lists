import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/steps_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/widgets/ingredient_list.dart';
import 'package:lists/widgets/step_list.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  RecipePage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    Get.put(ItemsController(tag: 'ingredients', recipe: recipe), tag: recipe.id);
    Get.put(StepsController(
        recipe: recipe,
        database:
            FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/recipes/${recipe.id}/steps')));
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Center(child: Text(recipe.name)),
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
                    IngredientList(recipe: recipe),
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
                  children: [StepList(recipe: recipe)],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.snackbar('Unimplemented Feature', 'Add Ingredients to Shopping List not Implemented');
          },
          child: Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }
}
