import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/views/recipes_page.dart';
import 'package:lists/views/shopping_list.dart';

class DashboardPage extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    // Create empty controllers
    Get.put<ItemsController>(ItemsController(tag: 'shoppingList'), tag: 'shoppingList');
    Get.put<RecipesController>(RecipesController());
    Get.put<UnitsController>(UnitsController());

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
                ListView(
                  shrinkWrap: true,
                  children: [
                    DrawerHeader(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Center(
                            child: Text(
                              'Shopping List',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        )),
                    ListTile(
                        onTap: () => Get.snackbar(
                              'Unimplimented',
                              'Profile is not yet implemented',
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                            ),
                        title: Text(
                          'Profile',
                          style: TextStyle(
                            color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                            fontSize: 16,
                          ),
                        ),
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                        )),
                    ListTile(
                      onTap: () => Get.snackbar(
                        'Unimplimented',
                        'Shared lists is not yet implemented',
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                      ),
                      title: Text(
                        'Shared Lists',
                        style: TextStyle(
                          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                          fontSize: 16,
                        ),
                      ),
                      leading: Icon(
                        Icons.group,
                        color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                      ),
                    ),
                    ListTile(
                      onTap: () => Get.snackbar(
                        'Unimplimented',
                        'Settings is not yet implemented',
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                      ),
                      //  onTap: Get.to(Settings()),
                      title: Text(
                        'Settings',
                        style: TextStyle(
                          color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                          fontSize: 16,
                        ),
                      ),
                      leading: Icon(
                        Icons.settings,
                        color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                      ),
                    ),
                    ListTile(
                      onTap: () => AuthController().signOut(),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
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
                    color: controller.pageIndex.value == 0
                        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                        : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                  ),
                ),
                IconButton(
                  color: controller.pageIndex.value == 1
                      ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                      : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
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
}
