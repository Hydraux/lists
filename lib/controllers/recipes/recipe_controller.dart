import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/models/recipes/recipe.dart';

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

  Future<void> addStep(context, Recipe recipe) async {
    var step = await Get.toNamed('/RecipeList/Recipe/newStep');
    if (step == null) return; //cancel was pressed
    recipe.Steps.add(step);

    storageList.write('Steps:${recipe.UID}', recipe.Steps);
  }

  void removeStep(Recipe recipe, String step) {
    final UIDKey = 'UID';

    recipe.Steps.remove(step);

    storageList.write('Steps:${recipe.UID}', recipe.Steps);
  }

  void restoreSteps(Recipe recipe) {
    if (storageList.hasData('Steps:${recipe.UID}')) {
      var tempStepsList = storageList.read('Steps:${recipe.UID}');
      for (String step in tempStepsList) recipe.Steps.add(step);
    }
  }

  //add and update new ingredient
  Future<void> addIngredient(context, Recipe recipe) async {
    Item? item = new Item(name: 'Item Name', unit: 'Unit');
    item = await Get.toNamed('/shoppingList/newItem', arguments: item);
    final storageMap = {};
    final nameKey = 'name';
    final quantityKey = 'quantity';
    final UIDKey = 'UID';
    final unitKey = 'unit';

    if (item == null) return; //cancel was pressed
    storageMap[nameKey] = item.name.value;
    storageMap[quantityKey] = item.quantity.value;
    storageMap[UIDKey] = item.UID;
    storageMap[unitKey] = item.unit.value;

    recipe.Ingredients.add(item);
    tempIngredientList.add(storageMap);

    storageList.write('Ingredients:${recipe.UID}', tempIngredientList);
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
    String unitKey;

    if (storageList.hasData('Ingredients:${recipe.UID}')) {
      tempIngredientList.value = storageList.read('Ingredients:${recipe.UID}');

      for (int i = 0; i < tempIngredientList.length; i++) {
        final map = tempIngredientList[i];
        final index = i;

        nameKey = 'name';
        quantityKey = 'quantity';
        unitKey = 'unit';
        UIDKey = 'UID';

        final item = Item(name: map[nameKey], unit: map[unitKey]);
        item.quantity.value = map[quantityKey];
        item.UID = map[UIDKey];

        recipe.Ingredients.add(item);
      }
    }
  }

  FloatingActionButton? getFloatingActionButton(Recipe recipe, context) {
    if (!recipe.editMode.value)
      return FloatingActionButton(
        onPressed: () {
          //TODO: Implement add ingredients to cart
          final snackBar = SnackBar(
              content: Text('Add to shopping list not yet implemented'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Icon(Icons.add_shopping_cart),
      );
    return null;
  }
}
