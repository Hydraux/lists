import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_form.dart';
import 'package:lists/widgets/recipe_card.dart';

class RecipesController extends GetxController {
  late DatabaseReference database;
  String user;

  RxList<Recipe> recipes = RxList<Recipe>([]);

  RxBool editMode = RxBool(false);
  RxInt selectedIndex = RxInt(0);

  RecipesController({required this.user});

  @override
  void onInit() {
    database = FirebaseDatabase.instance.ref('$user/recipes');
    _activateListeners();
    super.onInit();
  }

  void _activateListeners() {
    database.onChildAdded.listen((event) {
      Recipe recipe = Recipe.fromJson(event.snapshot.value as Map);
      recipes.add(recipe);
    });

    database.onChildChanged.listen((event) {
      Recipe databaseRecipe = Recipe.fromJson(event.snapshot.value as Map);
      int index = recipes.indexWhere((Recipe recipe) => recipe.id == databaseRecipe.id);
      recipes[index] = databaseRecipe;
    });
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
