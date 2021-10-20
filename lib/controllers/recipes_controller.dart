import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/steps_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_form.dart';

class RecipesController extends GetxController {
  final getStorage = GetStorage();

  RxList<Recipe> recipes = RxList<Recipe>([]);
  RxList _storageList = RxList([]);

  RxBool editMode = RxBool(false);
  RxInt selectedIndex = RxInt(0);

  Map<String, ItemsController> ingredientControllers = Map();
  Map<String, StepsController> stepControllers = Map();

  @override
  void onInit() {
    restoreRecipes();
    restoreControllers();
    super.onInit();
  }

  void createRecipe() async {
    Recipe? recipe = await Get.dialog(RecipeForm());

    if (recipe != null) {
      recipes.add(recipe);
      updateStorage(recipe);
    }
  }

  void updateStorage(Recipe recipe) {
    final storageMap = {};
    final ingredientsMap = {};
    final stepsMap = {};

    storageMap['name'] = recipe.name;
    storageMap['id'] = recipe.id;

    if (ingredientControllers[recipe.id] == null) ingredientControllers[recipe.id] = ItemsController('ingredient');
    if (stepControllers[recipe.id] == null)
      stepControllers[recipe.id] = StepsController(recipe: recipe, controller: this);

    if (recipe.ingredients != null) {
      recipe.ingredients!.forEach((ingredient) {
        ingredientsMap['name'] = ingredient.name;
        ingredientsMap['id'] = ingredient.id;
        ingredientsMap['unit'] = ingredient.unit;
        ingredientsMap['quantity'] = ingredient.quantity;
      });
    }
    if (recipe.steps != null) {
      recipe.steps!.forEach((step) {
        stepsMap['step'] = step;
      });
    }

    int index = _storageList.indexWhere((element) => element['id'] == recipe.id);

    if (index == -1) {
      _storageList.add(storageMap);
    } else {
      _storageList[index] = storageMap;
    }

    getStorage.write('RecipeList', _storageList);
  }

  void removeRecipe(Recipe recipe) {
    final idKey = 'id';

    recipes.removeWhere((element) => element.id == recipe.id);
    _storageList.removeWhere((element) => element[idKey] == recipe.id);
  }

  void restoreRecipes() {
    if (getStorage.hasData('RecipeList')) {
      _storageList.value = getStorage.read('RecipeList');

      _storageList.forEach((element) {
        Recipe recipe = Recipe(
          id: element['id'],
          name: element['name'],
          ingredients: element['ingredients'],
          steps: element['steps'],
        );
        recipes.add(recipe);
      });
    }
  }

  void restoreControllers() {
    recipes.forEach((recipe) {
      ingredientControllers[recipe.id] = ItemsController('ingredient');
      stepControllers[recipe.id] = StepsController(recipe: recipe, controller: this);
    });
  }
}
