import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Models/Items/Item.dart';
import 'package:lists/Models/Recipes/Recipe.dart';

class RecipeController extends GetxController {
  final storageList = GetStorage();
  TextEditingController? recipeName;
  var tempIngredientList = [].obs;
  RecipeController() {
    if (this.recipeName == null) recipeName = TextEditingController();
  }

  Recipe makeRecipe(String name) {
    Recipe newRecipe = new Recipe(
      input: name,
    );
    return newRecipe;
  }

  //add and update new ingredient
  Future<void> addIngredient(context, Recipe recipe) async {
    final item = await Get.toNamed('/shoppingList/newItem');
    final storageMap = {};
    final nameKey = 'name';
    final quantityKey = 'quantity';
    final UIDKey = 'UID';

    if (item == null) return; //cancel was pressed
    storageMap[nameKey] = item.name.value;
    storageMap[quantityKey] = item.quantity.value;
    storageMap[UIDKey] = item.UID;

    recipe.Ingredients.add(item);
    tempIngredientList.add(storageMap);
  }

  void removeIngredient(Recipe recipe, Item ingredient) {
    final UIDKey = 'UID';

    recipe.Ingredients.removeWhere((element) => element.UID == ingredient.UID);
    tempIngredientList
        .removeWhere((element) => element[UIDKey] == ingredient.UID);

    storageList.write('Ingredients:${recipe.UID}', tempIngredientList);
  }

  void restoreIngredients(Recipe recipe) {
    String nameKey;
    String quantityKey;
    String UIDKey;

    if (storageList.hasData('Ingredients:${recipe.UID}')) {
      tempIngredientList.value = storageList.read('Ingredients:${recipe.UID}');

      for (int i = 0; i < tempIngredientList.length; i++) {
        final map = tempIngredientList[i];
        final index = i;

        nameKey = 'name';
        quantityKey = 'quantity';
        UIDKey = 'UID';

        final item = Item(input: map[nameKey]);
        item.quantity.value = map[quantityKey];
        item.UID = map[UIDKey];

        recipe.Ingredients.add(item);
      }
    }
  }
}
