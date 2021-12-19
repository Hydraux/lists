import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/recipe_form.dart';

class RecipesController extends GetxController {
  final database = FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/recipes');

  RxList<Recipe> recipes = RxList<Recipe>([]);

  RxBool editMode = RxBool(false);
  RxInt selectedIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
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
    recipes.removeWhere((element) => element.id == recipe.id);
  }
}
