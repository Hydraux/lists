import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/settings_controller.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/themes/custom_theme.dart';
import 'package:lists/views/recipes_page.dart';
import 'package:lists/views/settings.dart';
import 'package:lists/views/shopping_list.dart';

class DashboardPage extends GetView<DashboardController> {
  final SettingsController settings = SettingsController();
  @override
  Widget build(BuildContext context) {
    // Create empty controllers

    ItemsController itemsController = ItemsController(tag: 'shoppingList');
    // itemsController.onInit();
    Get.put<ItemsController>(itemsController, tag: 'shoppingList');
    Get.put<RecipesController>(RecipesController());

    UnitsController unitsController = UnitsController();
    //unitsController.onInit();

    Get.put<UnitsController>(unitsController);
    Get.put<SettingsController>(settings);

    return SafeArea(
      child: Scaffold(
        drawer: SafeArea(
          top: false,
          child: Drawer(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Obx(() {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      DrawerHeader(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            color: settings.darkMode.value
                                ? darkTheme.dialogBackgroundColor
                                : lightTheme.dialogBackgroundColor,
                            child: Center(
                              child: Text(
                                'Shopping List',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: settings.darkMode.value
                                        ? darkTheme.textTheme.bodyText1!.color
                                        : lightTheme.textTheme.bodyText1!.color),
                              ),
                            ),
                          )),
                      ListTile(
                          onTap: () => Get.snackbar(
                                'Unimplimented',
                                'Profile is not yet implemented',
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                              ),
                          title: Text(
                            'Profile',
                            style: TextStyle(
                              color: settings.darkMode.value
                                  ? darkTheme.textTheme.bodyText2!.color
                                  : lightTheme.textTheme.bodyText2!.color,
                              fontSize: 16,
                            ),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: settings.darkMode.value
                                ? darkTheme.textTheme.bodyText2!.color
                                : lightTheme.textTheme.bodyText2!.color,
                          )),
                      ListTile(
                        onTap: () => Get.snackbar(
                          'Unimplimented',
                          'Shared lists is not yet implemented',
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                        ),
                        title: Text(
                          'Shared Lists',
                          style: TextStyle(
                            color: settings.darkMode.value
                                ? darkTheme.textTheme.bodyText2!.color
                                : lightTheme.textTheme.bodyText2!.color,
                            fontSize: 16,
                          ),
                        ),
                        leading: Icon(
                          Icons.group,
                          color: settings.darkMode.value
                              ? darkTheme.textTheme.bodyText2!.color
                              : lightTheme.textTheme.bodyText2!.color,
                        ),
                      ),
                      ListTile(
                        // onTap: () => Get.snackbar(
                        //   'Unimplimented',
                        //   'Settings is not yet implemented',
                        //   snackPosition: SnackPosition.BOTTOM,
                        //   colorText: Get.theme.bottomNavigationBarTheme.unselectedItemColor,
                        // ),
                        onTap: () => Get.to(() => SettingsPage()),
                        title: Text(
                          'Settings',
                          style: TextStyle(
                            color: settings.darkMode.value
                                ? darkTheme.textTheme.bodyText2!.color
                                : lightTheme.textTheme.bodyText2!.color,
                            fontSize: 16,
                          ),
                        ),
                        leading: Icon(
                          Icons.settings,
                          color: settings.darkMode.value
                              ? darkTheme.textTheme.bodyText2!.color
                              : lightTheme.textTheme.bodyText2!.color,
                        ),
                      ),
                      ListTile(
                        onTap: () => AuthController().signOut(),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: settings.darkMode.value ? darkTheme.errorColor : lightTheme.errorColor,
                            fontSize: 16,
                          ),
                        ),
                        leading: Icon(
                          Icons.logout,
                          color: settings.darkMode.value ? darkTheme.errorColor : lightTheme.errorColor,
                        ),
                      )
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: controller,
          onPageChanged: (page) => controller.pageIndex.value = page,
          children: [
            ShoppingList(),
            RecipesPage(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.page == 0
                  ? Get.find<ItemsController>(tag: 'shoppingList').createItem()
                  : Get.find<RecipesController>().createRecipe();
            },
            child: Icon(Icons.add)),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => controller.jumpToPage(0),
                  icon: Icon(
                    Icons.shopping_cart,
                    color: getNavIconColor(controller.pageIndex.value, 1),
                  ),
                ),
                IconButton(
                  color: getNavIconColor(controller.pageIndex.value, 2),
                  onPressed: () => controller.jumpToPage(1),
                  icon: Icon(Icons.book),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getNavIconColor(int index, int page) {
    if (settings.darkMode.value) {
      if (controller.pageIndex.value == 0) {
        if (page == 1)
          return darkTheme.bottomNavigationBarTheme.selectedItemColor!;
        else
          return darkTheme.bottomNavigationBarTheme.unselectedItemColor!;
      } else {
        if (page == 2)
          return darkTheme.bottomNavigationBarTheme.selectedItemColor!;
        else
          return darkTheme.bottomNavigationBarTheme.unselectedItemColor!;
      }
    } else {
      if (controller.pageIndex.value == 0) {
        if (page == 1)
          return lightTheme.bottomNavigationBarTheme.selectedItemColor!;
        else
          return lightTheme.bottomNavigationBarTheme.unselectedItemColor!;
      } else {
        if (page == 2)
          return lightTheme.bottomNavigationBarTheme.selectedItemColor!;
        else
          return lightTheme.bottomNavigationBarTheme.unselectedItemColor!;
      }
    }
  }
}
