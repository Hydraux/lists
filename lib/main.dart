import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/controllers/items/item_controller.dart';
import 'package:lists/controllers/items/units_controller.dart';
import 'package:lists/controllers/recipes/recipe_controller.dart';
import 'package:lists/controllers/recipes/recipes_controller.dart';
import 'package:lists/controllers/shopping_list_controller.dart';
import 'package:lists/views/items/modify_item.dart';
import 'package:lists/views/recipes/new_step.dart';
import 'package:lists/views/dashboard.dart';
import 'package:lists/views/items/new_item.dart';
import 'package:lists/views/recipes/new_recipe.dart';

import 'themes/custom_theme.dart';
import 'views/new_unit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appdata = GetStorage();
  @override
  Widget build(BuildContext context) {
    appdata.writeIfNull('darkmode', false);
    return SimpleBuilder(builder: (_) {
      bool isDarkMode = appdata.read('darkmode');
      return GetMaterialApp(
        theme: isDarkMode ? CustomTheme().darkTheme : CustomTheme().lightTheme,
        initialRoute: '/dashboard',
        getPages: [
          GetPage(
            name: '/dashboard',
            page: () => DashboardPage(),
            binding: DashboardBinding(),
          ),
          GetPage(
            name: '/shoppingList/newItem',
            page: () => NewItem(),
            binding: NewItemBinding(),
            opaque: false,
          ),
          GetPage(
            name: '/ModifyItem',
            page: () => ModifyItem(),
            binding: ModifyItemBinding(),
            opaque: false,
          ),
          GetPage(
            name: '/RecipeList/newRecipe',
            page: () => NewRecipe(),
            binding: NewRecipeBinding(),
            opaque: false,
          ),
          GetPage(
            name: '/RecipeList/Recipe/newStep',
            page: () => NewStep(),
            opaque: false,
          ),
          GetPage(
            name: '/NewUnit',
            page: () => NewUnit(),
            opaque: false,
          ),
        ],
      );
    });
  }

  void toggleTheme() {
    appdata.write('darkmode', !appdata.read('darkmode'));
    Get.changeTheme(appdata.read('darkmode') ? CustomTheme().darkTheme : CustomTheme().lightTheme);
  }
}

class NewItemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemController(null));
  }
}

class ModifyItemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemController(null));
  }
}

class NewRecipeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecipeController());
  }
}

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(ShoppingListController());
    Get.put(RecipesController());
    Get.put(UnitsController());
  }
}
