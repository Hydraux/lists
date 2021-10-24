import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_form.dart';

class RecipesController extends GetxController {
  final getStorage = GetStorage();

  RxList<Recipe> recipes = RxList<Recipe>([]);
  RxList _storageList = RxList([]);

  RxBool editMode = RxBool(false);
  RxInt selectedIndex = RxInt(0);

  @override
  void onInit() {
    restoreRecipes();
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

    storageMap['name'] = recipe.name;
    storageMap['id'] = recipe.id;

    int index = _storageList.indexWhere((element) => element['id'] == recipe.id);
    recipes[recipes.indexWhere((element) => element.id == recipe.id)] = recipe;

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
        );
        List<String> steps = [];
        List? storedSteps = getStorage.read(recipe.id + ':steps');
        if (storedSteps != null)
          storedSteps.forEach((step) {
            steps.add(step);
          });
        recipe = recipe.copyWith(steps: steps);
        recipes.add(recipe);
      });
    }
  }
}
