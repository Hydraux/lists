import 'package:lists/Models/Items/Item.dart';
import 'package:lists/controllers/Recipes/Recipe.dart';

import 'package:get/get.dart';
import 'package:lists/controllers/Recipes/Recipes.dart';

class Recipe {
  RecipeController? controller;
  RecipesController? recipesController;

  var editMode = false.obs;
  var name = ''.obs;
  var UID;

  List<String> Steps = [];
  List<Item> Ingredients = [];

  int get IngredientsLength => Ingredients.length;
  int get StepsLength => Steps.length;

  Recipe({required String input, this.recipesController}) {
    if (UID == null) UID = DateTime.now().toString();
    this.controller = Get.put(RecipeController(), tag: UID);
    this.name.value = input;
  }
}
