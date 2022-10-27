import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/items_controller.dart';
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
      Recipe recipe;
      try {
        Recipe recipe = Recipe.fromJson(event.snapshot.value as Map);
        recipes.add(recipe);
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
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

    DatabaseReference localRecipeReference = localDatabase.child(recipe.id);
    DatabaseReference localStepsReference = localRecipeReference.child('steps');
    DatabaseReference localIngredientsReference = localRecipeReference.child('ingredients');

    Map JsonRecipe = recipe.toJson();

    if (JsonRecipe['servings'] == null) {
      JsonRecipe['servings'] = 1;
    }

    try {
      await localRecipeReference.set(JsonRecipe);
    } catch (e) {
      print("error: $e");
    }

    Map JsonIngredients = {};
    List JsonSteps = [];

    recipe.ingredients.forEach((Item ingredient) {
      JsonIngredients[ingredient.id] = ingredient.toJson();
    });
    localIngredientsReference.set(JsonIngredients);

    JsonSteps = List.from(recipe.steps);
    localStepsReference.set(JsonSteps);
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

  changeNumServings(String newValue, Recipe recipe) async {
    ItemsController ingredients = Get.find<ItemsController>(tag: recipe.id);
    DataSnapshot servingsSnapshot = await database.child('${recipe.id}/servings').get();
    int oldQuantity = servingsSnapshot.value as int;
    if (newValue != '' && newValue != '0') {
      double newQuantity = double.parse(newValue);
      double multiplier = newQuantity / oldQuantity;
      await database.child('${recipe.id}/servings').set(newQuantity);

      recipe = recipe.copyWith(servings: int.parse(newValue));
      ingredients.databaseItems.forEach((Item item) {
        double newQuantity = item.quantity! * multiplier;
        item = item.copyWith(quantity: newQuantity);
        ingredients.uploadItem(item);
      });
    }
  }

  changeCookTime(String value, Recipe recipe) {
    database.child('${recipe.id}/cookTime').set(value);
  }

  changePrepTime(String value, Recipe recipe) {
    database.child('${recipe.id}/prepTime').set(value);
  }

  changeNotes(String value, Recipe recipe) {
    database.child('${recipe.id}/notes').set(value);
  }
}
