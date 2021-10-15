import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_form.dart';

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

  void addRecipe() async {
    Recipe? recipe = await Get.to(() => RecipeForm());

    if (recipe != null) recipes.add(recipe);
  }

  void updateStorage(Recipe recipe) {
    final storageMap = {};
    final nameKey = 'name';
    final idKey = 'id';

    storageMap[nameKey] = recipe.name;
    storageMap[idKey] = recipe.id;

    int index = storageList.indexWhere((element) => element[idKey] == recipe.id);
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
      storageList = getStorage.read('RecipeList');

      String nameKey;
      // ignore: non_constant_identifier_names
      String idKey = 'id';
      for (int i = 0; i < storageList.length; i++) {
        final map = storageList[i];
        // ignore: non_constant_identifier_names
        final id = map[idKey];

        nameKey = 'name';

        final recipe = Recipe(
          name: map[nameKey],
          id: id,
        );

        recipes.add(recipe);
      }
    }
  }
}
