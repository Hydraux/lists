import 'package:get/get.dart';
import 'package:lists/controllers/recipes/recipe_controller.dart';
import 'package:lists/controllers/recipes/recipes_controller.dart';
import 'package:lists/models/items/item.dart';

class Recipe {
  RecipeController? controller;
  RecipesController? recipesController;

  var editMode = false.obs;
  var name = ''.obs;
  var uniqueID;

  List<String> steps = [];
  List<Item> ingredients = [];

  int get ingredientsLength => ingredients.length;
  int get stepsLength => steps.length;

  Recipe({required String input, this.recipesController}) {
    if (uniqueID == null) uniqueID = DateTime.now().toString();
    this.controller = Get.put(RecipeController(), tag: uniqueID);
    this.name.value = input;
  }
}
