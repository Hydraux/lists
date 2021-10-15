import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/item.dart';

class Recipe {
  RecipesController? recipesController;

  RxList<Item> ingredients = RxList<Item>([]);

  var editMode = false.obs;
  var name = ''.obs;
  var uniqueID;

  Recipe({required String input, this.recipesController}) {
    if (uniqueID == null) uniqueID = DateTime.now().toString();
    this.name.value = input;
  }
}
