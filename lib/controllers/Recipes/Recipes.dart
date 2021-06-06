import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Models/Recipes/Recipe.dart';

class RecipesController extends GetxController {
  final storageList = GetStorage();

  List tempList = [];
  List<Recipe> RecipeList = [];

  var editMode = false.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    restoreRecipes();
  }

  int get RecipeListLength => RecipeList.length;

  void addRecipe() async {
    final recipe = await Get.toNamed('/RecipeList/newRecipe');
    final storageMap = {};
    final nameKey = 'name';
    final UIDKey = 'UID';

    if (recipe == null) return; //cancel was pressed
    storageMap[nameKey] = recipe.name.value;
    storageMap[UIDKey] = recipe.UID;

    tempList.add(storageMap);
    storageList.write('RecipeList', tempList);
    RecipeList.add(recipe);
  }

  void updateValue(Recipe recipe) {
    final storageMap = {};
    final nameKey = 'name';
    final UIDKey = 'UID';

    storageMap[nameKey] = recipe.name.string;
    storageMap[UIDKey] = recipe.UID;

    int index = tempList.indexWhere((element) => element[UIDKey] == recipe.UID);
    tempList[index] = storageMap;

    storageList.write('RecipeList', tempList);
  }

  void removeRecipe(Recipe recipe) {
    final UIDKey = 'UID';

    RecipeList.removeWhere((element) => element.UID == recipe.UID);
    tempList.removeWhere((element) => element[UIDKey] == recipe.UID);

    storageList.write('RecipeList', tempList);
  }

  void restoreRecipes() {
    if (storageList.hasData('RecipeList')) {
      tempList = storageList.read('RecipeList');

      String nameKey;
      // ignore: non_constant_identifier_names
      String UIDKey = 'UID';
      for (int i = 0; i < tempList.length; i++) {
        final map = tempList[i];
        // ignore: non_constant_identifier_names
        final UID = map[UIDKey];

        nameKey = 'name';

        final recipe = Recipe(
          input: map[nameKey],
        );
        recipe.UID = UID;
        recipe.controller!.restoreIngredients(recipe);
        recipe.controller!.restoreSteps(recipe);

        RecipeList.add(recipe);
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
