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
    recipe.steps.add(step);

    storageList.write('steps:${recipe.uniqueID}', recipe.steps);
  }

  void updateStep(Recipe recipe, int index, String step) {
    recipe.steps[index] = step;

    storageList.write('steps:${recipe.uniqueID}', recipe.steps);
  }

  void removeStep(Recipe recipe, String step) {
    recipe.steps.remove(step);

    storageList.write('steps:${recipe.uniqueID}', recipe.steps);
  }

  void restoreSteps(Recipe recipe) {
    if (storageList.hasData('steps:${recipe.uniqueID}')) {
      var tempStepsList = storageList.read('steps:${recipe.uniqueID}');
      for (String step in tempStepsList) recipe.steps.add(step);
    }
  }

  //add and update new ingredient
  Future<void> addIngredient(context, Recipe recipe) async {
    Item? item = new Item(name: 'Item Name', unit: '');
    item = await Get.toNamed('/shoppingList/newItem', arguments: item);
    if (item == null) return; //cancel was pressed
    final storageMap = {};
    final nameKey = 'name';
    final quantityKey = 'quantity';
    final uniqueIDKey = 'uniqueID';
    final unitKey = 'unit';

    storageMap[nameKey] = item.name.value;
    storageMap[quantityKey] = item.quantity.value;
    storageMap[uniqueIDKey] = item.uniqueID;
    storageMap[unitKey] = item.unit.value;

    recipe.ingredients.add(item);
    tempIngredientList.add(storageMap);

    storageList.write('Ingredients:${recipe.uniqueID}', tempIngredientList);
  }

  void removeIngredient(Recipe recipe, Item ingredient) {
    final uniqueIDKey = 'uniqueID';

    recipe.ingredients
        .removeWhere((element) => element.uniqueID == ingredient.uniqueID);
    tempIngredientList
        .removeWhere((element) => element[uniqueIDKey] == ingredient.uniqueID);

    storageList.write('Ingredients:${recipe.uniqueID}', tempIngredientList);
  }

  void restoreIngredients(Recipe recipe) {
    String nameKey;
    String quantityKey;
    String uniqueIDKey;
    String unitKey;

    if (storageList.hasData('Ingredients:${recipe.uniqueID}')) {
      tempIngredientList.value =
          storageList.read('Ingredients:${recipe.uniqueID}');

      for (int i = 0; i < tempIngredientList.length; i++) {
        final map = tempIngredientList[i];

        nameKey = 'name';
        quantityKey = 'quantity';
        unitKey = 'unit';
        uniqueIDKey = 'uniqueID';

        final item = Item(name: map[nameKey], unit: map[unitKey]);
        item.quantity.value = map[quantityKey];
        item.uniqueID = map[uniqueIDKey];

        recipe.ingredients.add(item);
      }
    }
  }

  void updateIngredient(Item item) {
    final storageMap = {};
    final nameKey = 'name';
    final quantityKey = 'quantity';
    final unitKey = 'unit';
    final uniqueIDKey = 'uniqueID';

    storageMap[nameKey] = item.name.value;
    storageMap[quantityKey] = item.quantity.value;
    storageMap[uniqueIDKey] = item.uniqueID;
    storageMap[unitKey] = item.unit.value;

    int index = tempIngredientList
        .indexWhere((element) => element[uniqueIDKey] == item.uniqueID);
    tempIngredientList[index] = storageMap;

    storageList.write('Ingredients:${item.uniqueID}', tempIngredientList);
  }

  FloatingActionButton? getFloatingActionButton(Recipe recipe, context) {
    if (!recipe.editMode.value)
      return FloatingActionButton(
        onPressed: () {
          final snackBar = SnackBar(
              content: Text('Add to shopping list not yet implemented'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Icon(Icons.add_shopping_cart),
      );
    return null;
  }
}
