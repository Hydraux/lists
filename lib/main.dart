import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/views/dashboard.dart';

import 'themes/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  //create empty controllers
  Get.put<DashboardController>(DashboardController());
  Get.put<ItemsController>(ItemsController('shoppingList'), tag: 'shoppingList');
  Get.put<RecipesController>(RecipesController());
  Get.put<UnitsController>(UnitsController());

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
        theme: isDarkMode ? darkTheme : lightTheme,
        home: DashboardPage(),
      );
    });
  }

  void toggleTheme() {
    appdata.write('darkmode', !appdata.read('darkmode'));
    Get.changeTheme(appdata.read('darkmode') ? darkTheme : lightTheme);
  }
}
