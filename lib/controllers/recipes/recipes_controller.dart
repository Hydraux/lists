import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/recipes/recipe.dart';

class RecipesController extends GetxController {
  final storageList = GetStorage();

  List tempList = [];
  List<Recipe> recipeList = [];

  var editMode = false.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    restoreRecipes();
  }

  int get recipeListLength => recipeList.length;

  void addRecipe() async {
    final recipe = await Get.toNamed('/RecipeList/newRecipe');
    final storageMap = {};
    final nameKey = 'name';
    final uniqueIDKey = 'uniqueID';

    if (recipe == null) return; //cancel was pressed
    storageMap[nameKey] = recipe.name.value;
    storageMap[uniqueIDKey] = recipe.uniqueID;

    tempList.add(storageMap);
    storageList.write('RecipeList', tempList);
    recipeList.add(recipe);
  }

  void updateValue(Recipe recipe) {
    final storageMap = {};
    final nameKey = 'name';
    final uniqueIDKey = 'uniqueID';

    storageMap[nameKey] = recipe.name.string;
    storageMap[uniqueIDKey] = recipe.uniqueID;

    int index = tempList
        .indexWhere((element) => element[uniqueIDKey] == recipe.uniqueID);
    tempList[index] = storageMap;

    storageList.write('RecipeList', tempList);
  }

  void removeRecipe(Recipe recipe) {
    final uniqueIDKey = 'uniqueID';

    recipeList.removeWhere((element) => element.uniqueID == recipe.uniqueID);
    tempList.removeWhere((element) => element[uniqueIDKey] == recipe.uniqueID);

    storageList.write('RecipeList', tempList);
  }

  void restoreRecipes() {
    if (storageList.hasData('RecipeList')) {
      tempList = storageList.read('RecipeList');

      String nameKey;
      // ignore: non_constant_identifier_names
      String uniqueIDKey = 'uniqueID';
      for (int i = 0; i < tempList.length; i++) {
        final map = tempList[i];
        // ignore: non_constant_identifier_names
        final uniqueID = map[uniqueIDKey];

        nameKey = 'name';

        final recipe = Recipe(
          input: map[nameKey],
        );
        recipe.uniqueID = uniqueID;
        recipe.controller!.restoreIngredients(recipe);
        recipe.controller!.restoreSteps(recipe);

        recipeList.add(recipe);
      }
    }
  }

  FloatingActionButton? getFloatingActionButton() {
    if (editMode.value)
      return FloatingActionButton(
        onPressed: () {
          addRecipe();
        },
        child: Icon(Icons.add),
        heroTag: 'RecipesPage',
      );
    return null;
  }
}
