import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/dashboard_controller.dart';
import 'package:lists/controllers/recipes/recipes_controller.dart';
import 'package:lists/controllers/shopping_list_controller.dart';
import 'package:lists/views/recipes/recipes_page.dart';
import 'package:lists/views/shopping_list.dart';
import 'package:lists/views/units_page.dart';

class DashboardPage extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              ShoppingList(),
              RecipesPage(),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.selectedIndex.value == 0
                ? Get.find<ShoppingListController>().addItem()
                : Get.find<RecipesController>().addRecipe();
          },
          child: Icon(Icons.add)),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => controller.onTap(0),
                icon: Icon(
                  Icons.shopping_cart,
                  color: controller.selectedIndex.value == 0
                      ? Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor,
                ),
              ),
              IconButton(
                color: controller.selectedIndex.value == 1
                    ? Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor
                    : Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedItemColor,
                onPressed: () => controller.onTap(1),
                icon: Icon(Icons.book),
              ),
            ],
          ),
        ),
      ),
      /* bottomNavigationBar: Obx(() => BottomNavigationBar(
        type: ,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Shopping List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Recipes',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.adjust_rounded), label: 'Units')
            ],
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onTap,
          )),*/
    );
  }
}
