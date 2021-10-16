import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_form.dart';
import 'package:lists/views/step_form.dart';

class RecipesController extends GetxController {
  final getStorage = GetStorage();

  RxList<Recipe> recipes = RxList<Recipe>([]);
  List storageList = [];

  RxBool editMode = RxBool(false);
  RxInt selectedIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    restoreRecipes();
  }

  void createRecipe() async {
    Recipe? recipe = await Get.to(() => RecipeForm());

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
    recipe.ingredients.forEach((ingredient) {
      ingredientsMap['name'] = ingredient.name;
      ingredientsMap['id'] = ingredient.id;
      ingredientsMap['unit'] = ingredient.unit;
      ingredientsMap['quantity'] = ingredient.quantity;
    });
    recipe.steps.forEach((step) {
      stepsMap['step'] = step;
    });

    int index = storageList.indexWhere((element) => element['id'] == recipe.id);
    storageList[index] = storageMap;

    getStorage.write('RecipeList', storageList);
  }

  void removeRecipe(Recipe recipe) {
    final idKey = 'id';

    recipes.removeWhere((element) => element.id == recipe.id);
    storageList.removeWhere((element) => element[idKey] == recipe.id);

    getStorage.write('RecipeList', storageList);
  }

  void restoreRecipes() {
    if (getStorage.hasData('RecipeList')) {
      final Map storageList = getStorage.read('RecipeList');

      storageList.forEach((key, value) {
        Recipe recipe = Recipe(
          id: value['id'],
          name: value['name'],
          ingredients: value['ingredients'],
          steps: value['steps'],
        );
        recipes.add(recipe);
        updateStorage(recipe);
      });
    }
  }

  void addStep(context, Recipe recipe) async {
    List<String> steps = recipe.steps;
    String? step = await Get.to(() => StepForm());
    if (step == null) return; //cancel was pressed
    final Recipe temp = recipe.copyWith(steps: steps);
    updateStorage(temp);
  }

  void removeStep(Recipe recipe, String step) {
    recipe.steps.remove(step);

    updateStorage(recipe);
  }

  void modifyStep(Recipe recipe, String step, int index) {
    recipe.steps[index] = step;
    updateStorage(recipe);
  }
}
