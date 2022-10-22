import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/items_controller.dart';
import 'package:Recipedia/controllers/steps_controller.dart';
import 'package:Recipedia/models/item.dart';
import 'package:Recipedia/models/recipe.dart';
import 'package:Recipedia/views/recipe_form.dart';

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

  void uploadRecipe(Map JsonRecipe) {
    database.child(JsonRecipe['id']).set(JsonRecipe);
  }

  void createRecipe() async {
    Recipe? recipe = await Get.dialog(RecipeForm());

    if (recipe != null) {
      database.child(recipe.id).set(recipe.toJson());
    }
  }

  Future<Map> removeRecipe(Recipe recipe) async {
    DataSnapshot snapshot = await database.child(recipe.id).get();
    Map JsonRecipe = snapshot.value as Map;
    database.child(recipe.id).remove();
    return JsonRecipe;
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

  void addToShoppingList(Recipe recipe) {
    ItemsController itemsController;
    try {
      itemsController = Get.find<ItemsController>(tag: recipe.id);
    } catch (e) {
      print("ItemsController with tag:${recipe.id} not found, creating new one");
      itemsController = ItemsController(tag: recipe.id);
    }

    itemsController.sendToShoppingList();
  }
}
