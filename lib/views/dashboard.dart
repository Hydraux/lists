import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/app_info_controller.dart';
import 'package:Recipedia/controllers/auth_controller.dart';
import 'package:Recipedia/controllers/dashboard_controller.dart';
import 'package:Recipedia/controllers/friends_controller.dart';
import 'package:Recipedia/controllers/recipes_controller.dart';
import 'package:Recipedia/controllers/items_controller.dart';
import 'package:Recipedia/controllers/settings_controller.dart';
import 'package:Recipedia/controllers/units_controller.dart';
import 'package:Recipedia/views/app_info.dart';
import 'package:Recipedia/views/friends.dart';
import 'package:Recipedia/views/profile.dart';
import 'package:Recipedia/views/recipes_page.dart';
import 'package:Recipedia/views/settings.dart';
import 'package:Recipedia/views/shopping_list.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DashboardController controller = DashboardController();
    Get.lazyPut<ItemsController>(
      () => ItemsController(tag: 'shoppingList'),
      tag: 'shoppingList',
    );
    Get.lazyPut<RecipesController>(() => RecipesController(user: FirebaseAuth.instance.currentUser!.uid));

    Get.put<UnitsController>(UnitsController());
    Get.put<SettingsController>(SettingsController());
    // Create empty controllers

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
            child: ListView(
              shrinkWrap: true,
              children: [
                DrawerHeader(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      color: context.theme.dialogBackgroundColor,
                      child: Center(
                        child: Text(
                          'Shopping List',
                          style: TextStyle(fontSize: 30, color: context.theme.textTheme.bodyText1!.color),
                        ),
                      ),
                    )),
                ListTile(
                    onTap: () => Get.to(() => Profile()),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        color: context.theme.textTheme.bodyText2!.color,
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: context.theme.textTheme.bodyText2!.color,
                    )),
                ListTile(
                  onTap: () {
                    try {
                      Get.find<FriendsController>();
                    } catch (e) {
                      Get.lazyPut(() => FriendsController());
                    }
                    Get.to(() => Friends());
                  },
                  title: Text(
                    'Friends',
                    style: TextStyle(
                      color: context.theme.textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.group,
                    color: context.theme.textTheme.bodyText2!.color,
                  ),
                ),
                ListTile(
                  onTap: () => Get.to(() => SettingsPage()),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: context.theme.textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: context.theme.textTheme.bodyText2!.color,
                  ),
                ),
                ListTile(
                  onTap: () {
                    try {
                      Get.find<AppInfoController>();
                    } catch (e) {
                      Get.put(AppInfoController());
                    }
                    Get.to(() => AppInfo());
                  },
                  title: Text(
                    'App Info',
                    style: TextStyle(
                      color: context.theme.textTheme.bodyText2!.color,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.info,
                    color: Get.theme.textTheme.bodyText2!.color,
                  ),
                ),
                ListTile(
                  onTap: () => AuthController().signOut(),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: context.theme.errorColor,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: context.theme.errorColor,
                  ),
                )
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
                        ? context.theme.bottomNavigationBarTheme.selectedItemColor!
                        : context.theme.bottomNavigationBarTheme.unselectedItemColor!,
                  ),
                ),
                IconButton(
                  color: controller.pageIndex.value == 0
                      ? context.theme.bottomNavigationBarTheme.unselectedItemColor!
                      : context.theme.bottomNavigationBarTheme.selectedItemColor!,
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
