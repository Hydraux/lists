import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/recipe.dart';

class RecipesController extends GetxController {
  final getStorage = GetStorage();

  RxList<Recipe> recipes = RxList<Recipe>([]);
  List storageList = [];

  RxBool editMode = RxBool(false);
  RxInt selectedIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    restoreRecipes();
  }

  void addRecipe() async {
    Recipe? recipe = await Get.toNamed('/RecipeList/newRecipe');

    if (recipe != null) recipes.add(recipe);
  }

  void updateStorage(Recipe recipe) {
    final storageMap = {};
    final nameKey = 'name';
    final uniqueIDKey = 'uniqueID';

    storageMap[nameKey] = recipe.name.string;
    storageMap[uniqueIDKey] = recipe.uniqueID;

    int index = storageList
        .indexWhere((element) => element[uniqueIDKey] == recipe.uniqueID);
    storageList[index] = storageMap;

    getStorage.write('RecipeList', storageList);
  }

  void removeRecipe(Recipe recipe) {
    final uniqueIDKey = 'uniqueID';

    recipes.removeWhere((element) => element.uniqueID == recipe.uniqueID);
    storageList
        .removeWhere((element) => element[uniqueIDKey] == recipe.uniqueID);

    getStorage.write('RecipeList', storageList);
  }

  void restoreRecipes() {
    if (getStorage.hasData('RecipeList')) {
      storageList = getStorage.read('RecipeList');

      String nameKey;
      // ignore: non_constant_identifier_names
      String uniqueIDKey = 'uniqueID';
      for (int i = 0; i < storageList.length; i++) {
        final map = storageList[i];
        // ignore: non_constant_identifier_names
        final uniqueID = map[uniqueIDKey];

        nameKey = 'name';

        final recipe = Recipe(
          input: map[nameKey],
        );
        recipe.uniqueID = uniqueID;

        recipes.add(recipe);
      }
    }
  }

  FloatingActionButton getFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        addRecipe();
      },
      child: Icon(Icons.add),
      heroTag: 'RecipesPage',
    );
  }
}
