import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/items_controller.dart';
import 'package:Recipedia/controllers/recipes_controller.dart';
import 'package:Recipedia/controllers/steps_controller.dart';
import 'package:Recipedia/models/recipe.dart';
import 'package:Recipedia/widgets/ingredient_list.dart';
import 'package:Recipedia/widgets/step_list.dart';

class RecipePage extends GetView<RecipesController> {
  final Recipe recipe;
  final bool local;
  final String user;

  RecipePage({required this.recipe, required this.local, required this.user}) {
    recipe.editMode.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController servingsController = TextEditingController(text: recipe.servings.toString());
    final TextEditingController cookTimeController = TextEditingController(text: recipe.cookTime);
    final TextEditingController prepTimeController = TextEditingController(text: recipe.prepTime);
    final TextEditingController notesController = TextEditingController(text: recipe.notes);

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
                initiallyExpanded: true,
                collapsedBackgroundColor: context.theme.cardColor,
                iconColor: context.theme.colorScheme.onBackground,
                textColor: context.theme.colorScheme.onBackground,
                collapsedTextColor: context.theme.textTheme.bodyText1!.color,
                collapsedIconColor: context.theme.textTheme.bodyText1!.color,
                backgroundColor: context.theme.cardColor,
                title: Text(
                  "Info",
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Servings:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: Get.theme.textTheme.bodyText1!.color),
                        ),
                        Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Container(
                            color: Colors.white,
                            child: IntrinsicWidth(
                              child: TextField(
                                readOnly: !local,
                                controller: servingsController,
                                onChanged: (String value) => controller.changeNumServings(value, recipe),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    hintText: 'err null value',
                                    hintStyle: TextStyle(color: Colors.black),
                                    constraints: BoxConstraints(maxWidth: 200, minWidth: 30),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Cook time:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: Get.theme.textTheme.bodyText1!.color),
                        ),
                        Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Container(
                            color: Colors.white,
                            child: IntrinsicWidth(
                              child: TextField(
                                readOnly: !local,
                                controller: cookTimeController,
                                onChanged: (String value) => controller.changeCookTime(value, recipe),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    hintText: 'err null value',
                                    hintStyle: TextStyle(color: Colors.black),
                                    constraints: BoxConstraints(maxWidth: 200, minWidth: 30),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Prep Time:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: Get.theme.textTheme.bodyText1!.color),
                        ),
                        Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Container(
                            color: Colors.white,
                            child: IntrinsicWidth(
                              child: TextField(
                                readOnly: !local,
                                controller: prepTimeController,
                                onChanged: (String value) => controller.changePrepTime(value, recipe),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    hintText: 'err null value',
                                    hintStyle: TextStyle(color: Colors.black),
                                    constraints: BoxConstraints(maxWidth: 200, minWidth: 30),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Center(
                          child: Text(
                            "Notes",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500, color: Get.theme.textTheme.bodyText1!.color),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Container(
                            color: Colors.white,
                            child: TextField(
                              maxLines: null,
                              readOnly: !local,
                              controller: notesController,
                              onChanged: (String value) => controller.changeNotes(value, recipe),
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  constraints: BoxConstraints(maxWidth: 200, minWidth: 30),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Rating',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500, color: Get.theme.textTheme.bodyText1!.color),
                        ),
                        RatingBar(
                          initialRating: recipe.rating.toDouble(),
                          ratingWidget: RatingWidget(
                            empty: Icon(Icons.star_border),
                            half: Icon(Icons.star_half),
                            full: Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ),
                          onRatingUpdate: (double value) {
                            controller.changeRating(value, recipe);
                          },
                        ),
                      ],
                    ),
                  ),
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
                initiallyExpanded: true,
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
                initiallyExpanded: true,
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
