import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/models/unit.dart';
import 'package:lists/views/recipe_form.dart';

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

    database.onChildRemoved.listen((event) {
      Recipe databaseRecipe = Recipe.fromJson(event.snapshot.value as Map);
      recipes.removeWhere((Recipe recipe) => databaseRecipe.id == recipe.id);
    });
  }

  void uncheck(Item item) {}

  void createRecipe() async {
    Recipe? recipe = await Get.dialog(RecipeForm());

    if (recipe != null) {
      database.child(recipe.id).set(recipe.toJson());
    }
  }

  void removeRecipe(Recipe recipe) {
    database.child(recipe.id).remove();
  }

  void storeLocally(Recipe recipe) async {
    DatabaseReference localDatabase =
        FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/recipes');

    DatabaseReference recipeReference = database.child(recipe.id);
    DatabaseReference stepsReference = recipeReference.child('steps');
    DatabaseReference ingredientsReference = recipeReference.child('ingredients');

    DatabaseReference localRecipeReference = localDatabase.child(recipe.id);
    DatabaseReference localStepsReference = localRecipeReference.child('steps');
    DatabaseReference localIngredientsReference = localRecipeReference.child('ingredients');

    localRecipeReference.set(recipe.toJson());

    ingredientsReference.get().then((ingredients) => localIngredientsReference.set(ingredients.value as Map));

    stepsReference.get().then((steps) => localStepsReference.set(steps.value));
  }

  void addToShoppingList(Recipe recipe) async {
    ItemsController ingredientsController = Get.find<ItemsController>(tag: recipe.id);
    UnitsController unitsController = Get.find<UnitsController>();
    DatabaseReference friendsUnitsRef = database.parent!.child('units');
    final List<Unit> friendUnits = [];

    await friendsUnitsRef.get().then((snapshot) {
      Map units = snapshot.value as Map;

      units.forEach((key, value) {
        friendUnits.add(Unit.fromJson(value));
      });
    });

    DatabaseReference shoppingListRef =
        FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/shoppingList');

    ingredientsController.checkList.forEach((Item item) {
      //make sure all units being imported exist on users unit list
      if (item.unit != '')
        unitsController.units.firstWhere(
          (unit) => unit.name == item.unit,
          orElse: () {
            //unit is not in local units
            Unit friendUnit = friendUnits.firstWhere((friendUnit) => friendUnit.name == item.unit, orElse: (() {
              unitsController.createUnit(item.unit);
              return Unit(id: 'notFound', index: -1);
            }));

            //add unit if found in
            if (friendUnit.id != 'notFound') unitsController.addUnit(friendUnit);
            return friendUnit;
          },
        );

      item = item.copyWith(checkBox: false);

      shoppingListRef.child(item.id).set(item.toJson());
    });
  }
}
