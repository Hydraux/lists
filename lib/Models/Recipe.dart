import 'package:lists/Models/Item.dart';
import 'package:lists/controllers/Recipe.dart';

import 'package:get/get.dart';
import 'package:lists/controllers/Recipes.dart';

class Recipe {
  RecipeController? controller;
  RecipesController? recipesController;
  var name = ''.obs;
  List<String> Steps = [];
  List<Item> Ingredients = [];
  var UID;

  int get IngredientsLength => Ingredients.length;
  int get StepsLength => Steps.length;

  Recipe({required String input, this.recipesController}) {
    if (UID == null) UID = DateTime.now().toString();
    this.controller = Get.put(RecipeController(), tag: UID);
    this.name.value = input;
  }
}
