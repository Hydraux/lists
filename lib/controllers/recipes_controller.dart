import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_form.dart';
import 'package:lists/widgets/recipe_card.dart';

class RecipesController extends GetxController {
  DatabaseReference database = FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/recipes');

  RxList<Recipe> recipes = RxList<Recipe>([]);
  RxList<Widget> recipeWidgets = RxList<Widget>([]);

  RxBool editMode = RxBool(false);
  RxInt selectedIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    _activateListeners();
  }

  void _activateListeners() {
    database.onValue.listen((event) async {
      DataSnapshot snapshot = event.snapshot;
      extractJson(snapshot);
    });
  }

  void extractJson(DataSnapshot snapshot) {
    recipes.value = [];
    recipeWidgets.value = [];

    if (snapshot.value != null) {
      Map map = snapshot.value as Map;

      map.forEach((key, value) {
        recipes.add(Recipe.fromJson(value));
        recipeWidgets.add(RecipeCard(recipe: Recipe.fromJson(value)));
      });
    }
  }

  void uncheck(Item item) {}

  void createRecipe() async {
    Recipe? recipe = await Get.dialog(RecipeForm());

    if (recipe != null) {
      recipes.add(recipe);
      updateStorage(recipe);
    }
  }

  void updateStorage(Recipe recipe) {
    String id = recipe.id;
    final recipeRef = database.child(id);
    Map<String, dynamic> jsonItem = recipe.toJson();
    recipeRef.set(jsonItem);
  }

  void removeRecipe(Recipe recipe) {
    database.child(recipe.id).remove();
    recipes.removeWhere((element) => element.id == recipe.id);
  }
}
