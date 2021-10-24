import 'package:flutter/cupertino.dart';
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
    Get.put(StepsController(recipe: recipe));
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
                    color: Theme.of(context).cardColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ExpansionTile(
                  collapsedBackgroundColor: Theme.of(context).cardColor,
                  iconColor: Theme.of(context).colorScheme.onBackground,
                  textColor: Theme.of(context).colorScheme.onBackground,
                  collapsedTextColor: Theme.of(context).textTheme.bodyText1!.color,
                  collapsedIconColor: Theme.of(context).textTheme.bodyText1!.color,
                  backgroundColor: Theme.of(context).cardColor,
                  title: Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Divider(
                      color: Theme.of(context).secondaryHeaderColor,
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
                    color: Theme.of(context).cardColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ExpansionTile(
                  collapsedBackgroundColor: Theme.of(context).cardColor,
                  iconColor: Theme.of(context).textTheme.bodyText1!.color,
                  textColor: Theme.of(context).textTheme.bodyText1!.color,
                  collapsedTextColor: Theme.of(context).textTheme.bodyText1!.color,
                  collapsedIconColor: Theme.of(context).textTheme.bodyText1!.color,
                  backgroundColor: Theme.of(context).cardColor,
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
      ),
    );
  }
}
